pipeline {
    agent none 

    environment {
        APP_NAME    = "weatherforecast"
        IMAGE_NAME  = "wellisonraul/${env.APP_NAME}"
    }

    stage('Análise SonarQube (Fora do Docker)') {
            agent { label 'built-in' }
            steps {
                withSonarQubeEnv('SonarQube-Server') {
                    script {
                        // 1. Garantir que o scanner está instalado no Agent
                        sh "dotnet tool install --global dotnet-sonarscanner || true"
                        
                        // 2. Adicionar o path do scanner (ajuste o caminho se for Windows ou outro usuário)
                        def dotnetToolPath = "${env.HOME}/.dotnet/tools"
                        
                        withEnv(["PATH+DOTNET=${dotnetToolPath}"]) {
                            sh """
                                dotnet sonarscanner begin /k:'${APP_NAME}' \
                                    /d:sonar.token='${SONAR_AUTH_TOKEN}' \
                                    /d:sonar.host.url='${SONAR_HOST_URL}' \
                                    /d:sonar.cs.opencover.reportsPaths='**/coverage.opencover.xml'

                                dotnet build --configuration Release
                                
                                dotnet test --configuration Release --no-build \
                                    --collect:'XPlat Code Coverage' \
                                    --results-directory ./TestResults \
                                    -- DataCollectionRunSettings.DataCollectors.DataCollector.Configuration.Format=opencover
                                
                                dotnet sonarscanner end /d:sonar.token='${SONAR_AUTH_TOKEN}'
                            """
                        }
                    }
                }
            }
        }

        stage("Quality Gate") {
            agent { label 'built-in' }
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
    
        stage('Build e Push Imagem Limpa') {
            agent { label 'built-in' }
            steps {
                script {
                    // Aqui você usa seu Dockerfile ORIGINAL, sem Java nem Sonar dentro dele
                    def fullImageName = "${IMAGE_NAME}:${BRANCH_NAME}-${BUILD_ID}"
                    app = docker.build(fullImageName, ".")
                    
                    docker.withRegistry('https://registry.hub.docker.com/', 'dockerhub') {
                        app.push()
                    }
                }
            }
        }

        stage("Quality Gate") {
            agent { label 'built-in' }
            steps {
                // Agora o Jenkins sabe que deve olhar para o 'SonarQube-Server'
                withSonarQubeEnv('SonarQube-Server') {
                    timeout(time: 5, unit: 'MINUTES') {
                        waitForQualityGate abortPipeline: true
                    }
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
