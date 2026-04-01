pipeline {
    agent any

    environment {
        APP_NAME    = "calculadora"
        IMAGE_NAME  = "wellisonraul/${env.APP_NAME}"
        BRANCH_NAME = GIT_BRANCH.replaceFirst(/^origin\//, '')
    }

   

    stages {
        stage('Carregando variáveis do Infisical') {
            agent { label 'aws-agent' }
            steps {
                script{
                    node(){
                        withInfisical(
                        configuration: [
                            infisicalCredentialId: 'Infisical',
                            infisicalEnvironmentSlug: 'dev', 
                            infisicalProjectSlug: 'aula03-4-aak', 
                            infisicalUrl: 'https://app.infisical.com'
                        ],
                        infisicalSecrets: [
                                infisicalSecret(
                                    includeImports: true, 
                                    path: '/', 
                                    secretValues: [
                                        [infisicalKey: 'data1'],
                                        [infisicalKey: 'data2'],
                                        [infisicalKey: 'THIS_KEY_MIGHT_NOT_EXIST', isRequired: false],
                                    ]
                                )
                            ]
                        ) {
                        
                        sh 'printenv'
                        env.data1  = "${env.data1}"
                        env.data2  = "${env.data2}"

                        }
                    }
                }
            }
        }


        stage('Build e Push') {
            agent { label 'aws-agent' } 
            steps {
                script {
                    echo "🛠️ Compilando a branch: ${env.BRANCH_NAME}"
                    
                    // Taggeamos a imagem com o nome da branch + ID do build
                    // Ex: wellisonraul/weatherforecast:develop-12
                    def fullImageName = "${env.IMAGE_NAME}:${env.BRANCH_NAME}-${env.BUILD_ID}"
                    
                    app = docker.build(fullImageName, '.')
                    
                    docker.withRegistry('https://registry.hub.docker.com/', 'dockerhub') {
                        app.push()
                        // Também atualizamos a 'latest' daquela branch específica
                        app.push("${env.BRANCH_NAME}-latest")
                    }
                }
            }
        }

        stage('Deploy por Branch') {
            agent { label 'aws-agent' } 
            steps {
                script {
                    echo "🚀 Fazendo deploy da branch ${env.BRANCH_NAME} na AWS..."
                    
                    def cleanBranch = env.BRANCH_NAME.replaceAll(/[^a-zA-Z0-9.\-_]/, "-")
                    def containerName = "${env.APP_NAME}-${cleanBranch}"
                    
                    // 1. Calculamos a porta no Groovy
                    def portValue = (env.BRANCH_NAME == 'main') ? '5000' : '5001'
                    
                    // 2. Passamos para o Shell usando interpolação de string do Groovy
                    sh """
                        docker rm -f ${containerName} || true
                        docker pull ${env.IMAGE_NAME}:${cleanBranch}-${env.BUILD_ID}
                        
                        # Note que usamos ${portValue} para injetar o valor calculado acima
                        docker run -d --name ${containerName} -p ${portValue}:8080 ${env.IMAGE_NAME}:${cleanBranch}-${env.BUILD_ID}
                    """
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline concluído com sucesso!"
        }
        failure {
            echo "Pipeline falhou!"
        }
    }
}