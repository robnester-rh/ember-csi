// Define the openshift pod name, docker repo url, namespace, and service acct
// for the DSL pod template.
// dslPodName = "contraDsl-${UUID.randomUUID()}"
// dockerRepoURL = '172.30.254.79:5000'
// openshiftNamespace = 'ember-csi'
// openshiftServiceAccount = 'jenkins'
//
// // Create the DSL podTemplate
// createDslContainers podName: dslPodName,
//                     dockerRepoURL: dockerRepoURL,
//                     openshiftNamespace: openshiftNamespace,
//                     openshiftServiceAccount: openshiftServiceAccount,
// Pass the remainder of your jenkinsfile as a closure to the createDslContainers method
{
  node {
      docker.image('node:ubuntu:18.04').inside {
          stage('Test') {
              sh 'ls'
          }
      }
  }
}

  //node(dslPodName){

      // stage("pre-flight"){
      //     deleteDir()
      //     git branch: 'contra-hdsl', url: 'https://github.com/lioramilbaum/ember-csi'
      // }
      //
      // stage("Parse Configuration"){
      //     parseConfig()
      //     echo env.configJSON
      // }
      //
      // stage("Deploy Infra"){
      //     deployInfra verbose: true
      // }
      //
      // stage("Configure Infra"){
      //     configureInfra verbose: true
      // }
      //
      // // stage("Execute Tests"){
      // //     executeTests verbose: true
      // // }
      //
      // stage("Destroy Infra"){
      //     destroyInfra verbose: true
      // }
      //archiveArtifacts allowEmptyArchive: true, artifacts: '*, linchpin/*, resources/*, linchpin/resources/*'
//   }
// }
