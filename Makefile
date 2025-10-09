EXTENSION_ZIP := ideapad-controls@woomymy.protonmail.com.shell-extension.zip
TMPFILES_CONF := 99-ideapad.conf

all: extension_zip
extension_zip: $(EXTENSION_ZIP)

subprojects:
	git submodule update --resursive

template.ui: subprojects template.blp
	./subprojects/blueprint-compiler/blueprint-compiler.py compile template.blp > template.ui

$(EXTENSION_ZIP): extension.js prefs.js metadata.json template.ui optionsUtils.js menus.js icons/ LICENSE.md po/
	gnome-extensions pack ./ \
		--extra-source=template.ui \
		--extra-source=optionsUtils.js \
		--extra-source=menus.js \
		--extra-source=icons/ \
		--extra-source=LICENSE.md \
		--podir=po \
		--force

translations:
	xgettext \
		--files-from=po/POTFILES \
		--output=po/ideapad-controls.pot \
		--from-code=UTF-8 \
		--add-comments \
		--keyword=_ \
		--keyword=C_:1c,2

install: $(EXTENSION_ZIP)
	@echo "Installing extension"
	gnome-extensions install --force $(EXTENSION_ZIP)
	@echo "Extension installed"

tmpfiles-install: $(TMPFILES_CONF)
	@echo "Installing tmpfiles.d configuration"
	cp -v $(TMPFILES_CONF) /etc/tmpfiles.d/$(TMPFILES_CONF)
	@echo "Installed tmpfiles.d configuration. Reboot or run 'systemd-tmpfiles --create' to make it effective"

clean:
	rm -f $(EXTENSION_ZIP) template.ui

