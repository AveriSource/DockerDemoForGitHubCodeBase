# Use Windows Server Core as base image
FROM mcr.microsoft.com/dotnet/sdk:8.0-windowsservercore-ltsc2022 AS build

# Set working directory
WORKDIR /src

# Copy solution and project files
COPY ["DockerDemo.sln", "."]
COPY ["DockerDemo/DockerDemo.csproj", "DockerDemo/"]
COPY ["ConsoleApp/ConsoleApp.csproj", "ConsoleApp/"]
COPY ["Winform/Winform.csproj", "Winform/"]

# Restore NuGet packages
RUN dotnet restore

# Copy the rest of the source code
COPY . .

# Build the solution
RUN dotnet build -c Release --no-restore

# Create runtime image
FROM mcr.microsoft.com/dotnet/runtime:8.0-windowsservercore-ltsc2022

WORKDIR /app
COPY --from=build /src/DockerDemo/bin/Release/net8.0 ./DockerDemo
COPY --from=build /src/ConsoleApp/bin/Release/net8.0 ./ConsoleApp
COPY --from=build /src/Winform/bin/Release/net8.0 ./Winform

# Set entry point to your main application
ENTRYPOINT ["dotnet", "DockerDemo.dll"] 