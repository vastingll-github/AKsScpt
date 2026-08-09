#!/usr/bin/env bash

make_script() {
		cat > ./sample.sh <<- "EOF"
		#!/usr/bin/env bash

		OUTPUT_STRING="Hello World."
		echo "${OUTPUT_STRING}"
		EOF
}

make_script

