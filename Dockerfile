FROM mcr.microsoft.com/dotnet/sdk:8.0 as build
WORKDIR /app

COPY TestApi.csproj .
RUN dotnet restore

COPY . .
RUN dotnet publish -c Release -o out

# Build the runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/out ./
COPY container.pfx ./

# Expose the port your application will run on
EXPOSE 8080

# Start the application
ENTRYPOINT ["dotnet", "TestApi.dll"]