#!/usr/bin/env bash
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

curl -s https://codecov.io/bash > $SCRIPT_PATH/codecov;

chmod +x $SCRIPT_PATH/codecov