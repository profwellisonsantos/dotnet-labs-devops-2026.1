#!/bin/bash

# Configurações
URL="http://localhost:8081"
echo "🚀 Iniciando simulação de tráfego para a aula de Observabilidade..."
echo "Pressione [CTRL+C] para parar."

while true; do
  # 1. Rota Principal (Sucesso constante - RPS alto)
  curl -s -o /dev/null "$URL/" &

  # 2. Rota de Pagamento (Latência variável - Popula os Buckets do Histograma)
  # Usamos o & para não travar o loop esperando os 3 segundos de delay
  curl -s -o /dev/null "$URL/pagamento" &

  # 3. Rota de Checkout (Erros aleatórios - Alimenta o gráfico de Status 500)
  curl -s -o /dev/null "$URL/checkout" &

  # 4. Ataque de Fuzzing (Gera Erros 404 e Match Failures para Segurança)
  # Sorteia uma rota inexistente da lista
  INVALID_ROUTES=("admin" "wp-login" "config" "db_backup" "shell")
  RANDOM_ROUTE=${INVALID_ROUTES[$RANDOM % ${#INVALID_ROUTES[@]}]}
  curl -s -o /dev/null "$URL/$RANDOM_ROUTE" &

  # Pequena pausa para não "derreter" a CPU, mas manter o fluxo constante
  sleep 0.2
done
