BENCHMARK_DIR=$1
SRC_DIR=$2
TESTS_DIR=$3
FIRST_ROUND=$4
LAST_ROUND=$5
LIMIT=$6


CONFIGS_CSV_DIR="$BENCHMARK_DIR/configurations_ff.csv"
PROJECTS_CSV_DIR="$BENCHMARK_DIR/projects_sf110_fix.csv"


OLDIFS=$IFS
IFS=,


PROJECTS_TITLE_PASSED=0
while read project class
do

    # skip the title row
    if [[ "$PROJECTS_TITLE_PASSED" -eq "0" ]]; then
        PROJECTS_TITLE_PASSED=1
        continue
    fi


    projectCP=""
    project_directory="$BENCHMARK_DIR/projects/$project"
    
    find $project_directory -name "*.jar" -type f -print0 | while read -d $'\0' jar_file
    do 
        projectCP="$projectCP$jar_file:"
    done
    
    # continue


    CONFIGS_TITLE_PASSED=0
    while read configuration_name configuration
    do
        if [[ "$CONFIGS_TITLE_PASSED" -eq "0" ]]; then
            CONFIGS_TITLE_PASSED=1
            continue
        fi  

        BUDGET=${configuration_name#*_}

        for ((round=FIRST_ROUND;round<=LAST_ROUND;round++))
        do
            resultDir="results/results-$BUDGET/results/$configuration_name/$project/${class//[.]/_}/tests/$round"

            if [[ -d $resultDir ]]; then
                # echo "$resultDir found!"
                outDir="data/pit/$configuration_name/$project-$class-$round"
                . scripts/pit/run-pit.sh $configuration_name $round $project ${class//[.]/_} $resultDir $outDir $projectCP $SRC_DIR
            else
                echo "WARNING: directory $resultDir does not exist!"
            fi

            # stop the runner if the script reaches to the maximum number of instances
            while (( $(pgrep -l java | wc -l) >= $LIMIT ))
            do
                sleep 1
            done
        done

    done < $CONFIGS_CSV_DIR

done < $PROJECTS_CSV_DIR


# Prevent the end of script while we still have some running PIT instances 
while (( $(pgrep -l java | wc -l) > 0 ))
do
    sleep 1
done