import sys,os, csv


configuration_dir=sys.argv[1]
projects_dir=sys.argv[2]
first_round=int(sys.argv[3])
last_round=int(sys.argv[4])
pit_report_dir=sys.argv[5]


def parse_mutation_values(htmlReport):
    first_bar_passed=False
    for line in open(htmlReport, "r"):
        if '<div class="coverage_bar">' in line:
            if first_bar_passed:
                percentage=line.split('<td>')[1].split(" <div")[0][:-1]
                number=line.split('<div class="coverage_legend">')[1].split("</div>")[0]
                killed=number.split("/")[0]
                total=number.split("/")[1]
                break
            else:
                first_bar_passed=True
    
    return percentage, killed, total

# Configs
final_list=[]
with open(configuration_dir, 'r') as _filehandler_config:
    config_csv_file_reader = csv.DictReader(_filehandler_config)
    for row_config in config_csv_file_reader:
        configuration_name=row_config["configuration_name"]
        print("Collecting PIT results for config "+configuration_name)
        # Projects
        with open(projects_dir, 'r') as _filehandler_project:
            project_csv_file_reader = csv.DictReader(_filehandler_project)
            for row_project in project_csv_file_reader:
                project=row_project["project"]
                class_name_dotted=row_project["class"]
                class_name_underlined=class_name_dotted.replace(".","_")
                print("Project: "+project+" | Class: "+class_name_underlined)
                # Rounds
                for round in range(first_round,last_round+1):
                    print("Round: "+str(round))
                    tmp_directory_name=configuration_name+"-"+project+"-"+class_name_underlined+"-"+str(round)
                    index_dir=os.path.join(pit_report_dir,tmp_directory_name,"index.html")
                    exists=os.path.exists(index_dir)
                    print(index_dir+" exists? "+str(exists))
                    if exists:
                        temp_dict={"configuration" : configuration_name, "project" : project,
                         "class" : class_name_dotted, "round" : round}
                        temp_dict["mutation_score"], temp_dict["killed_mutants"], temp_dict["total_mutants"]=parse_mutation_values(index_dir)
                        print ("Score: "+temp_dict["mutation_score"]+ "% Killed: "+temp_dict["killed_mutants"]+"/"+temp_dict["total_mutants"])
                        final_list.append(temp_dict)


print("All results are gathered : \n Saving the CSV file ...")
fieldnames = ["configuration", "project", "class", "round", "killed_mutants", "total_mutants", "mutation_score"]
final_output_dir = os.path.join(pit_report_dir, "..","mutation_scores.csv")
final_output_file = open(final_output_dir,"wb")
final_output_csv_writer = csv.writer(final_output_file)

final_output_csv_writer.writerow(fieldnames)

# Print collected rows
for entry in final_list:
    row = []
    for field in fieldnames:
        row.append(entry[field])
    final_output_csv_writer.writerow(row)


final_output_file.close()