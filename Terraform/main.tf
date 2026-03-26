# 1. Definição do Provedor (AWS)
provider "aws" {
  region = "us-east-1" # Norte da Virgínia (padrão para laboratórios)
}

resource "aws_key_pair" "chave_ssh_turma" {
  key_name   = "chave-lab-devops"
  public_key = file("lab-key.pub") # O Terraform lê o arquivo local
}

# 2. Criação do Security Group (O Firewall da nossa API .NET)
resource "aws_security_group" "dotnet_api_sg" {
  name        = "dotnet_api_sg"
  description = "Permite trafego HTTP para a API e SSH para administracao"

  # Regra de Entrada: Libera a porta 80 (Onde o Kestrel/Nginx vai expor a API)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Aberto para o mundo
  }

  # Regra de Entrada: Libera a porta 22 (SSH - Prepara o terreno para o Ansible)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Em um cenário real, restringiríamos ao IP da faculdade
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Em um cenário real, restringiríamos ao IP da faculdade
  }

  # Regra de Saída: Permite que o servidor baixe pacotes da internet (ex: SDK do .NET)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. Provisionamento do Servidor (Instância EC2)
resource "aws_instance" "dotnet_server" {
  # AMI do Ubuntu 22.04 LTS (Leve, amplamente documentada e excelente para rodar .NET)
  ami           = "ami-0c7217cdde317cfec" 
  instance_type = "t2.micro" # Elegível ao Free Tier

  key_name      = aws_key_pair.chave_ssh_turma.key_name

  # Atrela o firewall criado acima a esta máquina
  vpc_security_group_ids = [aws_security_group.dotnet_api_sg.id]

  # Tag para identificar o recurso no painel da AWS
  tags = {
    Name        = "Servidor-WebAPI-DotNet"
    Environment = "Laboratorio-DevOps"
  }
}

# 4. Output: Mostra o IP público no terminal assim que a máquina nascer
output "ip_publico_servidor" {
  description = "IP Publico para acessar a API ou conectar via SSH/Ansible"
  value       = aws_instance.dotnet_server.public_ip
}

