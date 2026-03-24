Automação de Servidor .NET com Ansible 🚀
=========================================

Este repositório contém as configurações necessárias para automatizar o provisionamento de um ambiente servidor na **AWS (EC2)** preparado para hospedar uma **Web API em .NET 8.0**.

O objetivo deste Playbook é garantir que o servidor esteja configurado de forma idêntica e consistente, pronto para receber o deploy automatizado via Jenkins.

🛠️ Pré-requisitos
------------------

Antes de iniciar, certifique-se de que:

*   Você possui uma instância **EC2 Ubuntu 22.04** ativa na AWS.
    
*   O **Security Group** da instância permite tráfego nas portas **22 (SSH)**, **80 (HTTP)** e **5000 (TCP)**.
    
*   Você possui o arquivo de chave privada (.pem) para acesso.
    
*   O arquivo da chave possui as permissões corretas: chmod 400 lab-key.pem.
    

📥 1. Instalação do Ansible
---------------------------

Caso ainda não tenha o Ansible instalado na sua máquina local ou nó de controle, utilize os comandos abaixo:

### No Ubuntu / WSL (Windows Subsystem for Linux):

```
sudo apt update  
sudo apt install software-properties-common -y  
sudo add-apt-repository --yes --update ppa:ansible ansible  
sudo apt install ansible -y
```

### No macOS (via Homebrew):

`brew install ansible`

🚀 2. Executando o Playbook
---------------------------

Para preparar o servidor remotamente, utilize o comando abaixo substituindo IP\_DA\_MAQUINA pelo endereço IP público da sua instância AWS:

`   ansible-playbook -i "IP_DA_MAQUINA," -u ubuntu --private-key lab-key.pem ansible.yml`

> **Nota Técnica:** A vírgula após o endereço IP no parâmetro -i é fundamental quando passamos um único host diretamente, pois indica ao Ansible que a string é uma lista de inventário e não o caminho para um arquivo.

### Detalhes dos Parâmetros:

*   \-i: Define o inventário (o destino da automação).
    
*   \-u: Define o usuário remoto (padrão ubuntu na AWS).
    
*   \--private-key: Caminho para a sua chave privada SSH.
    
*   ansible.yml: O arquivo que contém as tarefas de automação.
    

📋 O que este Playbook automatiza?
----------------------------------

Ao executar este script, as seguintes ações são realizadas no servidor alvo:

1.  **Atualização de Pacotes:** Executa o apt update para garantir que o cache do sistema esteja em dia.
    
2.  **Instalação do Runtime:** Instala o aspnetcore-runtime-8.0 (essencial para rodar a API sem precisar do SDK completo).
    
3.  **Estrutura de Pastas:** Cria o diretório /var/www/ExemploDevOps e define o dono como ubuntu (preparando para o envio de arquivos via Jenkins).
    
4.  **Serviço Systemd:** Cria o arquivo de configuração webapi.service, permitindo que a aplicação rode em segundo plano e reinicie sozinha em caso de falhas.
    
5.  **Habilitação do Serviço:** Deixa o serviço pronto para ser iniciado assim que os arquivos da aplicação forem entregues.
    

🔗 Próximos Passos (Integração CI/CD)
-------------------------------------

Após a conclusão deste Ansible, o servidor estará configurado e "aguardando". O próximo passo no pipeline de CI/CD é o **Jenkins** compilar a aplicação, transferir os binários via SCP e executar o comando de reinicialização do serviço: `sudo systemctl restart webapi`
