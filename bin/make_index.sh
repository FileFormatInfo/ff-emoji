#!/usr/bin/env bash
#
# index file of emoji that have an image
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

INDEX_FILE=$(realpath "${DEST_DIR}/emoji-images.json")

cat <<EOT >"${INDEX_FILE}"
{
EOT

echo -n "INFO processing..."
for SVG_FILE in "${SVG_FILES[@]}"
do
    #proper, but slow: EMOJI_NAME=$(basename "${SVG_FILE}" .svg)
	FILE_NAME=${SVG_FILE##${DEST_DIR}/svg/}
	EMOJI_NAME=${FILE_NAME%%.svg}

	if [ "${SVG_FILE}" != "${SVG_FILES[0]}" ]; then
		echo "," >>"${INDEX_FILE}"
	fi

	echo -n "  \"${EMOJI_NAME}\": true" >>"${INDEX_FILE}"

done

cat <<EOT >>"${INDEX_FILE}"

}
EOT

echo ""
echo "INFO: complete at $(date -u +%Y-%m-%dT%H:%M:%SZ)"
