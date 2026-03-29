pipeline {
    agent none 

    environment {
        APP_NAME    = "weatherforecast"
        BRANCH_NAME = "aula04"
        IMAGE_NAME  = "wellisonraul/${env.APP_NAME}"
    }

    stages {
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
                    
                    // Criamos um nome de container único por branch para elas não colidirem
                    // Ex: container rodando em portas diferentes ou nomes diferentes
                    def containerName = "${env.APP_NAME}-${env.BRANCH_NAME}"
                    
                    sh """
                        docker rm -f ${containerName} || true
                        docker pull ${env.IMAGE_NAME}:${env.BRANCH_NAME}-${env.BUILD_ID}
                        
                        # Exemplo: Se for a main, roda na 5000. Se for develop, na 5001.
                        def port = (env.BRANCH_NAME == 'main') ? '5000' : '5001'
                        
                        docker run -d --name ${containerName} -p ${port}:8080 ${env.IMAGE_NAME}:${env.BRANCH_NAME}-${env.BUILD_ID}
                    """
                }
            }
        }
    }
}
