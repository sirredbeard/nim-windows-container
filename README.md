![Untitled3](https://user-images.githubusercontent.com/33820650/135938247-73d13189-29bd-4da0-a914-732b9145dce8.png)

# Nim Windows Container

This repository contains:

* A [Dockerfile](https://github.com/sirredbeard/nim-windows-container/blob/main/Dockerfile) that builds a Windows Server Core Container with [Nim](https://nim-lang.org/), [MinGit](https://github.com/git-for-windows/git/wiki/MinGit), and [Mingw-w64](https://www.mingw-w64.org/) dependencies as a starting point for building Nim applications in Windows Containers.
* A [GitHub Actions workflow](https://github.com/sirredbeard/nim-windows-container/blob/main/.github/workflows/stable.yml) for deploying the Windows Container to the GitHub Container Registry.

## Nim

Nim is a compiled, garbage-collected systems programming language with a design that focuses on efficiency, expressiveness, and elegance.

* [Nim](https://github.com/nim-lang/Nim) - Nim GitHub repo
* [Learn Nim](https://nim-lang.org/learn.html) - Nim Tutorial
* [Documentation](https://nim-lang.org/documentation.html) - Nim Documentation
* [Nim in Action](https://www.manning.com/books/nim-in-action) - Book from Manning Publications
* [What Is Nim? A brief introduction to the Nim programming language](https://www.youtube.com/watch?v=nKTLsUF9oyU) - YouTube video

## Dockerfile

The sample [Dockerfile](https://github.com/sirredbeard/nim-windows-container/blob/main/Dockerfile) defaults to:

* Windows Server 2022 LTSC.
* Nim 1.6.12, the current stable release of Nim. It is very likely by the time you are reading this that Nim has since been updated. Check [nim-lang releases](https://github.com/nim-lang/Nim/releases) for the latest release. See the GitHub Actions below for how the latest version is automatically pulled in to the Windows Container published here.

## GitHub Actions Workflow

The sample [GitHub Actions workflow](https://github.com/sirredbeard/nim-windows-container/blob/main/.github/workflows/stable.yml):

* Builds the Windows Container for and Windows Server 2022 LTSC. 
* Detects and downloads the latest version of Nim by communicating with the GitHub REST API: ` $nim_version = ((Invoke-RestMethod -Uri https://api.github.com/repos/nim-lang/Nim/tags).Name | Select-Object -first 1).Trim("v") ` and passing the most recent version into the Dockerfile as a build argument: `
--build-arg nim_version=$nim_version`, overriding the default of 1.6.12.
* Pushes the resulting container to the GitHub Container Registry.

It is not currently possible to run Windows Containers on GitHub Actions at this time, the runner only supports Linux containers. [:(](https://github.com/actions/runner/issues/1402)

## Windows Container

### Prerequisites for Windows Containers

To use the Windows Container, you'll need:

* Windows 10/11 Pro or Enterprise editions or Windows Server 2022
* To enable Windows Containers:

As Administator, open PowerShell, and enable Windows Containers:

`Enable-WindowsOptionalFeature -Online -FeatureName containers –All`

`Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V –All`

* A container runtime that supports Windows Containers:

    * Docker Desktop: Install [Docker Desktop](https://docs.docker.com/desktop/) and [specify use of Windows Containers](https://learn.microsoft.com/en-us/virtualization/windowscontainers/quick-start/set-up-environment?tabs=dockerce#windows-10-and-11-1)
    * Docker CE: Install the Docker freely distributed binaries using [this guide](https://boxofcables.dev/a-lightweight-windows-container-dev-environment/)


### Windows Server 2022 Core LTSC base

To get the Windows Container:

`docker pull ghcr.io/sirredbeard/nim-windows-container/nimstable-ltsc2022:latest`

To start the Windows Container on pause, so you can exec in:

`docker run ghcr.io/sirredbeard/nim-windows-container/nimstable-ltsc2022:latest pause.exe`

Also see the GitHub Container Registry [page](https://github.com/sirredbeard/nim-windows-container/pkgs/container/nim-windows-container%2Fnimstable-ltsc2022).

### Build Yourself 

To build and use the Windows Container yourself, you can use the Dockerfile and build locally, or:

* Fork this repo
* Let GitHub build your own Windows Container
* Grab your [GitHub Personal Access Token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) from [here](https://github.com/settings/tokens)
* Give your PAT access to read packages:

![image](https://user-images.githubusercontent.com/33820650/135933784-450c5f7f-972e-472e-ab87-7e72532803b7.png)
* Run:
```
Set-Variable -Name "CR_PAT" -Value "<PAT>"
echo $CR_PAT | docker login ghcr.io -u USERNAME --password-stdin
docker pull ghcr.io/<USERNAME>/nim-windows-container/nimstable-ltsc2019:latest``
