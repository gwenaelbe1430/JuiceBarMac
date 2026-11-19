APP_NAME := JuiceBar
BUNDLE   := $(APP_NAME).app
SWIFTC   := $(shell if [ -x /Library/Developer/CommandLineTools/usr/bin/swiftc ]; then echo /Library/Developer/CommandLineTools/usr/bin/swiftc; else echo swiftc; fi)
SDK_FLAG := $(shell if [ -d /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk ]; then echo "-sdk /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk"; fi)

.PHONY: all install clean preview run

all: $(BUNDLE)

$(BUNDLE): src/main.swift Info.plist
	mkdir -p $(BUNDLE)/Contents/MacOS $(BUNDLE)/Contents/Resources
	cp Info.plist $(BUNDLE)/Contents/Info.plist
	$(SWIFTC) $(SDK_FLAG) -O src/main.swift -o $(BUNDLE)/Contents/MacOS/$(APP_NAME)
	codesign --force --deep --sign - $(BUNDLE)

install: $(BUNDLE)
	rm -rf /Applications/$(BUNDLE)
	cp -R $(BUNDLE) /Applications/$(BUNDLE)
	@echo "Installed to /Applications/$(BUNDLE)"

preview: $(BUNDLE)
	./$(BUNDLE)/Contents/MacOS/$(APP_NAME) --preview docs/preview.png

run: $(BUNDLE)
	open $(BUNDLE)

clean:
	rm -rf $(BUNDLE)
