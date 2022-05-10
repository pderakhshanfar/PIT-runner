FIRST_ROUND=$1
LAST_ROUND=$2
LIMIT=$3
LOG_NAME=$4


docker exec -it pit-runner-container bash -c ". scripts/calculate-mutation-score.sh benchmark code results $FIRST_ROUND $LAST_ROUND $LIMIT > consoleLog/$LOG_NAME.log 2>&1"