def settings() {
    [
            'kubectlImage' : 'ssp25/ssp-kubectl:L1',
            'slackChannel' : 'devops-hyd-test',
            'slackChannelError' : 'devops-hyd-test'
    ]
}

def notify(message) {
    def settings = settings()
    def updatedMessage = "(<${env.BUILD_URL}|Build>) `${JOB_NAME}:${env.BUILD_NUMBER}`\n${message}"
    echo updatedMessage
    slackSend(
            channel: settings.slackChannel,
            message: updatedMessage,
            color: 'good'
    )
}

def notifyFailure(message) {
    def settings = settings()
    def updatedMessage = "(<${env.BUILD_URL}|Build>) `${JOB_NAME}:${env.BUILD_NUMBER}`\n Failed \n${message}"
    echo updatedMessage
    slackSend(
            color: 'danger',
            channel: settings.slackChannelError,
            message: updatedMessage
    )
}

def branchAndBuildTag() {
    return "${env.BRANCH_NAME}${env.BUILD_NUMBER}"
}

def branchTag() {
    return "${env.BRANCH_NAME}"
}

def deploymentUpdateSspWebNode(context, namespace, newVersion) {
    sh "/usr/local/bin/kubectl set image deployment ssp-nodejs ssp-nodejs=${newVersion} --context=${context} --namespace=${namespace}"


  //  sh "delivery/pearl-squad/artisan-mobile-bff/env/reload-secret.sh ${namespace} ${context}"
}


def doBuild() {
def settings = settings()
//cluster settings
 //def clusterSettings = readYaml file: 'jenkins/cluster.yaml'
 //def context = clusterSettings.context
 //def namespace = clusterSettings.namespace
 def context
 def namespace
 context: 'minikube'
 namespace: 'ssp-dev'
 image: 'ssp25/web-node'
 //branchTag: branchTag()
 //branchBTag: branchAndBuildTag()



stage('build') {
 //def image = docker.build("ssp25/ssp-nodejs-proj")
 sh " cd $WORKSPACE"
 sh "/usr/bin/docker build -t ssp25/ssp-nodejs-proj:${branchAndBuildTag()} ."
 //sh "/usr/local/bin/docker build -t ssp25/ssp-nodejs-proj:${branchTag()} ."
}
stage('Push') {
  sh " cd $WORKSPACE"
  sh "/usr/bin/docker push ssp25/ssp-nodejs-proj:${branchAndBuildTag()}"
 //sh "/usr/local/bin/docker push ssp25/ssp-nodejs-proj:${branchTag()}"
 //image.push(branchTag())
 //image.push(branchAndBuildTag())
}

if('develop' == branchTag()) {
 stage('deploy') {
    // docker.image(settings.kubectlImage).inside {
    sh "sh jenkins/kube_config.sh"
       deploymentUpdateSspWebNode("k8s.sspcloudpro.co.in", "develop", "ssp25/ssp-nodejs-proj:${branchAndBuildTag()}")
  //   }
 }
}
}

// Our Main Job starts from here....!!!

node ('ssp-aws') {
     deleteDir()

    try {

      stage("Code Checkout")
        {
        checkout scm
        }

  //      notify(" Job Started ")
      //  loginToDocker()
        withCredentials([usernamePassword(credentialsId: 'ssp-docker-hub', passwordVariable: 'dockerhubPass', usernameVariable: 'dockerhubUser')]) {
            sh "/usr/bin/docker login -u ${dockerhubUser} -p ${dockerhubPass}"
        }
// Calling this method for build and push and deploy the docker image.
  doBuild()

  //     notify("Job is SUCCESS")
    } catch (e) {
        currentBuild.result = "FAILED"
        echo "${e.getClass().getName()} - ${e.getMessage()}"
    //    notifyFailure("${e.getClass().getName()} - ${e.getMessage()}")
        throw e
    }
}
