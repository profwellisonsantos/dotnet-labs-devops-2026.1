# Usamos a sua imagem customizada que já tem TUDO
FROM wellisonraul/dotnet-sonar-sdk:8.0 AS build
WORKDIR /src

ARG SONAR_TOKEN
ARG SONAR_HOST_URL
ARG APP_KEY="weatherforecast"

COPY . .
RUN dotnet restore

# Inicia a análise (O Java e o Scanner já estão lá!)
RUN dotnet sonarscanner begin /k:"${APP_KEY}" \
    /d:sonar.token="${SONAR_TOKEN}" \
    /d:sonar.host.url="${SONAR_HOST_URL}" \
    /d:sonar.cs.opencover.reportsPaths="**/coverage.opencover.xml"

RUN dotnet build --configuration Release
RUN dotnet test --configuration Release --no-build --collect:"XPlat Code Coverage" -- DataCollectionRunSettings.DataCollectors.DataCollector.Configuration.Format=opencover

RUN dotnet sonarscanner end /d:sonar.token="${SONAR_TOKEN}"

# Publish
RUN dotnet publish "ExemploDevOps.Api/ExemploDevOps.Api.csproj" -c Release -o /app/publish

# Estágio Final (Runtime leve)
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/publish .
EXPOSE 8080
ENTRYPOINT ["dotnet", "ExemploDevOps.Api.dll"]