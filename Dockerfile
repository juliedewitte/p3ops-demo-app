# Gebruik de officiële .NET SDK image voor bouwen
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /app

# Kopieer de projectbestanden en herstel de dependencies
COPY src/Server/*.csproj ./src/Server/
RUN dotnet restore src/Server/Server.csproj

# Kopieer de rest van de projectbestanden en bouw de applicatie
COPY . .
RUN dotnet publish src/Server/Server.csproj -c Release -o out

# Gebruik de .NET runtime image voor de runtime
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime
WORKDIR /app
COPY --from=build /app/out .

# Zet de environment variabelen, bijvoorbeeld voor de SQL-verbinding
ENV DOTNET_ENVIRONMENT=Production
ENV DOTNET_ConnectionStrings__SqlDatabase="Server=sqlserver;Database=SportStoreDB;User Id=sa;Password=yourStrong(!)Password;"

# Exposeer de poort waarop de app draait
EXPOSE 80

# Start de applicatie
ENTRYPOINT ["dotnet", "Server.dll"]
