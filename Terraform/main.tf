provider "aws" {
  region = "us-east-1" #
}

resource "aws_key_pair" "lab_key" {
  key_name   = "lab-key"
  public_key = file("lab-key.pub")
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg"
  description = "Portas para Jenkins Master e Agent"

  # Acesso SSH para administração
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Interface Web do Jenkins (Master)
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Comunicação JNLP (Agent para Master)
  ingress {
    from_port   = 50000
    to_port     = 50000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Saída livre para atualizações
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "jenkins_master" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.small"
  key_name      = aws_key_pair.lab_key.key_name
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "Jenkins-Master"
  }
}

# 5. Instância: Jenkins Agent
resource "aws_instance" "jenkins_agent" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.small"
  key_name      = aws_key_pair.lab_key.key_name
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "Jenkins-Agent"
  }
}

# Outputs para o seu controle e do Ansible
output "jenkins_master_public_ip" {
  description = "Use este IP no SSH/Ansible para configurar o Master"
  value       = aws_instance.jenkins_master.public_ip
}

output "jenkins_agent_public_ip" {
  description = "Use este IP no SSH/Ansible para configurar o Agent"
  value       = aws_instance.jenkins_agent.public_ip
}

# Output para a configuração INTERNA do Jenkins
output "jenkins_agent_private_ip" {
  description = "Use este IP DENTRO da interface do Jenkins para cadastrar o Node"
  value       = aws_instance.jenkins_agent.private_ip
}
