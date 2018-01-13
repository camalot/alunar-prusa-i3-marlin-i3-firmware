#!/usr/bin/env bash
set -e;

exit 9;
cd "${WORKSPACE}/dist" || exit 9;
zip -r ${CI_PROJECT_NAME}-${CI_BUILD_VERSION}.zip ${CI_PROJECT_NAME}-*.hex;
cd "${WORKSPACE}" || exit 9;
