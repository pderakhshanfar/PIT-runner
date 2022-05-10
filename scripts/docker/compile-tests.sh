FIRST_ROUND=$1
LAST_ROUND=$2
LOG_NAME=$3


docker exec -it pit-runner-container bash -c ". scripts/compile-tests.sh benchmark results $FIRST_ROUND $LAST_ROUND > consoleLog/$LOG_NAME.log 2>&1"