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
	def INO_PATH = "Marlin_I3"

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
					sh script: "${WORKSPACE}/.deploy/prep.sh";
				}
				stage ("build") {
					sh script: "${WORKSPACE}/.deploy/build.sh --ino-file=\"${INO_FILE}\" --ino-path=\"${INO_PATH}\" --board=\"${BOARD_ID}\"" 
				}
				stage ("test") {
				}
				stage ("package") {
					sh script: "${WORKSPACE}/.deploy/package.sh";
				}
				stage ("deploy") {
					// sh script: "${WORKSPACE}/.deploy/deploy.sh -n '${ProjectName}' -v '${env.CI_BUILD_VERSION}'"
					// this only will publish if the incoming branch IS develop
					Pipeline.publish_artifact(this, "${WORKSPACE}/dist/*.zip", "generic-local/arduino/${ProjectName}/${env.CI_BUILD_VERSION}/${ProjectName}-${env.CI_BUILD_VERSION}.zip")
					// this only will publish if the incoming branch IS develop
					Branch.publish_to_master(this)
					// after pushing to master, publish release
					// this will only run on develop branch
					Pipeline.publish_github(this, "camalot", ProjectName, "v${env.CI_BUILD_VERSION}", 
							"${WORKSPACE}/dist/${CI_PROJECT_NAME}-${env.CI_BUILD_VERSION}.zip", true, false )
				}
				stage ('cleanup') {
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
