#!/usr/bin/env bash

test () {
    echo "Called from line:${BASH_LINENO[0]}"
    echo "Called from line:${LINENO[0]}"
}

test
test
