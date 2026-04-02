CI/CD Pipeline: Secret Management com Infisical & Qualidade com SonarQube
============================================================================

Esta branch apresenta uma pipeline avançada que integra o **Infisical** para a gestão centralizada de variáveis de ambiente e segredos, garantindo que credenciais sensíveis nunca fiquem expostas no código-fonte ou nos logs do Jenkins.

Fluxo da Pipeline
--------------------

1.  **Secret Injection:** Recupera segredos do Infisical em tempo real.
    
2.  **Docker Build:** Gera imagens tagueadas por Branch e Build ID.
    
3.  **Dynamic Deploy:** Realiza o deploy em portas diferentes baseando-se na Branch (main vs others).
    

Configuração do Infisical
-----------------------------

### 1\. Criar Projeto e Segredos

No painel do Infisical:

*   Crie um projeto (ex: aula03-4-aak).
    
*   No ambiente de dev, adicione as chaves: data1 e data2.
    

### 2\. Configurar Identidade no Jenkins

Para que o Jenkins tenha permissão de ler os segredos:

1.  No Infisical, vá em **Access Control > Machine Identities**.
    
2.  Crie uma identidade e gere um **Client ID** e **Client Secret**.
    
3.  No Jenkins, vá em **Manage Jenkins > Credentials** e adicione uma credencial do tipo **Infisical Machine Identity**:
    
    *   **ID:** Infisical (deve bater com o infisicalCredentialId no Jenkinsfile).
        
    *   Insira o Client ID e Client Secret gerados.
    

📦 Como Executar
----------------

1.  **Instalar Plugins:** Certifique-se de que o plugin **Infisical** está instalado no seu Jenkins.
    
2.  **Configurar Agente:** O agent deve ter o Docker instalado e permissões para executar comandos sh.
    
3.  **Executar Job:** Crie um job do tipo Pipeline Multibranch ou Pipeline simples apontando para este repositório.
