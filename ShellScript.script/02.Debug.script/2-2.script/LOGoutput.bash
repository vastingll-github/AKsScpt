#!/bin/bash -
readonly LOGFILE="/tmp/${0##*/}.log"

readonly PROCNAME=${0##*/}
function log() {
  local fname=${BASH_SOURCE[1]##*/}
  echo -e "$(date '+%Y-%m-%dT%H:%M:%S') ${PROCNAME} (${fname}:${BASH_LINENO[0]}:${FUNCNAME[1]}) $@" | tee -a ${LOGFILE}
}


#
# MAIN
#

log "This is test message 1"
log "Test 2"
log "Test 3"

function logtest() {
  log "test from logtest function"
}

logtest

