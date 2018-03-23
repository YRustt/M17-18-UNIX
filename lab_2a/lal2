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

declare -A MAP_APPS=(["python"]="python"
                     ["awk"]="awk"
                     ["perl"]="perl")

declare -A MAP_EXTS=(["cpp"]="cpp"
                     ["c"]="cpp"
                     ["py"]="python"
                     ["awk"]="awk"
                     ["go"]="go"
                     ["html"]="xml"
                     ["xhtml"]="xml"
                     ["xml"]="xml"
                     ["css"]="css"
                     ["pl"]="perl"
                     ["pm"]="perl"
                     ["rb"]="ruby"
                     ["rs"]="rust"
                     ["sql"]="sql"
                     ["txt"]="text"
                     ["yml"]="yaml"
                     ["yaml"]="yaml"
                     ["YAML"]="yaml")

URL="http://paste.ee/api"


function display_usage() {
    echo -e "${BOLD_FONT}2A.11${DEFAULT_SETTINGS}"
    echo "1. ./paster.sh file1 file2 ... fileN"
    echo "2. cat file | ./parser.sh"
}

function func_get_language_by_shebang() {
    local LAST_TOKEN=`echo "$1" | head -1 | awk -F/ '{print $NF}'`
    local VERSION=`echo ${LAST_TOKEN} | awk '{ for(i=NF; i >= 1; i--) { if(!($i ~ /^-/)) { print $i; break; } } }'`
    local APP=`echo ${VERSION} | awk 'match($0, /[A-Za-z_]+/) { print substr($0, RSTART, RLENGTH) }'`

    LANGUAGE="${MAP_APPS[${APP}]}"
}


function func_get_language_by_ext() {
    local FILE_EXT=`echo "$1" | awk -F. '{print $NF}'`
    LANGUAGE="${MAP_EXTS[${FILE_EXT}]}"
}


function func_post() {
    local KEY="public"
    local EXPIRE="228"

    local PASTE="$1"
    if [ -z "${PASTE}" ]
    then
        local PASTE="import this"
        echo -e "${WARNING_SETTINGS} Текст не задан. Значение по умолчанию: \"${PASTE}\". ${DEFAULT_SETTINGS}"
    fi

    local LANGUAGE="$2"
    if [ -z "${LANGUAGE}" ]
    then
        local LANGUAGE="python"
        echo -e "${WARNING_SETTINGS} Язык не задан. Значение по умолчанию: \"${LANGUAGE}\". ${DEFAULT_SETTINGS}"
    fi

    POST_RESULT=$(curl ${URL} \
                  -X "POST" \
                  --data "key=${KEY}&expire=${EXPIRE}&paste=${PASTE}&language=${LANGUAGE}" 2>/dev/null | \
                  python3 -c "import sys, json; sys.stdout.write(json.load(sys.stdin)['paste']['link']);" 2>/dev/null)
    if [ -n "${POST_RESULT}" ]
    then
        echo -e "${GOOD_SETTINGS} Пост отправлен: \"${POST_RESULT}\". ${DEFAULT_SETTINGS}"
    else
        echo -e "${ERROR_SETTINGS} Ошибка при созданиии поста. ${DEFAULT_SETTINGS}"
    fi
}


function func_open() {
    local URL="$1"
    if [ -z "${URL}" ]
    then
        local URL="http://simple-fauna.ru/wp-content/uploads/2017/03/xarakter-velsh-korgi-pembrok.jpg"
        echo -e "${WARNING_SETTINGS} URL не передан. ${DEFAULT_SETTINGS}"
    fi

    xdg-open "${URL}"
}


if [[ ($@ == "--help") || ($@ == "-h") ]]
then
    display_usage
    exit 0
fi

if [ $# -eq 0 ]
then
    PASTE=`cat`
    func_get_language_by_shebang "${PASTE}"
    func_post "${PASTE}" "${LANGUAGE}"
    func_open "${POST_RESULT}"
else
    for FILENAME in "$@"
    do
        if [ -f "${FILENAME}" ]
        then
            PASTE=`cat ${FILENAME}`
            LANGUAGE=

            func_get_language_by_ext "${FILENAME}"
            if [ -z "${LANGUAGE}" ]
            then
                func_get_language_by_shebang "${PASTE}"
            fi
            func_post "${PASTE}" "${LANGUAGE}"
            func_open "${POST_RESULT}"
        else
            echo -e "${ERROR_SETTINGS} Файл \"${FILENAME}\" не найден. ${DEFAULT_SETTINGS}"
        fi
        echo ---
    done
fi

echo -e "${GOOD_SETTINGS} Done. ${DEFAULT_SETTINGS}"