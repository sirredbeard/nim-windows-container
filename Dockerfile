# Set our default Windows Server LTSC version to 2022
ARG win_version=ltsc2022

# Pull our Windows Container from the Microsoft Container Registry
FROM mcr.microsoft.com/windows/servercore:$win_version as build

# Set our shell to PowerShell and specify error handling
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]

# Set our default Nim version, see the note in README.md, this is automatically overridden by the GitHub Actions workflow with the latest versions polled from GitHub
ARG nim_version=1.6.12

# Build our Nim download URL using our Nim version
ARG nim_uri="https://nim-lang.org/download/nim-"$nim_version"_x64.zip"

# Download compiled Nim binaries, saving them as nim.zip to simplify things
RUN Invoke-WebRequest -Uri $env:nim_uri -OutFile nim.zip

# Expand nim.zip to c:\
RUN Expand-Archive -Path 'nim.zip' -DestinationPath 'c:\'

# Rename the resulting extracted directory, e.g. c:\nim-1.4.8, to just c:\nim, to provide a consistent location
RUN Get-ChildItem -Path 'c:\' | Where-Object { $_.Name -like 'nim-*' } | %{ Rename-Item -LiteralPath $_.FullName -NewName 'nim' }

# Download Nim container pause application
RUN Invoke-WebRequest -Uri https://github.com/sirredbeard/nim-pause/releases/download/0.1/pause.exe -OutFile C:\nim\pause.exe

#---

# Pull our Windows Container from the Microsoft Container Registry
FROM mcr.microsoft.com/windows/servercore:$win_version

# Set our shell to PowerShell and specify error handling
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]

# Change our Docker work directory to our extracted Nim location
WORKDIR "c:\nim"

# Set the Path environment variable to include various locations
RUN "[Environment]::SetEnvironmentVariable('Path', '${env:Path};C:\nim\bin;C:\nim\dist\mingw64\bin;${env:USERPROFILE}\.nimble\bin;c:\nim\dist\mingit\cmd', [System.EnvironmentVariableTarget]::User)"

# Copy the c:\nim directory from the build container
COPY --from=build "c:\nim" "c:\nim"

# Run Nim finish.exe non-interactively to complete Nim environment
RUN "C:\nim\finish.exe -y"

# Refresh the Nim package manager cache, see https://github.com/nim-lang/nimble
RUN "nimble update"
