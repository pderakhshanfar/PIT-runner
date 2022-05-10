configuration_name=$1
round=$2
project=$3
class_name=$4
resultDir=$5
outDir=$6
projectCP=$7
src_dir=$8

classPaths="$(cat libs/pitest/classpath.txt)$projectCP$(cat libs/test_execution/classpath.txt)$resultDir"
mutableClassPaths=$( python scripts/pit/export_mutable_cps.py $classPaths $project )
sourceDirs="$src_dir/$project/src/main/java"

for mainTest in `find $resultDir -name "*_ESTest.java" -type f`; do
    testSuiteName=$(basename "$mainTest")
    testClassName=${class_name//[_]/.}"_ESTest"
    # ${testSuiteName/.java/}
    echo ">> $testSuiteName - $testClassName"
done


executionLogDir="pit-outputs/logs/$configuration_name-$project-$class_name-$round.txt"
reportDir="pit-outputs/reports/$configuration_name-$project-$class_name-$round/"


echo "CP: "$classPaths
echo "testClassName: $testClassName"
# # Run PIT
java -cp $classPaths org.pitest.mutationtest.commandline.MutationCoverageReport \
    --reportDir $reportDir \
    --targetClasses ${class_name//[_]/.} \
    --targetTests $testClassName \
    --testPlugin evosuite \
    --sourceDirs "$sourceDirs" \
    --mutableCodePaths "$mutableClassPaths" \
    --mutators ALL \
    --threads 10 \
    --timestampedReports=false \
    --outputFormats "HTML,XML,CSV" > "$executionLogDir" 2>&1 & 