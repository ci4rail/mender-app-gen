# Define variables
ARTIFACT_NAME ?= app
ORCHESTRATOR ?= docker-compose
OUTPUT_DIR ?= ./artifacts

# List of platforms and architectures
PLATFORMS ?= linux/arm64 # linux/amd64

# List of app directories 
APP_DIRS = ./app/nginx-demo

# List of device types
DEVICE_TYPES ?= moducop-cpu01

# Default target
all: build-artifacts

# Get the current commit SHA as default version
VERSION ?= $(shell git rev-parse --short HEAD)

# Target to build and upload Mender artifacts for each manifest directory, platform, and device type
build-and-upload: build-artifacts upload-artifacts

# Target to build Mender artifacts for each manifest directory, platform, and device type
build-artifacts:
	@mkdir -p $(OUTPUT_DIR)
	@for platform in $(PLATFORMS); do \
		formatted_platform=$$(echo $$platform | tr '/' '_'); \
		for dir in $(APP_DIRS); do \
			images=$$(../gen-image-names.sh $$dir/manifest/docker-compose.yaml); \
			echo "Using Images: $$images"; \
			for device in $(DEVICE_TYPES); do \
	     		artifact_name=$(ARTIFACT_NAME)-$$(basename $$dir)-$$device-$$formatted_platform-$(VERSION); \
				echo "Artifact name: $$artifact_name"; \
				output_path=$(OUTPUT_DIR)/$$artifact_name.mender; \
				echo "SOFTWARE_VERSION=$(VERSION)" > "$$dir/manifest/.env"; \
				echo "Building Mender artifact for $$dir, device $$device, platform $$platform with commit $(VERSION)..."; \
				../app-gen.sh --artifact-name "$$artifact_name" \
				        --device-type "$$device" \
				        --platform "$$platform" \
				        --application-name "$$(basename $$dir)" \
				        $$images \
				        --orchestrator "$(ORCHESTRATOR)" \
				        --manifests-dir "$$dir/manifest" \
				        --output-path "$$output_path" \
				        -- \
				        --software-name="$$(basename $$dir)" \
				        --software-version="$(VERSION)" \
						--software-filesystem=data-partition \
				echo "Mender artifact built successfully: $$output_path"; \
			done \
		done \
	done

# Clean target to remove all artifact files
clean:
	@echo "Cleaning up..."
	@rm -rf $(OUTPUT_DIR)
	@echo "Clean up completed."

.PHONY: all build-artifacts clean
