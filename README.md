Curso de DevOps e Automação - Laboratórios 🚀
=============================================

Professor: Wellison Raul Mariz Santos | Instituto Infnet

Bem-vindo ao repositório central dos nossos laboratórios de DevOps. Este projeto está organizado por **branches**, onde cada uma contém o código prático, os scripts e as instruções específicas para cada aula.

📌 Organização das Aulas
------------------------

Para acessar o conteúdo de uma aula específica, você deve alternar para a branch correspondente:

### 🔹 Aula 02: Automação com Jenkins (CI/CD)


Focada na criação de pipelines de integração e entrega contínua.

*   **Branch:** aula-02
    
*   **Conteúdo:** Jenkinsfile, scripts de automação de build e deploy para instâncias AWS.
    

### 🔹 Aula 03: Infraestrutura como Código (IaC)

Exploração de ferramentas para provisionamento e configuração automatizada.

*   **Branch:** aula-03
    
*   **Conteúdo:** Arquivos .tf do Terraform para provisionamento de EC2/Security Groups e Playbooks do Ansible para configuração de runtime .NET.

### 🔹 Aula 04: Dockerização (O fim do "Na minha máquina funciona")

Introdução ao **Docker** com foco em **Multi-stage Builds**.

*   **Build Stage:** SDK .NET para compilação e testes.
    
*   **Final Stage:** Runtime leve (ASP.NET) para execução, expondo a porta 8080.
    
*   **Deploy:** Implementação de isolamento de portas (Porta 5000 para Main, 5001 para Develop).
    

### 🔹 Aula 05: Engenharia de Qualidade (TDD & Mutação)

Focada em métricas reais de qualidade. Não apenas "escrever testes", mas validar a eficácia deles.

*   **Ciclo TDD:** Red-Green-Refactor.
    
*   **Cobertura:** Uso do **Coverlet** e geradores de relatórios HTML.
    
*   **Stryker.NET:** Testes de mutação para garantir que os testes realmente "matam" bugs propositais.
    

### 🔹 Aula 06: Ciclo de Vida e Segurança (SonarQube & Infisical)

O fechamento do pipeline com foco em governança e segurança de dados sensíveis.

*   **SonarQube:** Integração com **Webhooks** e **Quality Gates** que bloqueiam o deploy se a dívida técnica for alta.
    
*   **Infisical:** Gestão centralizada de segredos via **Machine Identities**, eliminando variáveis hardcoded nos Jenkinsfiles.
    

🛠️ Como navegar entre as aulas
-------------------------------

Se você estiver utilizando o terminal, use os comandos abaixo para navegar pelo conteúdo:

1.  git clone https://github.com/profwellisonsantos/dotnet-labs-devops-2026.1.git

2. cd dotnet-labs-devops-2026.1
    
3.  git branch -a
    
4.  git checkout aula-03
    

🚀 Tecnologias Utilizadas no Curso
----------------------------------

*   **Cloud:** AWS (EC2, VPC, Security Groups)
    
*   **CI/CD:** Jenkins
    
*   **IaC:** Terraform
    
*   **Gerenciamento de Configuração:** Ansible
    
*   **Framework:** .NET 8.0
    
🔗 Links Úteis
--------------
* [AWS Academy Portal](https://www.awsacademy.com/) - Portal de acesso aos laboratórios e certificações.

*   [Documentação Jenkins](https://www.jenkins.io/doc/)
    
*   [Documentação Terraform](https://developer.hashicorp.com/terraform/docs)
    
*   [Documentação Ansible](https://docs.ansible.com/)
    
*   **Documentação .NET:** [Microsoft Learn](https://learn.microsoft.com/dotnet/)
    
*   **Guia Stryker:** [Mutation Testing](https://stryker-mutator.io/)
    
*   **Infisical Docs:** [Secret Management](https://www.google.com/search?q=https://infisical.com/docs&authuser=1)
    


🚀 Como navegar entre os laboratórios
-------------------------------------

Para acessar o código prático de uma aula específica, utilize o git checkout:

1. Clone o repositório  `git clone https://github.com/profwellisonsantos/dotnet-labs-devops-2026.1.git`  
2. Entre na pasta `cd dotnet-labs-devops-2026.1`
3. Liste todas as aulas disponíveis  `git branch -a`  
4. Mude para a aula desejada (Exemplo: Aula 05)  `git checkout aula-05`

🔗 Links e Recursos Úteis
-------------------------

*   **Portal AWS Academy:** [Acesso aos Labs](https://www.awsacademy.com/)
    
*   **Documentação .NET:** [Microsoft Learn](https://learn.microsoft.com/dotnet/)
    
*   **Guia Stryker:** [Mutation Testing](https://stryker-mutator.io/)
    
*   **Infisical Docs:** [Secret Management](https://www.google.com/search?q=https://infisical.com/docs&authuser=1)
    

> **Nota do Professor:** Este repositório reflete o padrão de mercado atual. O objetivo é que você não aprenda apenas as ferramentas, mas também a **cultura de automação e segurança** por trás de cada comando.

**Contato Profissional:**📧 [wellison.santos@prof.infnet.edu.br](mailto:wellison.santos@prof.infnet.edu.br)
🔗 [LinkedIn](https://www.linkedin.com/in/wellison-santos/)
