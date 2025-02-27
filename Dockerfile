# Use Linux-based .NET SDK image for building
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# Set working directory
WORKDIR /src

# Copy solution and project files
COPY ["DockerDemo.sln", "."]
COPY ["DockerDemo/DockerDemo.csproj", "DockerDemo/"]
COPY ["ConsoleApp/ConsoleApp.csproj", "ConsoleApp/"]
COPY ["Winform/Winform.csproj", "Winform/"]

# Install required packages for WinForms
RUN apt-get update && apt-get install -y \
    libx11-dev \
    libfontconfig1 \
    xvfb \
    x11vnc \
    && rm -rf /var/lib/apt/lists/*

# Restore NuGet packages with EnableWindowsTargeting
RUN dotnet restore /p:EnableWindowsTargeting=true

# Copy the rest of the source code
COPY . .

# Build the solution
RUN dotnet build -c Release --no-restore /p:EnableWindowsTargeting=true

# Create runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0

WORKDIR /app
COPY --from=build /src/DockerDemo/bin/Release/net8.0 ./DockerDemo
COPY --from=build /src/ConsoleApp/bin/Release/net8.0 ./ConsoleApp
COPY --from=build /src/Winform/bin/Release/net8.0-windows ./Winform

# Install X11 and VNC dependencies
RUN apt-get update && apt-get install -y \
    libx11-6 \
    libfontconfig1 \
    xvfb \
    x11vnc \
    && rm -rf /var/lib/apt/lists/*

# Copy and set up the X11 startup script
COPY start-xvfb.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start-xvfb.sh

# Set environment variable for X11 forwarding
ENV DISPLAY=:99

# Set entry point to start X11 and your application
ENTRYPOINT ["/usr/local/bin/start-xvfb.sh", "dotnet", "DockerDemo/DockerDemo.dll"]