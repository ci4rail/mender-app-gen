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

### Signing artifacts

Artifacts are unsigned by default. To sign them with the example private key, run from the repository root:

```sh
make -C examples SIGNING_KEY=./customer-artifact.key.pem
```

You can set `SIGNING_KEY` to another private key path. Relative paths are resolved from the `examples/` directory.

To also verify the signature when displaying the generated artifact, provide the matching public key:

```sh
make -C examples SIGNING_KEY=./customer-artifact.key.pem \
  VERIFICATION_KEY=./customer-artifact-pub.pem
```

`VERIFICATION_KEY` is optional. Without it, signed artifacts are displayed with a message that no verification key was provided. When invoking `app-gen.sh` directly, pass `--verification-key /path/to/public-key.pem` before the `--` separator. A failed verification makes the generator exit with an error.

The example key uses PKCS#8 format, which requires `mender-artifact` 3.10.1 or newer. Check your installed version with `mender-artifact --version`. If your distribution provides an older version (such as Ubuntu 24.04's 3.9.0), configure [Mender's official workstation tools APT repository](https://docs.mender.io/downloads/workstation-tools) before updating and installing `mender-artifact`.

Alternatively, convert the key to PKCS#1 format for older versions, preserving the original key:

```sh
cd examples
openssl rsa -in customer-artifact.key.pem \
  -traditional -out customer-artifact.rsa.key.pem
chmod 600 customer-artifact.rsa.key.pem
make SIGNING_KEY=./customer-artifact.rsa.key.pem
```

Conversion preserves the key pair, so the same public key can verify either format. Configure devices with the matching public key (`examples/customer-artifact-pub.pem`) using Mender's `ArtifactVerifyKey` setting; see [Sign and verify](https://docs.mender.io/artifact-creation/sign-and-verify). Keep the private signing key on the build system and provision only the public key to devices.
