# Nim Windows Container

This repository contains:

* A [DOCKERFILE](https://github.com/sirredbeard/nim-windows-container/blob/main/Dockerfile) that builds a Windows Server Core Container with [Nim](https://nim-lang.org/) and [Mingw-w64](https://www.mingw-w64.org/) dependencies as a starting point for building Nim applications in Windows Containers.
* A [GitHub Actions workflow](https://github.com/sirredbeard/nim-windows-container/blob/main/.github/workflows/stable.yml) for deploying the Windows Container to the GitHub Container Registry.

Working on Linux? See my GitHub Actions-automated [build of Nim snap packages](https://github.com/sirredbeard/nim_lang_snap).

## Nim

Nim is a compiled, garbage-collected systems programming language with a design that focuses on efficiency, expressiveness, and elegance.

* [Learn Nim](https://nim-lang.org/learn.html) - Tutorial
* [Documentation](https://nim-lang.org/documentation.html) - Documentation
* [Nim in Action](https://www.manning.com/books/nim-in-action) - Book from Manning Publications
* [What Is Nim? A brief introduction to the Nim programming language](https://www.youtube.com/watch?v=nKTLsUF9oyU) - YouTube video

## DOCKERFILE

The sample DOCKERFILE defaults to:

* Windows Server 2022 LTSC.
* Nim 1.4.8, the current stable release of Nim. It is very likely by the time you are reading this that Nim has since been updated. Check [nim-lang releases](https://github.com/nim-lang/Nim/releases) for the latest release.

## GitHub Actions Workflow

The sample GitHub Actions workflow:

* Builds the Windows Container for *both* Windows Server 2019 LTSC and Windows Server 2022 LTSC. The default of Windows Server 2022 LTSC is overridden by passing `--build-arg win_version=ltsc2019` into the DOCKERFILE.
* Detects and downloads the latest version of Nim by communicating with the GitHub REST API: ` $nim_version = ((Invoke-RestMethod -Uri https://api.github.com/repos/nim-lang/Nim/tags).Name | Select-Object -first 1).Trim("v") ` and passing resulting variable into the DOCKERFILE as a build argument: `
--build-arg nim_version=$nim_version` overriding the default, 1.4.8.

* Pushes the resulting container to the GitHub Container Registry.

## Windows Container

To use the Windows Container in GitHub Actions, fork this repo, let it build your own Windows Container, and then pull it in to your GitHub Actions with:

```
jobs:
  build:
    runs-on: windows-2022
    container:
      image: docker.pkg.github.com/[username]/nim-windows-container/nimstable-ltsc2022:latest
      credentials:
        username: ${{ github.actor }}
        password: ${{ secrets.GITHUB_TOKEN }}
```
