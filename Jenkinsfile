pipeline {
    agent any

    environment {
        APP_NAME    = "weatherforecast"
        IMAGE_NAME  = "wellisonraul/${env.APP_NAME}"
        BRANCH_NAME = GIT_BRANCH.replaceFirst(/^origin\//, '')
    }

    stages {
        stage('Build, testando e empacotando') {
            steps {
                script {
                    echo "Compilando, testando e empacotando a aplicação..."
                    //sh 'docker build -t $APP_NAME:$BRANCH_NAME-$BUILD_NUMBER . --no-cache'  // Exemplo de comando para compilar uma aplicação Dotnet
                    app = docker.build("${env.IMAGE_NAME}:${env.BRANCH_NAME}-${env.BUILD_ID}", '.')
                }
            }
        }

        stage('Docker image push') {
            steps {
                script {
                    /* Push image using withRegistry. */
                    docker.withRegistry('https://registry.hub.docker.com/', 'dockerhub') {
                        app.push("${env.BUILD_ID}")
                        app.push('latest')
                    }
                }
            
            }
        }

        stage('Deploy') {
            steps {
                script {
                    echo "🚀 Realizando o deploy..."

                    // Força parar o container antigo se ele existir
                    try {
                        sh "docker rm -f ${env.APP_NAME}-${env.BRANCH_NAME} || true"
                    } catch (Exception e) {
                        echo "Nenhum container antigo rodando. Vamos seguir com o deploy novo!"
                    }

                    // Roda o novo container
                    //docker.image("${env.IMAGE_NAME}:${env.BRANCH_NAME}-${env.BUILD_ID}").run("--name ${env.APP_NAME}-${env.BRANCH_NAME}")


                    echo "✅ Deploy finalizado com sucesso!"
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
