## inputs
pid=$1

configuration_name=$2
round=$3
project=$4
class_name=$5
logFile=$6
resultDir=$7
outDir=$8
projectCP=$9
src_dir=${10}
##

echo "Parsing $pid"
## wait for the process to finish
while kill -0 "$pid"; do
    sleep 1
done

exists=$(python scripts/pit/exists_in_file.py "$logFile" "did not pass without mutation")


if [[ "$exists" == "TRUE" ]]
then
    echo "A problem in the PIT execution has been found."
    echo "Fixing the problem ..."

    failedClass=$(python scripts/pit/detect_failing_class.py "$logFile" "did not pass without mutation")
    failedTest=$(python scripts/pit/detect_failing_test.py "$logFile" "did not pass without mutation")

    # Add @Ignore to failing tests
    for mainTest in `find $resultDir -name "*_ESTest.java" -type f`; do
        echo "Add ignore to $failedTest in $mainTest"
        java -jar libs/IgnoreAdder.jar $mainTest "$failedTest"
        classPaths="$(cat libs/pitest/classpath.txt)$projectCP$(cat libs/test_execution/classpath.txt)$resultDir"

        javac -cp "$classPaths" $mainTest
    done


    echo "Problem has been fixed."
    echo "Rerunning the PIT execution ..."
    . scripts/pit/run-pit.sh $configuration_name $round $project $class_name $resultDir $outDir $projectCP $src_dir &
else
    echo "PIT execution is finished. Execution log: $logFile"
fi