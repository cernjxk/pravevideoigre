# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Kopiraj solution in vse csproj datoteke
COPY *.sln ./
COPY videoigre.Web/*.csproj ./videoigre.Web/
COPY videoigre.ServiceDefaults/*.csproj ./videoigre.ServiceDefaults/
COPY videoigre.ApiService/*.csproj ./videoigre.ApiService/

# Restore samo Web projekt (vključi ServiceDefaults če je potreben)
RUN dotnet restore "videoigre.Web/videoigre.Web.csproj"

# Kopiraj vse datoteke
COPY videoigre.Web/ ./videoigre.Web/
COPY videoigre.ServiceDefaults/ ./videoigre.ServiceDefaults/

# Build in publish samo Web projekt
WORKDIR /src/videoigre.Web
RUN dotnet publish "videoigre.Web.csproj" -c Release -o /app/publish

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app

# Kopiraj zgrajeno aplikacijo
COPY --from=build /app/publish .

# Nastavi spremenljivke okolja
ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

# Zaženi Web aplikacijo
ENTRYPOINT ["dotnet", "videoigre.dll"]