//#!groovy
import com.bit13.jenkins.*

properties ([
	buildDiscarder(logRotator(numToKeepStr: '5', artifactNumToKeepStr: '5')),
	disableConcurrentBuilds(),
	pipelineTriggers([
		pollSCM('H/30 * * * *')		
	]),
])


if(env.BRANCH_NAME ==~ /master$/) {
	return
}


node ("arduino") {
	def ProjectName = "alunar-prusa-i3-marlin-i3-firmware"
	def BOARD_ID = "arduino:avr:mega:cpu=atmega2560"
	def INO_FILE = "Marlin_I3.ino"
	def INO_PATH = "${WORKSPACE}/Marlin_I3/${INO_FILE}"

	def slack_notify_channel = null

	def SONARQUBE_INSTANCE = "bit13"

	def MAJOR_VERSION = 1
	def MINOR_VERSION = 0

	env.PROJECT_MAJOR_VERSION = MAJOR_VERSION
	env.PROJECT_MINOR_VERSION = MINOR_VERSION
	env.CI_PROJECT_NAME = ProjectName
	env.CI_BUILD_VERSION = Branch.getSemanticVersion(this)
	env.CI_DOCKER_ORGANIZATION = Accounts.GIT_ORGANIZATION
	currentBuild.result = "SUCCESS"
	def errorMessage = null


	wrap([$class: 'TimestamperBuildWrapper']) {
		wrap([$class: 'AnsiColorBuildWrapper', colorMapName: 'xterm']) {
			Notify.slack(this, "STARTED", null, slack_notify_channel)
			try {
					stage ("install" ) {
							deleteDir()
							Branch.checkout(this, ProjectName)
							Pipeline.install(this)

							sh script: """#!/usr/bin/env bash
library-manager --name="LiquidCrystal" --version="latest";
library-manager --name="LiquidCrystal_I2C" --version="latest";
mkdir -p "${WORKSPACE}/dist";
mkdir -p "${WORKSPACE}/build";

"""
					}
					stage ("build") {
						sh script: """#!/usr/bin/env bash
set -e;

build_date=$(date +%F-%T-%Z);
echo "#define USE_JENKINS_VERSIONING" >> '${WORKSPACE}/Marlin_I3/Configuration_Alunar.h';
sed -i 's|{{CI_BUILD_VERSION}}|${CI_BUILD_VERSION}|g' '${WORKSPACE}/Marlin_I3/Configuration_Alunar.h'
sed -i 's|{{CI_BUILD_DATE}}|\${build_date}|g' '${WORKSPACE}/Marlin_I3/Configuration_Alunar.h'
cat ${WORKSPACE}/Marlin_I3/Configuration_Alunar.h;

arduino-builder \
	--compile \
	-verbose \
	-warnings more \
	-hardware /arduino/hardware \
	-tools /arduino/hardware/tools \
	-tools /arduino/tools-builder \
	-libraries /arduino/libraries \
	-fqbn ${BOARD_ID} \
	-build-path '${WORKSPACE}/build' \
	'${INO_PATH}';
mv ${WORKSPACE}/build/${INO_FILE}.hex ${WORKSPACE}/dist/${ProjectName}-${CI_BUILD_VERSION}.hex
mv ${WORKSPACE}/build/${INO_FILE}.with_bootloader.hex ${WORKSPACE}/dist/${ProjectName}-${CI_BUILD_VERSION}-with_bootloader.hex
ls -lFa ${WORKSPACE}/dist;
"""
					}
					stage ("test") {
					}
					stage ("package") {
						sh script: """#!/usr/bin/env bash
cd ${WORKSPACE}/dist;
zip -r "${CI_PROJECT_NAME}.zip" ${ProjectName}-*.hex;
cd ${WORKSPACE};
"""
					}
					stage ("deploy") {
							// sh script: "${WORKSPACE}/.deploy/deploy.sh -n '${ProjectName}' -v '${env.CI_BUILD_VERSION}'"
							Pipeline.publish_artifact(this, "${WORKSPACE}/dist/*.zip", "generic-local/arduino/${ProjectName}/${env.CI_BUILD_VERSION}/${ProjectName}-${env.CI_BUILD_VERSION}.zip")
					}
					stage ('cleanup') {
							// this only will publish if the incoming branch IS develop
							Branch.publish_to_master(this)
							Pipeline.cleanup(this)
					}
			} catch(err) {
				currentBuild.result = "FAILURE"
				errorMessage = err.toString()
				throw err
			}
			finally {
				if(currentBuild.result == "SUCCESS") {
					if (Branch.isMasterOrDevelopBranch(this)) {
						currentBuild.displayName = "${env.CI_BUILD_VERSION}"
					} else {
						currentBuild.displayName = "${env.CI_BUILD_VERSION} [#${env.BUILD_NUMBER}]"
					}
				} else {
					Notify.gntp(this, "${ProjectName}: ${currentBuild.result}", errorMessage)
				}
				Notify.slack(this, currentBuild.result, errorMessage)
			}
		}
	}
}
