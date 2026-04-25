#!/usr/bin/env bash

curr_dir=$(cd $(dirname $0); pwd)
echo "curr_dir: ${curr_dir}"

# -------------------
# Make temp directory
echo 'Creating dir_temp ... '
if dir_temp=$(mktemp -d); then
	echo "OK: ${dir_temp}"
else
    echo ' NG: Error while creating temp directory.'; exit $LINENO
fi
#if [ $? -gt 0 ]; then
#    echo ' NG: Error while creating temp directory.'; exit $LINENO
#else
#    echo 'OK'
#fi

# -------------------
# Delete temp directory
echo "Deleting ${dir_temp} ... "
if rm -r ${dir_temp}; then
	echo "OK: ${dir_temp}"
else
    echo " NG: Error while deleting temp-dir."; exit $LINENO
fi

exit 0

