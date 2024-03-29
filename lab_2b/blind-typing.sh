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
CORRECT_ANSWER_STRING="This is the correct answer"
WRONG_ANSWER_STRING="This is the wrong answer"
COUNT_WRONG_ANSWERS=0
COUNT_ALL_ANSWERS=0


function exit_ {
    if [ -n "${OLD_IFS}" ]
    then
        IFS=${OLD_IFS}
    fi

    local PERCENT=0
    if [ ${COUNT_ALL_ANSWERS} -ne 0 ]
    then
        local PERCENT=`echo "scale=2; ${COUNT_WRONG_ANSWERS} / ${COUNT_ALL_ANSWERS} * 100" | bc`
    fi

    local EXIT_PHRASE="${GOOD_SETTINGS} Number of wrong answers: ${COUNT_WRONG_ANSWERS} \n
        Number of all answers: ${COUNT_ALL_ANSWERS} \n
        Percentage of wrong answers: ${PERCENT}% ${DEFAULT_SETTINGS}"
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
    # http://1001truisms.webs.com/truisms.htm
    local URL="https://paste.ee/d/53y85/0"
    curl ${URL} -o "$1" 2>/dev/null
}


function read_file {
    readarray -t LINES < "$1"
}


function get_random_line {
    local RAND=$[${RANDOM} % ${#LINES[@]}]
    RANDOM_LINE="${LINES[${RAND}]}"
}


function compare_lines {
    local REGEX="s/[[:space:]]\+/ /g;s/[[:alpha:]]/\L&/g;s/[^[:alpha:][:space:]]//g"
    local LINE1=`echo $1 | sed ${REGEX}`
    local LINE2=`echo $2 | sed ${REGEX}`

    (( COUNT_ALL_ANSWERS++ ))
    if [ "${LINE1}" = "${LINE2}" ]
    then
        return 0
    else
        (( COUNT_WRONG_ANSWERS++ ))
        return 1
    fi
}


welcome
OLD_IFS=${IFS}
IFS=''

FILE="phrases.txt"
if ! [[ -s ${FILE} ]]
then
    echo -e "${WARNING_SETTINGS} The file doesn't exists. Loading. ${DEFAULT_SETTINGS}"
    download "${FILE}"
fi
read_file ${FILE}


while true
do
    get_random_line
    say_line "${RANDOM_LINE}"

    while true
    do
        USER_LINE=""
        while read -sn1 USER_SYMBOL
        do
            if [ "${USER_SYMBOL}" = "" ]
            then
                break
            fi

            if [ "${USER_SYMBOL}" = $'\x7f' ]
            then
                say_line "Backspace is ignored"
                continue
            fi

            USER_LINE="${USER_LINE}${USER_SYMBOL}"
        done < /dev/stdin

        if [ -z "${USER_LINE}" ]
        then
            exit_
        elif [ "${USER_LINE}" = "${REPEAT_STRING}" ]
        then
            say_line "${RANDOM_LINE}"
            continue
        fi
        break
    done

    if compare_lines "${USER_LINE}" "${RANDOM_LINE}"
    then
        say_line "${CORRECT_ANSWER_STRING}"
    else
        ERROR_STRING="Expected: \"${RANDOM_LINE}\" and Typed: \"${USER_LINE}\""
        echo -e "${ERROR_SETTINGS} ${ERROR_STRING} ${DEFAULT_SETTINGS}"
        echo ${ERROR_STRING} >> errors.log &
        say_line "${WRONG_ANSWER_STRING}"
    fi
done
