#!/usr/bin/env bash
set -e;
cd ${WORKSPACE}/dist;
zip -r "${CI_PROJECT_NAME}-${CI_BUILD_VERSION}.zip" ${CI_PROJECT_NAME}-*.hex;
cd ${WORKSPACE};
