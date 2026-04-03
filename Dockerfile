FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY . .
RUN dotnet restore
RUN dotnet build
RUN dotnet test

RUN dotnet publish "sample1.csproj" -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app

ARG data1
ARG data2

ENV data1=$data1
ENV data2=$data2

COPY --from=build /app/publish .

EXPOSE 8080

ENTRYPOINT ["dotnet", "sample1.dll"]