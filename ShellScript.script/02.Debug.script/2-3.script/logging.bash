#!/usr/bin/env bash

set -x

set -euCo pipefail

readonly LOG_OUT=./stdout.log
readonly LOG_ERR=./stderr.log

exec 1> >(tee -a "$LOG_OUT")
exec 2> >(tee -a "$LOG_ERR")

function log_debug() {
    lgg_msg=$(gen_log_msg 'DEBUG' "$*")
    echo "${lgg_msg}"
}

function log_err() {
    lgg_msg=$(gen_log_msg 'ERROR' "$*")
    echo "${lgg_msg}" >&2
}

function gen_log_msg() {
    printf "%s\t[%5s]\t%s" "$(date '+%Y/%m/%d %H:%M:%S.%3N')" "$1" "$2"
}

function trap_err() {
    error_status=$?
    msg=$(printf "エラー発生 \$?=%d %s %s:%d" ${error_status} "${BASH_SOURCE[0]}" "${FUNCNAME[1]}" ${BASH_LINENO[0]})
    log_err "${msg}"
}

function trap_exit() {
    msg=$(printf "終了時の処理 %s %s:%d" "${BASH_SOURCE[0]}" "${FUNCNAME[1]}" ${BASH_LINENO[0]})
    log_debug "${msg}"
}

trap trap_err ERR

trap trap_exit EXIT

log_debug "$(which bash)"

log_debug "$(bash --version)"

# 標準エラーへの出力確認用
ls dummy.txt

echo "ここは表示されない"

