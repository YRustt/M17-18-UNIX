#!/usr/bin/env bash

GREEN_BACKGROUND="\033[42m"
RED_BACKGROUND="\033[41m"
YELLOW_BACKGROUND="\033[43m"
WHITE_FONT_COLOR="\033[30m"

GOOD_SETTINGS="${GREEN_BACKGROUND}${WHITE_FONT_COLOR}"
WARNING_SETTINGS="${YELLOW_BACKGROUND}${WHITE_FONT_COLOR}"
ERROR_SETTINGS="${RED_BACKGROUND}${WHITE_FONT_COLOR}"
DEFAULT_SETTINGS="\033[0m"


URL="http://paste.ee/api"


function func_get_language() {
    DATA="$1"
    if [ -f "${DATA}" ]
    then
        local FILE_EXT=`echo "${DATA}" | awk -F. '{print $NF}'`
        DATA=`cat ${DATA}`
    fi
}


function func_post() {
    local KEY="public"
    local EXPIRE="228"

    local PASTE="$1"
    if [ -z "${PASTE}" ]
    then
        local PASTE="#!/usr/bin/awk -F"
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


function func_pipeline() {
    func_get_language "$1"
    func_post "${DATA}"
    func_open ${POST_RESULT}
}


if [ $# -eq 0 ]
then
    func_pipeline
elif [ $# -eq 1 ]
then
    func_pipeline $1
else
    echo "1"
fi