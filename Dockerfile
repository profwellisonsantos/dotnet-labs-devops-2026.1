FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY . .
RUN dotnet restore
RUN dotnet build
RUN dotnet test

RUN dotnet publish "ExemploDevOps.Api/ExemploDevOps.Api.csproj" -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app

COPY --from=build /app/publish .

# Dentro do Docker, o arquivo launchSettings.json é ignorado. 
# A imagem mcr.microsoft.com/dotnet/aspnet:8.0 vem pré-configurada com a variável ASPNETCORE_HTTP_PORTS=8080
# Por isso a porta 8080 é a porta do container
EXPOSE 8080

ENTRYPOINT ["dotnet", "ExemploDevOps.Api.dll"]