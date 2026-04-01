pipeline {
    agent none 

    environment {
        APP_NAME    = "weatherforecast"
        IMAGE_NAME  = "wellisonraul/${env.APP_NAME}"
    }

    stages {
        stage('Build, Test e Sonar') {
            agent { label 'built-in' } 
            steps {
                script {
                    // O 'SonarQube-Server' deve ser o nome configurado no System do Jenkins
                    withSonarQubeEnv('SonarQube-Server') {
                        echo "🛠️ Iniciando Build com análise SonarQube..."
                        
                        def fullImageName = "${env.IMAGE_NAME}:${env.BRANCH_NAME}-${env.BUILD_ID}"
                        
                        // Passamos o Token e a URL que o 'withSonarQubeEnv' nos dá para dentro do Docker
                        app = docker.build(fullImageName, """
                            --build-arg SONAR_TOKEN=${SONAR_AUTH_TOKEN} \
                            --build-arg SONAR_HOST_URL=${SONAR_HOST_URL} \
                            --build-arg APP_KEY=${env.APP_NAME} \
                            .
                        """)
                        
                        docker.withRegistry('https://registry.hub.docker.com/', 'dockerhub') {
                            app.push()
                            app.push("${env.BRANCH_NAME}-latest")
                        }
                    }
                }
            }
        }

        stage("Quality Gate") {
            agent { label 'built-in' }
            steps {
                // Aguarda o feedback do SonarQube para decidir se continua a pipeline
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Deploy por Branch') {
            agent { label 'aws-agent' } 
            steps {
                script {
                    echo "🚀 Fazendo deploy da branch ${env.BRANCH_NAME} na AWS..."
                    
                    def containerName = "${env.APP_NAME}-${env.BRANCH_NAME}"
                    def port = (env.BRANCH_NAME == 'main') ? '5000' : '5001'
                    
                    sh """
                        docker rm -f ${containerName} || true
                        docker pull ${env.IMAGE_NAME}:${env.BRANCH_NAME}-${env.BUILD_ID}
                        docker run -d --name ${containerName} -p ${port}:8080 ${env.IMAGE_NAME}:${env.BRANCH_NAME}-${env.BUILD_ID}
                    """
                }
            }
        }
    }
}