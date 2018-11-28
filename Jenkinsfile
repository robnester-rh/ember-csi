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
    }

    stage("Parse Configuration"){
      parseConfig()
      echo env.configJSON
    }

    stage('Clone repository') {
      git(url: 'https://github.com/lioramilbaum/CentOS-Dockerfiles.git', \
        branch: 'master')
    }

    // stage('Build image') {
    //     app = docker.build("centos/libvirtd")
    // }
    // stage("Deploy Infra"){
    //   sh './ci-automation/testing_env_main.sh up'
    // }

    stage("Execute Tests"){
      try {
        executeTests verbose: true, vars: [ workspace: "${WORKSPACE}" ]
      } finally {
        junit 'junit.xml'
      }
    }

    stage("Destroy Infra"){
      sh './ci-automation/testing_env_main.sh destroy'
    }
  }

}
