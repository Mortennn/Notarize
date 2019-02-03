TOOL_NAME = Notarize
export EXECUTABLE_NAME = notarize
VERSION = 1.0.0

PREFIX = /usr/local
INSTALL_PATH = $(PREFIX)/bin/$(EXECUTABLE_NAME)
CURRENT_PATH = $(PWD)
REPO = https://github.com/Mortennn/$(TOOL_NAME)
RELEASE_TAR = $(REPO)/archive/$(VERSION).tar.gz
SHA = $(shell curl -L -s $(RELEASE_TAR) | shasum -a 256 | sed 's/ .*//')

.PHONY: install build uninstall format_code update_brew release
	
xcode:
	@osascript -e 'quit app "Xcode"'
	@swift package generate-xcodeproj --xcconfig-overrides package.xcconfig
	@open Notarize.xcodeproj

release:
	@swift build -c release -Xswiftc "-target" -Xswiftc "x86_64-apple-macosx10.13" --disable-sandbox -Xswiftc -static-stdlib
	@cp -f .build/release/Notarize ~/Desktop/Notarize

install: build
	mkdir -p $(PREFIX)/bin
	cp -f .build/release/$(EXECUTABLE_NAME) $(INSTALL_PATH)

build:
	swift build -c release -Xswiftc "-target" -Xswiftc "x86_64-apple-macosx10.13" --disable-sandbox -Xswiftc -static-stdlib

uninstall:
	rm -f $(INSTALL_PATH)

format_code:
	swiftformat .

publish: archive upload_to_github
	echo "published $(VERSION)"

archive: build
	./scripts/archive.sh

upload_to_github:
	ghr \
	-t github.token \        # Set Github API Token
	-u Mortennn \     # Set Github username
	-r Notarize \         # Set repository name
	-n $(VERSION) \        # Set release title
	-delete \         # Delete release and its git tag in advance if it exists (same as -recreate)
	-replace \          # Replace artifacts if it is already uploaded
	-draft          # Release as draft (Unpublish)
