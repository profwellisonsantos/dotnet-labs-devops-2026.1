DevOps Lab: Deploy contínuo na AWS (II) (Aula 04)
=======================================================

Este repositório contém o material prático da **Aula 04**, onde exploramos o empacotamento de aplicações .NET 8 utilizando **Docker** e a automação de build e deploy através do **Jenkins**.

O objetivo principal é demonstrar como garantir que a aplicação rode de forma idêntica em qualquer ambiente, eliminando o problema do "na minha máquina funciona".

📋 Sobre a Aplicação
--------------------

A aplicação é uma Web API simples em .NET 8, acompanhada de um projeto de testes xUnit. A estrutura foi gerada com os seguintes comandos:

Bash

```   
# Criação dos projetos e solução  
dotnet new webapi -n ExemploDevOps.Api  
dotnet new xunit -n ExemploDevOps.Tests  
dotnet new sln  

dotnet sln add ExemploDevOps.Api ExemploDevOps.Tests  

# Utilitários e Build local  
dotnet new gitignore  
dotnet build  dotnet test
```

⚠️ Pré-requisitos do Ambiente
---------------
Para o funcionamento deste pipeline, certifique-se de:
1.  Instalar o plugin Docker Pipeline no Jenkins.
2.  Configurar as credenciais do Docker Hub no Jenkins com o ID dockerhub.
3.  Garantir que o usuário jenkins tenha permissão para executar comandos Docker no servidor (sudo usermod -aG docker jenkins).
4.  Ter o Docker Engine instalado tanto no Jenkins Master quanto no Agent de Deploy (AWS).


🐳 Dockerização
---------------

Utilizamos um **Dockerfile multi-stage** para otimizar o tamanho da imagem final e garantir a segurança, separando o ambiente de compilação (SDK) do ambiente de execução (ASP.NET Runtime).

### Principais características:

*   **Build Stage**: Restaura dependências, compila, testa e publica a aplicação.
    
*   **Final Stage**: Utiliza uma imagem leve e expõe a porta **8080**. Veja o Dockerfile para mais informações
    
*   **Isolamento**: Todo o runtime e bibliotecas necessários estão contidos na imagem.
    

Para rodar localmente:

`docker build -t exemplo-devops-api .  docker run -d -p 8080:8080 exemplo-devops-api   `

⚙️ Pipeline de CI/CD (Jenkinsfile)
----------------------------------

O pipeline automatizado foi desenhado para suportar múltiplas branches, permitindo deploys independentes:

1.  **Build e Push**:
    
    *   O Jenkins compila a imagem Docker.
        
    
2.  **Deploy por Branch**:
    
    *   O deploy é feito em um servidor alvo (rotulado como aws-server).
        
    *   **Isolamento de Portas**: A branch selecionada é publicada na porta **5000**, enquanto a develop (ou outras) fica na porta **5001**.
        
    *   O container anterior é removido antes da atualização para evitar conflitos.
        

🛠️ Tecnologias Utilizadas
--------------------------

*   **.NET 8**: Framework da aplicação.
*   **Docker**: Containerização e isolamento.
*   **Jenkins**: Orquestração do pipeline de CI/CD.
*   **Docker Hub**: Registro público de imagens.
    

> **Nota Profissional:** Este projeto reforça a importância da **Padronização**. Assim como um contêiner de navio transporta qualquer carga de forma universal, o Docker transporta sua aplicação sem que o servidor precise conhecer os detalhes internos.

**Professor:** Wellison Santos

**Instituição:** Instituto Infnet

**Contato:** wellison.santos@prof.infnet.edu.br