# Set our default Windows Server LTSC version to 2022
ARG win_version=ltsc2022

# Pull our Windows Container from the Microsoft Container Reigstry
FROM mcr.microsoft.com/windows/servercore:$win_version

# Set our shell to PowerShell and specify error handling
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]

# Set our default Nim version, see the note in README.md, this is automatically overridden by the GitHub Actions workflow
ARG nim_version=1.4.8

# Build our Nim download URL using our Nim version
ARG nim_uri="https://nim-lang.org/download/nim-"$nim_version"_x64.zip"

# Download compiled Nim binaries, saving them as nim.zip to simplify things
RUN Invoke-WebRequest -Uri $env:nim_uri -OutFile nim.zip

# Expand nim.zip to c:\
RUN Expand-Archive -Path 'nim.zip' -DestinationPath 'c:\'

# Rename the resulting extracted directory, e.g. c:\nim-1.4.8, to just c:\nim, to provide a consistent location
RUN Get-ChildItem -Path 'c:\' | Where-Object { $_.Name -like 'nim-*' } | %{ Rename-Item -LiteralPath $_.FullName -NewName 'nim' }

# Change our Docker work directory to our extracted Nim location
WORKDIR "c:\nim"

# Run the Nim programming language Windows post-install tool to download Mingw-w64 and set Nim and Mingw-w64 path variables, see https://github.com/nim-lang/Nim/blob/devel/tools/finish.nim 
RUN "./finish.exe -y"

# Refresh the Nim package manager cache, see https://github.com/nim-lang/nimble
RUN "nimble update"

# Clean up some artifacts, to try to keep this Windows Container as light as possible
RUN Remove-Item c:\nim.zip
RUN Remove-Item c:\nim\dist\mingw64.7z
