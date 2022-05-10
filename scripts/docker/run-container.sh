#inputs 
BENCHMARK_DIR=$1
BENCHMARK_BN=$(basename $BENCHMARK_DIR)

SRC_DIR=$2
SRC_BN=$(basename $SRC_DIR)

TESTS_DIR=$3
TESTS_BN=$(basename $TESTS_DIR)

# After building the the image, we run the container
docker run -dit -u ${UID} --name pit-runner-container  \
--mount type=bind,source="$(pwd)/consoleLog",target=/experiment/consoleLog \
--mount type=bind,source="$(pwd)/data",target=/experiment/data \
--mount type=bind,source="$(pwd)/pit-outputs",target=/experiment/pit-outputs \
--mount type=bind,source="$(pwd)/scripts",target=/experiment/scripts \
--mount type=bind,source="$(pwd)/$BENCHMARK_DIR",target=/experiment/benchmark \
--mount type=bind,source="$(pwd)/$SRC_DIR",target=/experiment/code \
--mount type=bind,source="$(pwd)/$TESTS_DIR",target=/experiment/results \
pit-runner-img
