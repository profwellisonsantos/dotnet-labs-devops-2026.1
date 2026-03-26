DevOps Lab: Deploy contínuo na AWS (I) - Terraform + Ansible (Aula 03)
=======================================================

Este repositório centraliza a estratégia de automação para o provisionamento e configuração de servidores na **AWS**. O objetivo é que você não precise configurar nada manualmente via console ou terminal SSH, garantindo um ambiente 100% replicável e livre de erros humanos.

🏗️ Passo 1: Provisionamento com Terraform
------------------------------------------

Antes de configurar o software, precisamos do hardware (ou da instância na nuvem). O Terraform é o responsável por falar com a API da Amazon e levantar os recursos.

*   **O que ele faz:** Cria a instância EC2 (Ubuntu 22.04), define o par de chaves e abre as portas de rede (22, 80, 5000).
    
*   **Ação:** Acesse o guia detalhado em [**/terraform**](https://www.google.com/search?q=./terraform&authuser=1) para realizar o init, plan e apply.
    
*   **Resultado:** Ao final, você terá o **IP Público** da sua máquina.
    

🔧 Passo 2: Configuração com Ansible
------------------------------------

Com a máquina "viva", o Ansible assume o controle para transformá-la em um servidor web funcional. Ele entra via SSH e instala tudo o que é necessário.

*   **O que ele faz:** Instala o Runtime do .NET 8.0, cria a estrutura de pastas e configura o serviço (Systemd) para a API.
    
*   **Ação:** Utilize o IP gerado no passo anterior e siga as instruções em [**/ansible**](https://www.google.com/search?q=./ansible&authuser=1).
    
*   **Resultado:** Um servidor pronto e padronizado, aguardando apenas o deploy da aplicação.
    

🧭 Ordem de Execução
--------------------

1.  **Terraform:** Levanta o "esqueleto" (Infraestrutura).
    
2.  **Ansible:** Dá o "cérebro" ao servidor (Configuração).
    

> **Nota:** O Terraform cuida do que está **fora** da máquina (rede, instância, firewall), enquanto o Ansible cuida do que está **dentro** (pacotes, serviços, usuários).

**Professor:** Wellison Santos

**Instituição:** Instituto Infnet

**Contato:** wellison.santos@prof.infnet.edu.br