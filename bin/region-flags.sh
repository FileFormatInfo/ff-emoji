#!/usr/bin/env bash
#
# download and rename lipis flag icons
#

set -o errexit
set -o pipefail
set -o nounset

echo "INFO: starting at $(date -u +%Y-%m-%dT%H:%M:%SZ)"

function CHR () {
   local val
   [ "$1" -lt 256 ] || return 1
   printf -v val %o "$1"; printf "\\$val"
}

function ORD () {
    LC_CTYPE=C printf %d "'$1"
}

REPO_URL=https://github.com/behdad/region-flags
REPO_SUBDIR=svg

REPO_DIR=$(basename ${REPO_URL})


SCRIPT_HOME="$( cd "$( dirname "$0" )" && pwd )"
TMP_DIR=$(realpath "${SCRIPT_HOME}/../tmp")

TARGET_DIR=${TARGET_DIR:-docs}
DEST_DIR=$(realpath "${SCRIPT_HOME}/../${TARGET_DIR}")

if [ -d "${TMP_DIR}" ]; then
    echo "WARNING: re-using existing tmp directory ${TMP_DIR}"
else
    echo "INFO: creating tmp directory ${TMP_DIR}"
    mkdir -p "${TMP_DIR}"
fi

if [ ! -d "${DEST_DIR}/svg" ]; then
    echo "INFO: creating output directory ${DEST_DIR}/svg"
    mkdir -p "${DEST_DIR}/svg"
fi

if [ ! -d "${DEST_DIR}/png" ]; then
    echo "INFO: creating output directory ${DEST_DIR}/png"
    mkdir -p "${DEST_DIR}/png"
fi

LOCAL_DIR="${TMP_DIR}/${REPO_DIR}"
if [ ! -d "${LOCAL_DIR}" ]; then
    echo "INFO: cloning a fresh copy"
    git clone --depth 1 ${REPO_URL}.git ${LOCAL_DIR}
else
    echo "INFO: using existing clone"
fi

SVG_FILES=($(find ${LOCAL_DIR}/${REPO_SUBDIR} -name "*.svg" | sort))
echo "INFO: found ${#SVG_FILES[@]} SVGs"

if [ "${MAX_ICONS:-BAD}" != "BAD" ]; then
    SVG_FILES=("${SVG_FILES[@]:0:${MAX_ICONS}}")
    echo "INFO: truncating to ${MAX_ICONS}"
fi

echo -n "INFO processing..."
for SVG_FILE in "${SVG_FILES[@]}"
do
    #echo "DEBUG: processing ${SVG_FILE}..."
    BAD_NAME=$(basename "${SVG_FILE}" .svg)
    # convert ascii chars to regional indicator chars
    first=$(ORD "${BAD_NAME:0:1}")
    second=$(ORD "${BAD_NAME:1:1}")
    # 97 for lower-case 'a'
    # 65 for upper-case 'A'
    NICE_NAME=$(printf %x $((${first} - 65 + 127462)))_$(printf %x $((${second} - 65 + 127462)))
    NICE_SVG="${DEST_DIR}/svg/${NICE_NAME}.svg"
    NICE_PNG="${DEST_DIR}/png/${NICE_NAME}.png"

    if [ ! -f "${NICE_SVG}" ]; then
        echo -n "."
        cp "${SVG_FILE}" "${NICE_SVG}"
    fi

    if [ ! -f "${NICE_PNG}" ]; then
        echo -n "+"
        #${SCRIPT_HOME}/svg2png.sh "${SVG_FILE}" "${NICE_PNG}"
    fi

done
echo ""

echo "INFO: complete at $(date -u +%Y-%m-%dT%H:%M:%SZ)"
