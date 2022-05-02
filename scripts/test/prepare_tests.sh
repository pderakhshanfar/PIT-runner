CONFIGS_CSV_DIR=$1 
PROJECTS_CSV_DIR=$2
TESTS_DIR=$3
FIRST_ROUND=$4
LAST_ROUND=$5

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


  CONFIGS_TITLE_PASSED=0
  while read configuration_name configuration
  do
    if [[ "$CONFIGS_TITLE_PASSED" -eq "0" ]]; then
        CONFIGS_TITLE_PASSED=1
        continue
    fi

    BUDGET=${configuration_name#*_}
    # echo "$configuration_name --> $BUDGET"
    


    for ((round=FIRST_ROUND;round<=LAST_ROUND;round++))
    do  
        resultDir="results/results-$BUDGET/results/$configuration_name/$project/${class//[.]/_}/tests/$round"
        
        # edit tests
        if [[ -d $resultDir ]]; then
            for mainTest in `find $resultDir -name "*_ESTest.java" -type f`; do
                echo "Edit the main test class $mainTest"
                python scripts/test/separate-loader-editor.py $mainTest
            done
        else
            echo "WARNING: directory $resultDir does not exist!"
        fi
    done






  done < $CONFIGS_CSV_DIR



done < $PROJECTS_CSV_DIR