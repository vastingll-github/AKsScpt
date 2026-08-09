#!/usr/bin/env bash

select exeno in 'ls -l' 'unset' 'pwd' 'ls -lh'
do
	if [[ ${exeno} == "unset" ]];then
    eval unset PROMPT_COMMAND
		break
	fi
	eval PROMPT_COMMAND='${exeno}'
	break
done 
