Provisionamento de Infraestrutura com Terraform
==================================================

Este repositório contém os arquivos de configuração do **Terraform** para automatizar a criação de toda a infraestrutura necessária na **AWS** para hospedar uma Web API .NET.

O objetivo é utilizar **Infraestrutura como Código (IaC)** para garantir que o ambiente (rede, segurança e servidor) seja criado de forma rápida, segura e replicável.

🛠️ Pré-requisitos
------------------

Antes de iniciar, certifique-se de que:

*   Você possui uma conta ativa na **AWS Academy**.
    
*   O **AWS CLI** está instalado e configurado (aws configure).
    
*   O **Terraform** está instalado em sua máquina.
    

🔑 1. Preparação da Chave de Acesso
-----------------------------------

O Terraform irá cadastrar sua chave pública na AWS para que você possa acessar a instância via SSH ou Ansible posteriormente.

### Gerar o par de chaves:

Execute o comando abaixo no terminal para criar a chave lab-key:

`ssh-keygen -t rsa -b 2048 -f lab-key -N ""`

### Ajustar permissões (Linux/macOS/WSL):

É necessário restringir a permissão da chave privada para que o SSH funcione:

`chmod 400 lab-key`

🚀 2. Executando o Terraform
----------------------------

Com os arquivos .tf no diretório, siga a sequência de comandos abaixo:

### Inicializar o projeto:

Baixa o provider da AWS e prepara o ambiente de trabalho.

`terraform init`

### Planejar a execução:

Verifica o que será criado sem aplicar nenhuma mudança real ainda.

`terraform plan`

### Aplicar as mudanças:

Cria os recursos na AWS. Digite yes quando solicitado.

`terraform apply`

📋 O que este código automatiza?
--------------------------------

A automação está dividida em quatro partes principais:

1.  **Provider AWS:** Define a região de trabalho (padrão us-east-1).
    
2.  **AWS Key Pair:** Sobe sua chave pública (lab-key.pub) para a nuvem, permitindo o acesso remoto.
    
3.  **Security Group (Firewall):** 
    * Libera a **porta 80 (HTTP)** para o tráfego da API.
    
    *   Libera a **porta 22 (SSH)** para gerenciamento via terminal ou Ansible.

    *   Libera a **porta 5000 (SSH)** para o tráfego da API.
        
    *   Libera todo o tráfego de saída (Egress) para atualizações do sistema.
        
4.  **Instância EC2:** Provisiona um servidor Ubuntu 22.04 LTS (t2.micro) já atrelado ao firewall e à chave de acesso.
    

🔗 Próximos Passos
------------------

Ao final da execução, o Terraform exibirá no terminal o **IP Público** da instância.

Utilize este IP para a próxima etapa: **Automação de Configuração com Ansible**, onde iremos preparar o software (Runtime .NET e Systemd) dentro desta máquina recém-criada.