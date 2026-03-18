# mender-app-gen
Slightly modified version of mender's [app-gen tool](https://raw.githubusercontent.com/mendersoftware/app-update-module/1.0.0/gen/app-gen)

Use to generate application update artifacts. 

## Requirements

* docker
* mender-artifact
* jq
* make

## Usage

See `examples/` for an example how to build an artifact for a containerized application.

You may run `examples/install.sh` to install the required dependencies on a Debian-based system.

Then run `make` in the `examples/` directory to build the artifact. The resulting artifact will be placed in `examples/artifacts/`.