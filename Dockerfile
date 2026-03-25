# Etapa 1: Build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# Define o diretório de trabalho
WORKDIR /src

# Copia o arquivo de projeto e restaura as dependências
COPY . .

RUN dotnet build

RUN dotnet test

ENTRYPOINT ["dotnet", "run", "sleep 300"]
