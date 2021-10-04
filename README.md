![Untitled3](https://user-images.githubusercontent.com/33820650/135938247-73d13189-29bd-4da0-a914-732b9145dce8.png)

# Nim Windows Container

This repository contains:

* A [Dockerfile](https://github.com/sirredbeard/nim-windows-container/blob/main/Dockerfile) that builds a Windows Server Core Container with [Nim](https://nim-lang.org/) and [Mingw-w64](https://www.mingw-w64.org/) dependencies as a starting point for building Nim applications in Windows Containers.
* A [GitHub Actions workflow](https://github.com/sirredbeard/nim-windows-container/blob/main/.github/workflows/stable.yml) for deploying the Windows Container to the GitHub Container Registry.

*Working on Linux? See my GitHub Actions-automated [build of Nim snap packages](https://github.com/sirredbeard/nim_lang_snap).*

## Nim

Nim is a compiled, garbage-collected systems programming language with a design that focuses on efficiency, expressiveness, and elegance.

* [Learn Nim](https://nim-lang.org/learn.html) - Tutorial
* [Documentation](https://nim-lang.org/documentation.html) - Documentation
* [Nim in Action](https://www.manning.com/books/nim-in-action) - Book from Manning Publications
* [What Is Nim? A brief introduction to the Nim programming language](https://www.youtube.com/watch?v=nKTLsUF9oyU) - YouTube video

## Dockerfile

The sample [Dockerfile](https://github.com/sirredbeard/nim-windows-container/blob/main/Dockerfile) defaults to:

* Windows Server 2022 LTSC.
* Nim 1.4.8, the current stable release of Nim. It is very likely by the time you are reading this that Nim has since been updated. Check [nim-lang releases](https://github.com/nim-lang/Nim/releases) for the latest release.

## GitHub Actions Workflow

This sample [GitHub Actions workflow](https://github.com/sirredbeard/nim-windows-container/blob/main/.github/workflows/stable.yml):

* Builds the Windows Container for *both* Windows Server 2019 LTSC and Windows Server 2022 LTSC. The default of Windows Server 2022 LTSC is overridden for 2019 LTSC builds by passing `--build-arg win_version=ltsc2019` into the DOCKERFILE.
* Detects and downloads the latest version of Nim by communicating with the GitHub REST API: ` $nim_version = ((Invoke-RestMethod -Uri https://api.github.com/repos/nim-lang/Nim/tags).Name | Select-Object -first 1).Trim("v") ` and passing the most recent version into the Dockerfile as a build argument: `
--build-arg nim_version=$nim_version`, overriding the default of 1.4.8.
* Pushes the resulting container to the GitHub Container Registry.

It is not currently possible to run Windows Containers on GitHub Actions at this time, the runner only supports Linux containers. [:(](https://github.com/actions/runner/issues/1402)

## Windows Container

To use my builds:

### Windows Server 2019

`docker pull ghcr.io/sirredbeard/nim-windows-container/nimstable-ltsc2019:latest`

GitHub Container Registry [page](https://github.com/sirredbeard/nim-windows-container/pkgs/container/nim-windows-container%2Fnimstable-ltsc2019).

### Windows Server 2022

`docker pull ghcr.io/sirredbeard/nim-windows-container/nimstable-ltsc2022:latest`

GitHub Container Registry [page](https://github.com/sirredbeard/nim-windows-container/pkgs/container/nim-windows-container%2Fnimstable-ltsc2022).

### Build Yourself 

To build and use the Windows Container yourself, you can use the Dockerfile, or:

* Fork this repo
* Let GitHub build your own Windows Container
* Grab your [GitHub Personal Access Token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) from [here](https://github.com/settings/tokens)
* Give your PAT access to read packages

![image](https://user-images.githubusercontent.com/33820650/135933784-450c5f7f-972e-472e-ab87-7e72532803b7.png)
* Run
```
Set-Variable -Name "CR_PAT" -Value "<PAT>"
echo $CR_PAT | docker login ghcr.io -u USERNAME --password-stdin
docker pull ghcr.io/<USERNAME>/nim-windows-container/nimstable-ltsc2019:latest``
