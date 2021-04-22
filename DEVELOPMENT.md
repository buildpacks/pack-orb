## Prerequisites

* [Docker](https://www.docker.com/products/docker-desktop)
* [`circleci` CLI](https://circleci.com/docs/2.0/local-cli/#installation)
* Make (and build tools)
    * macOS: `xcode-select --install`
    * Windows:
        * `choco install cygwin make -y`
        * `[Environment]::SetEnvironmentVariable("PATH", "C:\tools\cygwin\bin;$ENV:PATH", "MACHINE")`

### Linting

```
make lint
```