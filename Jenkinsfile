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
                        // 1. Definimos os argumentos em uma variável limpa
                        // Usamos aspas duplas para o Groovy substituir as variáveis do Jenkins
                        def sonarArgs = "--build-arg SONAR_TOKEN=${SONAR_AUTH_TOKEN} " +
                                        "--build-arg SONAR_HOST_URL=${SONAR_HOST_URL} " +
                                        "--build-arg APP_KEY=${env.APP_NAME}"
                    
                        echo "Iniciando build com os argumentos: ${sonarArgs}"
                    
                        // 2. Passamos a string de argumentos e o ponto final (contexto)
                        // O segundo parâmetro do docker.build DEVE terminar com o ponto "."
                        app = docker.build("${IMAGE_NAME}:${BRANCH_NAME}-${BUILD_ID}", "${sonarArgs} .")
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
