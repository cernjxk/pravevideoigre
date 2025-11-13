# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Kopiraj csproj in restore
COPY videoigre/*.csproj ./videoigre/
RUN dotnet restore "./videoigre/videoigre.csproj"

# Kopiraj vse datoteke projekta
COPY videoigre/ ./videoigre/

# Build in publish
RUN dotnet publish "./videoigre/videoigre.csproj" -c Release -o /app/publish

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app

COPY --from=build /app/publish .

EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080

ENTRYPOINT ["dotnet", "videoigre.dll"]