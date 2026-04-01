pipeline {
    agent aws-agent 

    environment {
        APP_NAME    = "weatherforecast"
        IMAGE_NAME  = "wellisonraul/${env.APP_NAME}"
    }
    stages {
        stage('Análise SonarQube (Fora do Docker)') {
            steps {
                script {
                    withSonarQubeEnv('SonarQube-Server') {
                        // Garantir que o scanner está instalado
                        sh "dotnet tool install --global dotnet-sonarscanner || true"
                        
                        // ERRO 2: Forma mais robusta de adicionar ao PATH no Jenkins
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
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
    
        stage('Build e Push Imagem Limpa') {
            steps {
                script {
                    def fullImageName = "${IMAGE_NAME}:${BRANCH_NAME}-${BUILD_ID}"
                    app = docker.build(fullImageName, ".")
                    
                    docker.withRegistry('https://registry.hub.docker.com/', 'dockerhub') {
                        app.push()
                        app.push("${env.BRANCH_NAME}-latest")
                    }
                }
            }
        }
    
        stage('Deploy por Branch') {
            steps {
                script {
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
