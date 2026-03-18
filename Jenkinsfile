pipeline {
    agent any // Pode ser substituído por um container Docker com o SDK do .NET, se a infra permitir

    stages {
        stage('Checkout') {
            steps {
                echo 'Baixando o código do repositório...'
                checkout scm
            }
        }

        stage('Restore') {
            steps {
                echo 'Restaurando pacotes e dependências do NuGet...'
                sh 'dotnet restore'
            }
        }

        stage('Build') {
            steps {
                echo 'Compilando a aplicação .NET...'
                // O --no-restore otimiza o tempo, pois já fizemos no passo anterior
                sh 'dotnet build --configuration Release --no-restore'
            }
        }

        stage('Test') {
            steps {
                echo 'Executando a suíte de testes unitários...'
                // O --no-build garante que estamos testando exatamente o que foi compilado na etapa anterior
                sh 'dotnet test --configuration Release --no-build --verbosity normal'
            }
        }
    }
    
    post {
        always {
            echo 'Esteira finalizada. Limpando o workspace...'
            cleanWs()
        }
        success {
            echo '✅ Pipeline executado com sucesso! A aplicação está íntegra.'
        }
        failure {
            echo '❌ Falha no pipeline. Verifique os logs do Build ou dos Testes.'
        }
    }
}
