.PHONY: all get_packages run_unit format lint build

all: get_packages run_unit lint format build

get_packages:
	@echo "Downloading dart packages"
	@dart pub get

run_unit: get_packages ## Runs unit tests
	@echo "Running dart test..."
	@dart test || (echo "Error while running tests"; exit 1)

format:
	@echo "Formatting the code"
	@dart format .

lint: get_packages
	@echo "Verifying code..."
	@dart analyze . || (echo "Error in project"; exit 1)

build: get_packages
	@echo "Building DAP"
	@dart compile exe bin/pkg.dart -o bin/dap
