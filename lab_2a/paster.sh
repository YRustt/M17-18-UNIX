#!/usr/bin/env bash

GREEN_BACKGROUND="\033[42m"
RED_BACKGROUND="\033[41m"
YELLOW_BACKGROUND="\033[43m"
WHITE_FONT_COLOR="\033[30m"
DEFAULT_SETTINGS="\033[0m"

URL="http://paste.ee/api"


function func_post() {
    local KEY="public"
    local EXPIRE="228"

    local PASTE="$1"
    if [ -z "${PASTE}" ]
    then
        local PASTE="import this"
        echo -e "${YELLOW_BACKGROUND}${WHITE_FONT_COLOR} Текст не задан. Значение по умолчанию: \"${PASTE}\". ${DEFAULT_SETTINGS}"
    fi

    local LANGUAGE="$2"
    if [ -z "${LANGUAGE}" ]
    then
        local LANGUAGE="python"
        echo -e "${YELLOW_BACKGROUND}${WHITE_FONT_COLOR} Язык не задан. Значение по умолчанию: \"${LANGUAGE}\". ${DEFAULT_SETTINGS}"
    fi

    POST_RESULT=$(curl ${URL} -X "POST" --data "key=${KEY}&expire=${EXPIRE}&paste=${PASTE}&language=${LANGUAGE}" 2>/dev/null | \
                  python3 -c "import sys, json; sys.stdout.write(json.load(sys.stdin)['paste']['link']);" 2>/dev/null)
    if [ -n "${POST_RESULT}" ]
    then
        echo -e "${GREEN_BACKGROUND}${WHITE_FONT_COLOR} Пост отправлен: \"${POST_RESULT}\". ${DEFAULT_SETTINGS}"
    else
        echo -e "${RED_BACKGROUND}${WHITE_FONT_COLOR} Ошибка при созданиии поста. ${DEFAULT_SETTINGS}"
    fi
}


function func_open() {
    local URL="$1"
    if [ -z "${URL}" ]
    then
        local URL="http://simple-fauna.ru/wp-content/uploads/2017/03/xarakter-velsh-korgi-pembrok.jpg"
        echo -e "${YELLOW_BACKGROUND}${WHITE_FONT_COLOR} URL не передан. ${DEFAULT_SETTINGS}"
    fi

    xdg-open "${URL}"
}


function func_pipeline() {
    func_post
    func_open ${POST_RESULT}
}

func_pipeline