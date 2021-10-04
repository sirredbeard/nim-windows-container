# Nim Windows Container

This repository contains:

* A [DOCKERFILE](https://github.com/sirredbeard/nim-windows-container/blob/main/Dockerfile) that builds a Windows Server Core Container with [Nim](https://nim-lang.org/) and [Mingw-w64](https://www.mingw-w64.org/) dependencies as a starting point for building Nim applications in Windows Containers.
* A [GitHub Actions workflow](https://github.com/sirredbeard/nim-windows-container/blob/main/.github/workflows/stable.yml) for deploying the Windows Container to the GitHub Container Registry.

## Nim

Nim is a compiled, garbage-collected systems programming language with a design that focuses on efficiency, expressiveness, and elegance.

* [Learn Nim](https://nim-lang.org/learn.html) - Tutorial
* [Documentation](https://nim-lang.org/documentation.html) - Documentation
* [Nim in Action](https://www.manning.com/books/nim-in-action) - Book from Manning Publications
* [What Is Nim? A brief introduction to the Nim programming language](https://www.youtube.com/watch?v=nKTLsUF9oyU) - YouTube video

## DOCKERFILE

The sample DOCKERFILE defaults to:

* Windows Server 2022 LTSC
* Nim 1.4.8, the current stable release of Nim. It is very likely by the time you are reading this that Nim has since been updated. Check [nim-lang releases](https://github.com/nim-lang/Nim/releases) for the latest release.

## GitHub Actions Workflow

The sample GitHub Actions workflow:

* Builds the Windows Container for *both* Windows Server 2019 LTSC and Windows Server 2022 LTSC.
* Detects and downloads the latest version of Nim by communicating with the GitHub REST API.

## Windows Container

To grab the Windows Container built here for use in your GitHub Actions:

```
jobs:
  build:
    runs-on: windows-2019
    container:
      image: docker.pkg.github.com/[username]/nim-windows-container/nimstable-ltsc2019:latest
      credentials:
        username: ${{ github.actor }}
        password: ${{ secrets.GITHUB_TOKEN }}
```
