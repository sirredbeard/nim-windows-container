# Set our default Windows Server LTSC version to 2022
ARG win_version=ltsc2022

# Pull our Windows Container from the Microsoft Container Reigstry
FROM mcr.microsoft.com/windows/servercore:$win_version as build

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

# Download compatible mingw binaries as mingw.7z (ported from finish.exe)
RUN Invoke-WebRequest -Uri "https://nim-lang.org/download/mingw64.7z" -OutFile mingw.7z

# Expand mingw.7z to c:\nim\dist (ported from finish.exe)
RUN cd "c:\nim\dist"; "c:\nim\bin\7zG.exe" x "c:\mingw.7z"


#---


FROM mcr.microsoft.com/windows/servercore:$win_version

# Set our shell to PowerShell and specify error handling
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]

# Change our Docker work directory to our extracted Nim location
WORKDIR "c:\nim"

# Set the Path environment variable to include nim, mingw, and nimble locations (ported from finish.exe)
RUN "[Environment]::SetEnvironmentVariable('Path', '${env:Path};C:\nim\bin;C:\nim\dist\mingw64\bin;${env:USERPROFILE}\.nimble\bin', [System.EnvironmentVariableTarget]::User)"

# Copy the c:\nim directory from the build container
COPY --from=build "c:\nim" "c:\nim"

# Refresh the Nim package manager cache, see https://github.com/nim-lang/nimble
RUN "nimble update"
