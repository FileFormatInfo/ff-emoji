#!/usr/bin/env bash
#
# download and rename google noto emoji
#

set -o errexit
set -o pipefail
set -o nounset

echo "INFO: starting at $(date -u +%Y-%m-%dT%H:%M:%SZ)"

SCRIPT_HOME="$( cd "$( dirname "$0" )" && pwd )"

TARGET_DIR=${TARGET_DIR:-docs}
DEST_DIR=$(realpath "${SCRIPT_HOME}/../${TARGET_DIR}")

SVG_FILES=($(find ${DEST_DIR}/svg -name "*.svg" | sort))
echo "INFO: found ${#SVG_FILES[@]} SVGs"

echo -n "INFO processing..."
for SVG_FILE in "${SVG_FILES[@]}"
do
    #echo "DEBUG: processing ${SVG_FILE}..."
    PNG_NAME="${DEST_DIR}/png/$(basename "${SVG_FILE}" .svg).png"

    if [ -f "${PNG_NAME}" ];
	then
		echo -n "."
	else
        echo -n "+"
        ${SCRIPT_HOME}/svg2png.sh "${SVG_FILE}" "${PNG_NAME}"
    fi

done
echo ""

echo "INFO: complete at $(date -u +%Y-%m-%dT%H:%M:%SZ)"
