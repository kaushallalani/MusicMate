#!/bin/sh

echo "**************************"

CONFIG_FOLDER_PATH="config"
ENVFILE=".env"

case "$1" in
    "-d")
    ENVIRONMENT="Development"
    ENVIRONMENTVAR="dev-"
    sleep 1s
    ;;
    "-t")
    ENVIRONMENT="Testing"
    ENVIRONMENTVAR="testing-"
    sleep 1s
    ;;
    "-p")
    ENVIRONMENT="Production"
    ENVIRONMENTVAR="prod-"
    sleep 1s
    echo ""
    echo "!!!! Project Environment MOVED TO PRODUCTION. Be Careful !!!!"
    echo ""
    sleep 1s
    ;;
    *)
    echo "Command not found"
    echo "[-d Development] [-t Testing] [-p Production]"
    exit 1
    ;;
esac

ENV="$CONFIG_FOLDER_PATH/$ENVIRONMENTVAR$ENVFILE"


if [ -f "$ENV" ]; then
    cp $ENV .env
else 
    echo "Environment config file not found: $ENV"
    exit 1
fi 

echo "Successfully moved to $ENVIRONMENT Environment"