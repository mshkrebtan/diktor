.DEFAULT_GOAL = usage

define USAGE_MSG
Please choose one of the following targets:
xkb xkb-restore
endef

XKB_CONFIG_ROOT ?= /usr/share/X11/xkb

.PHONY: usage xkb xkb-restore

usage:
	$(info $(USAGE_MSG))

xkb : $(XKB_CONFIG_ROOT)/symbols/ru+diktor
	ln \
		--symbolic \
		--force \
		$< \
		$(XKB_CONFIG_ROOT)/symbols/ru
	patch \
		--forward \
		--reject-file=- \
		--directory=/ \
		--strip=0 \
		< xkb/rules/evdev.xml.diff

$(XKB_CONFIG_ROOT)/symbols/ru+diktor: $(XKB_CONFIG_ROOT)/symbols/ru
	mv ${XKB_CONFIG_ROOT}/symbols/ru $@
	cat xkb/symbols/ru >> $@

# TODO: Add support for other package managers
xkb-restore:
	zypper install \
		--force \
		--no-confirm \
		xkeyboard-config
	rm $(XKB_CONFIG_ROOT)/symbols/ru+diktor
