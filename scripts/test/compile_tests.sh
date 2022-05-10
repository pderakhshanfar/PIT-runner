

BENCHMARK_DIR=$1
CONFIGS_CSV_DIR=$2 
PROJECTS_CSV_DIR=$3
TESTS_DIR=$4
FIRST_ROUND=$5
LAST_ROUND=$6
echo "$PROJECTS_CSV_DIR"
TIMEOUT=10m

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
  

  project_directory="$BENCHMARK_DIR/projects/$project"
  projectCP=$(find $project_directory -name "*.jar" -type f -printf '%p:')



  

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
        echo "$resultDir"
          echo "Compiling scaffolding tests"
          for scaffoldingTest in `find $resultDir -name "*_scaffolding.java" -type f`; do
            javac -cp "$projectCP:$(cat libs/test_execution/classpath.txt)" $scaffoldingTest
          done

          echo "Compiling the main test class"
          for mainTest in `find $resultDir -name "*_ESTest.java" -type f`; do
            javac -cp "$projectCP:$resultDir:$(cat libs/test_execution/classpath.txt)" $mainTest 
          done
        else
            echo "WARNING: directory $resultDir does not exist!"
        fi
    done

  done < $CONFIGS_CSV_DIR



done < $PROJECTS_CSV_DIR