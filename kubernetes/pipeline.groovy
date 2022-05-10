 node ("jenkins-agent-01") {
        dockerimagename= "lihilure/kandula_image_app"
        dockerImage = ""
            stage('checkout source') {
                    git branch: 'main', credentialsId: 'Lihi.opsschool.jenkins', url: 'https://github.com/lihilu/kandule_app_lihi.git'
            }
            stage ('Build image') {
                    script {
                        dockerImage = docker.build (dockerimagename)
                    }
            }
            
            stage ('Pushing image') {
                    script {
                        withDockerRegistry(credentialsId: 'lihi dockerhub', url: 'https://registry.hub.docker.com') {
                        dockerImage.push("latest")
                        }
                    }
            }
            stage ('Deploying App to kubernetes') {
                    script {
                        kubernetesDeploy(configs: "kandula_app.yaml", kubeconfigId: "kubernetes")
                    }
            }
}