# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY *.csproj ./
RUN dotnet restore

COPY . .
RUN dotnet publish -c Release -o /app

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app ./

# Azure App Service expects the container to listen on port 80
EXPOSE 80

# Force Kestrel to bind to port 80
ENTRYPOINT ["dotnet", "Dotnet_app.dll", "--urls", "http://*:80"]
