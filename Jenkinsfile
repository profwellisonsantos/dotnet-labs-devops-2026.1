pipeline {
    agent {
        docker {
            image 'mcr.microsoft.com/dotnet/sdk:8.0'
            args '-u root' 
        }
    }

    // Variáveis de ambiente para facilitar a vida do aluno
    environment {
        // O aluno deve colocar o IP da máquina dele da AWS aqui
        AWS_IP = '3.80.127.174' 
    }

    stages {
        stage('Checkout') {
            steps { checkout scm }
        }

        stage('Restore') {
            steps { sh 'dotnet restore' }
        }

        stage('Build') {
            steps { sh 'dotnet build --configuration Release --no-restore' }
        }

        stage('Test') {
            steps { sh 'dotnet test --configuration Release --no-build --verbosity normal' }
        }

        stage('Publish') {
            steps {
                echo 'Empacotando a API para deploy...'
                sh 'dotnet publish ExemploDevOps.Api/ExemploDevOps.Api.csproj -c Release -o ./publish-output'
            }
        }

        stage('Deploy to AWS') {
            steps {
                echo 'Iniciando o deploy direto para a AWS...'
                
                // 1. Prepara o container instalando o cliente SSH e desabilitando a checagem de host (mesmo truque do Ansible)
                sh 'apt-get update && apt-get install -y openssh-client'
                sh 'mkdir -p ~/.ssh && echo "StrictHostKeyChecking no" >> ~/.ssh/config'

                // 2. Abre o cofre do Jenkins e injeta a chave de forma segura
                withCredentials([sshUserPrivateKey(credentialsId: 'aws-lab-key', keyFileVariable: 'SSH_KEY', usernameVariable: 'SSH_USER')]) {
                    
                    // 3. Copia a pasta compilada para o servidor da AWS
                    echo 'Transferindo arquivos via SCP...'
                    sh 'scp -i $SSH_KEY -r ./publish-output/* ${SSH_USER}@${AWS_IP}:/var/www/ExemploDevOps/'

                    // 4. Reinicia o serviço no Linux para aplicar a nova versão
                    echo 'Reiniciando o serviço da API...'
                    sh 'ssh -i $SSH_KEY ${SSH_USER}@${AWS_IP} "sudo systemctl restart webapi"'
                }
            }
        }
    }
}
