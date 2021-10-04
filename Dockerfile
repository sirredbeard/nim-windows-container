ARG win_version=ltsc2022
FROM mcr.microsoft.com/windows/servercore:$win_version

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]

ARG nim_version=1.4.8
ARG nim_uri="https://nim-lang.org/download/nim-"$nim_version"_x64.zip"

RUN Invoke-WebRequest -Uri $env:nim_uri -OutFile nim.zip

RUN Expand-Archive -Path 'nim.zip' -DestinationPath 'c:\'

RUN Get-ChildItem -Path 'c:\' | Where-Object { $_.Name -like 'nim-*' } | %{ Rename-Item -LiteralPath $_.FullName -NewName 'nim' }

WORKDIR "c:\nim"

RUN "./finish.exe -y"
RUN "nimble update"

RUN Remove-Item c:\nim.zip
RUN Remove-Item c:\nim\dist\mingw64.7z