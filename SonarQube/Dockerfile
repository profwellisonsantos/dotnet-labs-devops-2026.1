FROM mcr.microsoft.com/dotnet/sdk:8.0

# Instala o JRE (necessário para o Sonar) apenas uma vez
RUN apt-get update && apt-get install -y --no-install-recommends \
    openjdk-17-jre \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Instala o SonarScanner globalmente
RUN dotnet tool install --global dotnet-sonarscanner
ENV PATH="$PATH:/root/.dotnet/tools"