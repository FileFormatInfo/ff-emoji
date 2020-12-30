#!/bin/bash
#
# script to run on localhost
#

set -o errexit
set -o pipefail
set -o nounset

jekyll serve \
    --source docs
    --watch 
    
