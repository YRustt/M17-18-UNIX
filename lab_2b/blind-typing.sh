#!/usr/bin/env bash


GREEN_BACKGROUND="\033[42m"
RED_BACKGROUND="\033[41m"
YELLOW_BACKGROUND="\033[43m"
WHITE_FONT_COLOR="\033[30m"
BOLD_FONT="\033[1m"

GOOD_SETTINGS="${GREEN_BACKGROUND}${WHITE_FONT_COLOR}"
WARNING_SETTINGS="${YELLOW_BACKGROUND}${WHITE_FONT_COLOR}"
ERROR_SETTINGS="${RED_BACKGROUND}${WHITE_FONT_COLOR}"
DEFAULT_SETTINGS="\033[0m"


REPEAT_STRING="?"
COUNT_CORRECT_ANSWERS=0
COUNT_ALL_ANSWERS=0


function exit_ {
    local PERCENT=100
    if [ ${COUNT_ALL_ANSWERS} -ne 0 ]
    then
        local PERCENT=$(( ${COUNT_CORRECT_ANSWERS} / ${COUNT_ALL_ANSWERS} * 100 ))
    fi

    local EXIT_PHRASE="${GOOD_SETTINGS} Number of correct answers: ${COUNT_CORRECT_ANSWERS}\n
        Number of all answers: ${COUNT_ALL_ANSWERS}\n
        Percentage of correct answers: ${PERCENT}${DEFAULT_SETTINGS}"
    echo -e ${EXIT_PHRASE}

    exit 0
}

trap exit_ SIGINT


function say_line {
    echo "$1" | festival --tts --language english
}


function welcome {
    local INITIAL_PHRASE="Type the phrases you hear. Type a single question mark character to repeat, empty line to finish."
    say_line "${INITIAL_PHRASE}"
}


function download {
    echo "download"
}


function read_file {
    readarray -t LINES < "$1"
}


function get_random_line {
    local RAND=$[${RANDOM} % ${#LINES[@]}]
    RANDOM_LINE="${LINES[${RAND}]}"
}


function compare_lines {
    return 1
}


welcome

FILE="phrases.txt"
if [[ -s ${FILE} ]]
then
    download
fi
read_file ${FILE}


while true
do
    get_random_line
    say_line "${RANDOM_LINE}"

    while read -s USER_LINE
    do
        if [ -z "${USER_LINE}" ]
        then
            exit_
        elif [ ${USER_LINE} = ${REPEAT_STRING} ]
        then
            say_line "${RANDOM_LINE}"
            continue
        fi

        if compare_lines ${USER_LINE} ${RANDOM_LINE}
        then
            break
        else
            echo "Expected: \"${RANDOM_LINE}\" and Typed: \"${USER_LINE}\""
        fi
    done < /dev/stdin
done
