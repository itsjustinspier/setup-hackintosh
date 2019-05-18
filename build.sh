#!/usr/bin/env bash

if ! [[ "$OSTYPE" =~ darwin ]]; then
    (>&2 echo "This is meant to be run on macOS only.")
    exit 1;
fi

# the iasl tool must installed before!
type iasl >/dev/null 2>&1 || {
    (>&2 echo "You need to install: iasl.");
    exit 1;
}

export PROJECT_DIR="$(cd "$(dirname "$0")"; pwd -P)"
export CLOVER_BUILD_DIR="/tmp/clover-$(date +%Y%m%dT%H%M%S)"

# remove last build
rm -rf "$CLOVER_BUILD_DIR"
mkdir "$CLOVER_BUILD_DIR"

find "$PROJECT_DIR/src/ACPI" -type f -name '*.dsl' ! -name 'DSDT.dsl' -exec \
    sh -c '
SOURCE_NAME=$(basename $0 .dsl)
iasl \
    -vw 2095 \
    -vw 2146 \
    -vw 2089 \
    -vw 4089 \
    -vi -vr \
    -p "$CLOVER_BUILD_DIR/ACPI/patched/$SOURCE_NAME.aml" $0
' {} \;
