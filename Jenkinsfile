//#!groovy
import com.bit13.jenkins.*

properties ([
	buildDiscarder(logRotator(numToKeepStr: '25', artifactNumToKeepStr: '25')),
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
	def INO_FILE = "Marlin.ino"
	def INO_PATH = "Marlin"

	def slack_notify_channel = null

	def SONARQUBE_INSTANCE = "bit13"

	def MAJOR_VERSION = 1
	def MINOR_VERSION = 1

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
					sh script: "${WORKSPACE}/.deploy/prep.sh";
				}
				stage ("build") {
					sh script: "${WORKSPACE}/.deploy/build.sh --ino-file=\"${INO_FILE}\" --ino-path=\"${INO_PATH}\" --board=\"${BOARD_ID}\"" 
				}
				stage ("test") {
					return_status = sh( returnStatus: true, script: "${WORKSPACE}/.deploy/test.sh --hex=\"${WORKSPACE}/dist/${CI_PROJECT_NAME}-${CI_BUILD_VERSION}.hex\"" )
					if ( return_status == 255 ) {
						currentBuild.result = "UNSTABLE";
					} else if ( return_status != 0 ) {
						throw new Exception("Failed tests")
					}
				}
				stage ("package") {
					sh script: "${WORKSPACE}/.deploy/package.sh";
				}
				stage ('publish') {
					if ( Branch.isDevelopBranch(this) ) {
						Pipeline.publish_github(this, "camalot", ProjectName, "v${env.CI_BUILD_VERSION}", 
								"${WORKSPACE}/dist/${CI_PROJECT_NAME}-${env.CI_BUILD_VERSION}.zip", false, false )

					}

					Branch.publish_to_master(this)
					Pipeline.upload_artifact(this, "${WORKSPACE}/dist/*.zip", "generic-local/arduino/${ProjectName}/${env.CI_BUILD_VERSION}/${ProjectName}-${env.CI_BUILD_VERSION}.zip")
					Pipeline.publish_buildInfo(this)
				}
			} catch(err) {
				currentBuild.result = "FAILURE"
				errorMessage = err.toString()
				throw err
			}
			finally {
				Pipeline.finish(this, currentBuild.result, errorMessage)
			}
		}
	}
}
