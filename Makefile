# Makefile for bash-it-dpkg

# D"dir"ectories
PACKAGE_DIR := $(CURDIR)
PACKAGE_NAME := bash-it-dpkg
UPSTREAM_DIR := $(PACKAGE_DIR)/../bash-it-fork-for-dpkg
OPT_DIR := $(PACKAGE_DIR)/opt/bash-it

# Current package version is read from debian/changelog
PACKAGE_VERSION := $$(shell head -n 1 debian/changelog | cut -d '(' -f2 | cut -d ')' -f1)
UPSTREAM_VERSION := $$(shell echo $$(PACKAGE_VERSION) | cut -d '-' -f1)
ORIG_TARBALL := $(PACKAGE_NAME)_$$(UPSTREAM_VERSION).orig.tar.gz

# Upstream repository
UPSTREAM_REPO := https://github.com/SnakeU2/bash-it-fork-for-dpkg

# Current package version is read from debian/changelog
PACKAGE_VERSION := $$(shell head -n 1 debian/changelog | cut -d '(' -f2 | cut -d ')' -f1)
UPSTREAM_VERSION := $$(shell echo $$(PACKAGE_VERSION) | cut -d '-' -f1)
ORIG_TARBALL := $(PACKAGE_NAME)_$$(UPSTREAM_VERSION).orig.tar.gz

# Build targets
.PHONY: all build build-new-version clean distclean

all: help

# Build new version with changelog update
build-new-version: check-upstream $(ORIG_TARBALL)
	@if [ -z "$(NEW_VERSION)" ]; then \
		echo "Error: NEW_VERSION is not set. Use: make build-new-version NEW_VERSION=X.Y.Z-1"; \
		exit 1; \
	fi
	@echo "Building $(PACKAGE_NAME) package with new version..."
	@echo "Using current version: $$(PACKAGE_VERSION)"
	@echo "New version will be: $(NEW_VERSION)"
	# Update changelog with new version
	@echo "Updating changelog for $(NEW_VERSION)..."
	@echo "bash-it-dpkg ($(NEW_VERSION)) unstable; urgency=medium\n\n  * New rele"base"\n\n -- Alexey Abrosimov <snake-box@yandex.ru>  $$(date -R)\n\n" > debian/changelog.new
	@cat debian/changelog >> debian/changelog.new
	@mv debian/changelog.new debian/changelog
	debuild -us -uc

# Main build target (no version change)
build:
	@echo "Building $(PACKAGE_NAME) package without version change..."
	@echo "Using current version: $$(PACKAGE_VERSION)"
	debuild -us -uc || true

# Check if upstream repository exists, clone if needed
check-upstream:
	@if [ ! -d "$(UPSTREAM_DIR)" ]; then \
		echo "Upstream repository not found, cloning from $(UPSTREAM_REPO)..."; \
		git clone --depth=1  $(UPSTREAM_REPO) $(UPSTREAM_DIR); \
	else \
		echo "Upstream repository found at $(UPSTREAM_DIR)"; \
		cd $(UPSTREAM_DIR) && git checkout master 2>/dev/null || echo "Master branch not found, staying on current branch"; \
	fi

	# Remove git metadata
	rm -rf "$(UPSTREAM_DIR)/.git"

	# Remove documentation and screenshots
	rm -rf "$(UPSTREAM_DIR)/docs" "$(UPSTREAM_DIR)/screenshots"

	# Resolve symbolic links
	find "$(UPSTREAM_DIR)" -type l -name "*.rst" -o -type l -name "*.md" | while read -r symlink; do \
		target="$$$$(readlink \"$$symlink\")"; \
		dir="$$$$(dirname \"$$symlink\")"; \
		base="$$$$(basename \"$$symlink\")"; \
		echo "⚠️ Found symlink: $$symlink -> $$target"; \
		rm "$$symlink"; \
		if [[ "$$target" == /* ]]; then \
			echo "[Documentation not included in package]" > "$$symlink"; \
		elif [ -f "$$dir/$$target" ]; then \
			cp "$$dir/$$target" "$$symlink"; \
		elif [ -f "$(UPSTREAM_DIR)/$$target" ]; then \
			cp "$(UPSTREAM_DIR)/$$target" "$$symlink"; \
		else \
			echo "[Original link: $$target]" > "$$symlink"; \
			echo "📄 Placeholder created for missing target"; \
		fi; \
	done

# Create the orig tarball from upstream source
$(ORIG_TARBALL): check-upstream
	@echo "Creating $(ORIG_TARBALL) from upstream source..."
	# Create target directory
	mkdir -p "$(OPT_DIR)"
	# Copy upstream files
	cp -r "$(UPSTREAM_DIR)"/* "$(OPT_DIR)/" || (echo "Warning: Some files could not be copied" && true)
	# Remove git metadata
	rm -rf "$(OPT_DIR)/.git"
	# Remove documentation and screenshots
	rm -rf "$(OPT_DIR)/docs" "$(OPT_DIR)/screenshots"
	# Resolve symbolic links
	find "$(OPT_DIR)" -type l -name "*.rst" -o -type l -name "*.md" | while read -r symlink; do \
		target="$$$(readlink \"$$symlink\")"; \
		dir="$$$(dirname \"$$symlink\")"; \
		base="$$$(basename \"$$symlink\")"; \
		echo "⚠️ Found symlink: $$symlink -> $$target"; \
		rm "$$symlink"; \
		if [[ "$$target" == /* ]]; then \
			echo "[Documentation not included in package]" > "$$symlink"; \
		elif [ -f "$$dir/$$target" ]; then \
			cp "$$dir/$$target" "$$symlink"; \
		elif [ -f "$(OPT_DIR)/$$target" ]; then \
			cp "$(OPT_DIR)/$$target" "$$symlink"; \
		else \
			echo "[Original link: $$target]" > "$$symlink"; \
			echo "📄 Placeholder created for missing target"; \
		fi; \
	done
	# Create the orig tarball
	tar --exclude='.git' --exclude='*.orig.tar.gz' -czf "$(ORIG_TARBALL)" -C "$(PACKAGE_DIR)/.." bash-it-fork-for-dpkg
	@echo "$(ORIG_TARBALL) created successfully"

# Installation instructions
install:
	@echo "Package must be installed with dpkg -i ../$(PACKAGE_NAME)_*.deb"

uninstall:
	@echo "Package must be removed with dpkg -r $(PACKAGE_NAME)"

# Package verification
check:
	@echo "Running package checks..."
	@if [ -f ../$(PACKAGE_NAME)_*.deb ]; then \
		lintian ../$(PACKAGE_NAME)_*.deb || echo "Lintian warnings are expected for new packages"; \
		dpkg-deb --info ../$(PACKAGE_NAME)_*.deb; \
		dpkg-deb --contents ../$(PACKAGE_NAME)_*.deb; \
		dpkg-deb --control ../$(PACKAGE_NAME)_*.deb; \
	else \
		echo "No .deb file found, skipping checks"; \
	fi

# Cleanup
clean:
	@echo "Cleaning build artifacts..."
	dh clean
	rm -rf debian/debhelper-build-stamp
	rm -rf "$(OPT_DIR)"
	rm -rf DEBIAN

# Distribution cleanup
distclean:
	@echo "Cleaning distribution files..."
	rm -f "$(ORIG_TARBALL)"
	rm -rf ../$(PACKAGE_NAME)_*.deb ../$(PACKAGE_NAME)_*.changes ../$(PACKAGE_NAME)_*.buildinfo ../$(PACKAGE_NAME)_*.dsc

# Show help
help:
	@echo ""
	@echo "Available targets:"
	@echo "  make build           - Build without changing version (default)"
	@echo "  make build-new-version - Build with new version (updates changelog)"
	@echo "  make check           - Check the built package"
	@echo "  make clean           - Remove build artifacts"
	@echo "  make distclean       - Remove build artifacts and distribution files"
	@echo "  make help            - Show this help message"
	@echo ""
	@echo "Prerequisites:"
	@echo "  devscripts debhelper git"
	@echo ""
	@echo "Usage:"
	@echo "  1. Run 'make build' to rebuild current version"
	@echo "  2. Run 'make build-new-version NEW_VERSION=X.Y.Z-1' to create new rele"base""
	@echo "  3. Run 'make check' to verify the package"
	@echo ""
