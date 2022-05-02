BENCHMARK_DIR=$1
TESTS_DIR=$2
FIRST_ROUND=$3
LAST_ROUND=$4


CONFIGS_CSV_DIR="$BENCHMARK_DIR/configurations_ff.csv"
PROJECTS_CSV_DIR="$BENCHMARK_DIR/projects_sf110_fix.csv"

echo "Set class separator to false"
. scripts/test/prepare_tests.sh $CONFIGS_CSV_DIR $PROJECTS_CSV_DIR $TESTS_DIR $FIRST_ROUND $LAST_ROUND


echo "compiling the generated tests"
. scripts/test/compile_tests.sh $BENCHMARK_DIR $CONFIGS_CSV_DIR $PROJECTS_CSV_DIR $TESTS_DIR $FIRST_ROUND $LAST_ROUND