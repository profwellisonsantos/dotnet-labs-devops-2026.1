Esta branch demonstra a implementação de uma pipeline de CI/CD utilizando **Jenkins** para automação, **SonarQube** para análise de qualidade de código e **Docker** para deploy.

📋 Pré-requisitos
-----------------

*   **Jenkins** com os plugins: SonarQube Scanner e Docker Pipeline.
    
*   **SonarQube Server** ativo (via Docker ou instalação local).
    
*   **Agente Jenkins** com SDK .NET e Docker instalados.
    

Passo 1: Configuração no SonarQube
--------------------------------------

1.  **Gerar Token de Acesso:**
    
    *   No SonarQube, vá em My Account > Security.
        
    *   Gere um token do tipo **User Token** e guarde-o.
        
2.  **Nota:** Certifique-se de que a barra / ao final da URL esteja presente.
    
    *   Vá em Administration > Configuration > Webhooks.
        
    *   Clique em **Create**.
        
    *   **Name:** Jenkins-Webhook
        
    *   **URL:** http://IP_JENKINS:8080/sonarqube-webhook/
        

Passo 2: Configuração no Jenkins
-----------------------------------

### 1\. Credenciais

Vá em Manage Jenkins > Credentials e adicione:

*   **SonarQube Token:** Secret Text (use o token gerado no passo anterior). ID sugerido: SONAR\_AUTH\_TOKEN.
    
*   **DockerHub:** Username with password. ID sugerido: dockerhub. Lembre-se que a senha do do DockerHub também precisa ser um Token. 
    

### 2\. Configurar o System Server

1.  Vá em Manage Jenkins > System.
    
2.  Procure por **SonarQube servers**.
    
3.  Adicione um servidor:
    
    *   **Name:** SonarQube-Server (deve ser igual ao usado no Jenkinsfile).
        
    *   **Server URL:** URL do seu servidor SonarQube.
        
    *   **Server authentication token:** Selecione a credencial que você criou.
        

A Pipeline (Jenkinsfile)
---------------------------

A pipeline realiza a análise estática antes de buildar a imagem Docker final. Se o código não passar no **Quality Gate**, o deploy é abortado automaticamente.


Explicação dos Pontos Chave
------------------------------

### 1\. withSonarQubeEnv

Este comando do plugin do Jenkins garante que a pipeline saiba para qual servidor enviar os dados. Ele injeta variáveis como ${SONAR\_HOST\_URL} e ${SONAR\_AUTH\_TOKEN} dinamicamente.

### 2\. waitForQualityGate

Este é o ponto de controle. Sem o **Webhook** configurado no SonarQube apontando para o Jenkins, este stage ficaria em loop infinito até o timeout. Ele permite que a pipeline seja interrompida se o índice de bugs ou vulnerabilidades estiver acima do permitido.

### 3\. Coleta de Cobertura (Code Coverage)

No comando dotnet test, usamos o formato opencover. O SonarQube lê esse arquivo para mostrar a porcentagem de código testado na interface gráfica.

Como Executar
----------------

1.  Certifique-se de que o SonarQube está rodando.
    
2.  Crie um novo item de MultiBranch Pipeline no Jenkins.
    
3.  Aponte para o repositório Git que contém este arquivo.
    
4.  Execute o Build.