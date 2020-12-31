#!/usr/bin/env bash
#
# load noto emoji flags, which are on a different branch
#

export REPO_BRANCH=svg_flags
export REPO_SUBDIR=third_party/waved-flags

SCRIPT_HOME="$( cd "$( dirname "$0" )" && pwd )"

${SCRIPT_HOME}/noto-emoji.sh
