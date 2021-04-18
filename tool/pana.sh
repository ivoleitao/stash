#!/usr/bin/env bash

MIN_SCORE=${1:-80} 
PACKAGE=${PWD##*/} 

SCORES=$(pana --no-warning 2>&1 | tail -1 | grep -o -E '[0-9]+\/[0-9]+')
if [[ "$SCORES" =~ ([[:digit:]]*)\/([[:digit:]]*) ]]; then
    GRANTED_POINTS=${BASH_REMATCH[1]}
    MAX_POINTS=${BASH_REMATCH[2]} 

    SCORE=$(( $GRANTED_POINTS * 100 / $MAX_POINTS ))
    if (( $SCORE < $MIN_SCORE )); then
        echo "score $SCORE% is bellow $MIN_SCORE%"
        exit 1
    else
        echo "score: $SCORE%"
    fi
else
    echo "score was not successfully parsed"
    exit 1
fi


