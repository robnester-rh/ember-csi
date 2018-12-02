dslPodName = "contraDsl-${UUID.randomUUID()}"
dockerRepoURL = '172.30.254.79:5000'
openshiftNamespace = 'ember-csi'
openshiftServiceAccount = 'jenkins'

createDslContainers podName: dslPodName,
                    dockerRepoURL: dockerRepoURL,
                    openshiftNamespace: openshiftNamespace,
                    openshiftServiceAccount: openshiftServiceAccount,
{
  node(dslPodName){

    stage("pre-flight"){
      deleteDir()
      git branch: "${BRANCH_NAME}", \
        url: 'https://github.com/lioramilbaum/ember-csi.git'

      try {
        openshiftDeleteResourceByJsonYaml(
            yaml: readFile("ci-automation/config/ember-csi-dc.yaml")
        )
      }
      catch (err){
        echo "Deleting OCP Resources failure"
      }
      try {
        openshiftDeleteResourceByJsonYaml(
            yaml: readFile("ci-automation/config/ember-csi-builds.yaml")
        )
      }
      catch (err){
        echo "Deleting OCP Resources failure"
      }
      try {
        openshiftDeleteResourceByJsonYaml(
            yaml: readFile("ci-automation/config/ember-csi-image.yaml")
        )
      }
      catch (err){
        echo "Deleting OCP Resources failure"
      }
      try {
        openshiftDeleteResourceByJsonYaml(
            yaml: readFile("ci-automation/config/libvirtd-image.yaml")
        )
      }
      catch (err){
        echo "Deleting OCP Resources failure"
      }
    }

    stage("Parse Configuration"){
      parseConfig()
      echo env.configJSON
    }

    stage("Deploy Infra"){

      openshiftCreateResource(
          yaml: readFile("ci-automation/config/libvirtd-image.yaml")
      )
      openshiftBuild(buildConfig: 'libvirtd', showBuildLogs: 'true')

      openshiftCreateResource(
          yaml: readFile("ci-automation/config/ember-csi-image.yaml")
      )
      openshiftBuild(buildConfig: 'ember-csi', showBuildLogs: 'true')

      FILENAME = readFile("ci-automation/config/ember-csi-dc.yaml").replaceAll("$WORKSPACE","${WORKSPACE}")
      echo ${FILENAME}
      openshiftCreateResource(
          yaml: "${FILENAME}"
      )
    }

    stage("Execute Tests"){
      try {
        executeTests verbose: true, vars: [ workspace: "${WORKSPACE}" ]
      } finally {
        junit 'junit.xml'
      }
    }

    // stage("Destroy Infra"){
    //   sh './ci-automation/testing_env_main.sh destroy'
    // }

  }
}
