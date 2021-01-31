#!/usr/bin/env bash

CURRENT_UNIT_TEST=1
function run_unit_test
{
  API_URI="http://localhost:8080/api"
  UNIT_FAILED="\e[31mFailed\e[0m"
  UNIT_SUCCESS="\e[32mSuccess\e[0m"
  ###
  PARAM_DESCRIPTION="$1"
  PARAM_EXPECTED_CODE="$2"
  PARAM_API_ENDPOINT="$3"
  PARAM_API_ACTION="$4"
  PARAM_API_PAYLOAD="$5"

  echo -n -e "${CURRENT_UNIT_TEST}) [\e[36m${PARAM_API_ACTION} \e[1;30m${API_URI}/\e[0;36m${PARAM_API_ENDPOINT}\e[0m] ${PARAM_DESCRIPTION}: "
  RET=$(curl -o /dev/null -s -w "%{http_code}\n" -X ${PARAM_API_ACTION} "${API_URI}/${PARAM_API_ENDPOINT}" -H "accept: */*" -H "Content-Type: application/json" -d "${PARAM_API_PAYLOAD}")
  if [ $RET -eq $PARAM_EXPECTED_CODE ]; then
    echo -e "$UNIT_SUCCESS"
  else
    echo -e "$UNIT_FAILED with code \e[36m$RET\e[0m"
  fi
  ((CURRENT_UNIT_TEST++))
}

###############################################################################

function check_if_api_is_running
{
  HEALTH_URI="http://localhost:8080/health"

  echo -n ">> Waiting for API to start..."

  # Wait until the health API starts to reply
  while [ ! $(curl -s -f $HEALTH_URI) ]
  do
    echo -n "."
    sleep 0.5
  done

  # Wait until the health API says it's UP
  STATUS=$(curl -s $HEALTH_URI | jq -r .status)
  while [ $STATUS != "UP" ]
  do
      echo -n "."
      sleep 0.5
      STATUS=$(curl -s $HEALTH_URI | jq -r .status)
  done
  echo "started!"
}

function run_unit_tests
{
  echo ">> Running unit tests:"
  ###
  run_unit_test "It should be able to create a user" 201 "profile" "POST" "$(jq -n '{
    "id": 1234,
    "name": "testOpsUser",
    "lastPlayedVersion": "1.2.3",
    "lastPlayed": 1,
    "language": "en",
    "ageRestricted": true,
    "version": 123,
    "serialVersionUID": 0,
    "_persistence_fetchGroup": {}
  }')"
  ###
  run_unit_test "It should be able to update the previous created user info" 200 "profile" "PUT" "$(jq -n '{
    "id": 1234,
    "name": "testOpsUser",
    "lastPlayedVersion": "1.2.4",
    "lastPlayed": 1,
    "language": "en",
    "ageRestricted": true,
    "version": 124,
    "serialVersionUID": 0,
    "_persistence_fetchGroup": {}
  }')"
  ###
  run_unit_test "It should be able to get all available users" 200 "profile" "GET" ""
  ###
  run_unit_test "It should be able to get the previous created user info" 200 "profile/1234" "GET" ""
  ###
  run_unit_test "It should be able to delete the previous created user" 200 "profile/1234" "DELETE" ""
  ###
  echo ">> Unit Tests completed."
}

# Check if an action was provided
if [ -z "$1" ]; then
  echo "No action given. Please use any of the expected ones in the list: start, stop, restart, inspect, test, clean, rebuild"
fi

# Run specific code based on the action
case $1 in
  clean)
    docker-compose down -v --rmi all --remove-orphans
    ;;
  start)
    docker-compose up -d
    check_if_api_is_running
    ;;
  stop)
    docker-compose down
    ;;
  restart)
    docker-compose restart
    ;;
  inspect)
    docker-compose logs -f
    ;;
  test)
    run_unit_tests
    ;;
  rebuild)
    docker-compose up -d --build api-gradle
    check_if_api_is_running
    ;;
esac
