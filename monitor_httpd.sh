#!/bin/bash

# 1. Pegar o Token (IMDSv2) - Note o uso de -s para silenciar erros de progresso
TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

# 2. Pegar o Instance ID usando o Token
INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)

# O comando retorna "active" se estiver ok
if [ "$(systemctl is-active httpd)" = "active" ]; then
    STATUS=1
else
    STATUS=0
fi

aws cloudwatch put-metric-data \
    --namespace "Infnet/EC2/Apache" \
    --metric-name "ApacheStatus" \
    --dimensions InstanceId=$INSTANCE_ID \
    --value $STATUS \
    --unit Count \
    --region us-east-1


sudo dnf install -y cronie
sudo systemctl enable crond --now
crontab -e

* * * * * /home/ec2-user/monitor_httpd.sh >> /tmp/monitor.log 2>&1

cat /tmp/monitor.log

while true; do
  /home/ec2-user/monitor_httpd.sh
  echo "Enviado às $(date)"
  sleep 60
done