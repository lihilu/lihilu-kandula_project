node ("jenkins-agent-01") {
    dockerimage = ""
    upload_image= ""
	register = "lihilure/kandula_image_app"
    stage("git clone"){
         git branch: 'main', credentialsId: 'Lihi.opsschool.jenkins', url: 'https://github.com/lihilu/kandule_app_lihi.git'
    }
    stage("create docker"){
        dockerimage = docker.build register + ":first" 
    }
    stage("docker push"){
       withDockerRegistry([ credentialsId: "lihidockerhub", url: "" ]) {
        upload_image = register + ":first"
        sh "docker image push ${upload_image}"
        }
     }
    stage ("Deploying App to kubernetes") {
            kubernetesDeploy([configs: "kandula_app.yaml", kubeconfigId: "kubernetes", enableConfigSubstitution: true])
            sh 'kubectl apply -f kandula_app.yaml'
    } 
    
}