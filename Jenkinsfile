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
            yaml: readFile("ci-automation/config/ember-csi-app.yaml")
        )
        openshiftDeleteResourceByJsonYaml(
            yaml: readFile("ci-automation/config/ember-csi-image.yaml")
        )
        openshiftDeleteResourceByJsonYaml(
            yaml: readFile("ci-automation/config/libvirtd-image.yaml")
        )
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

      openshiftCreateResource(
          yaml: readFile("ci-automation/config/ember-csi-app.yaml")
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
