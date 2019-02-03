#!/bin/bash
#
# name:
#   install.sh
#
# description:
#   Install Notarize to /usr/local
#
#     - /usr/local/bin/notarize
#
# parameters:
#   - 1: install location

PREFIX=${PREFIX:-${1:-/usr/local}}
BASE_DIR=$(cd `dirname $0`; pwd)

cp -r $BASE_DIR/bin "${PREFIX}"
