include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = FavoriteEmojisPref
FavoriteEmojisPref_FILES = FEPRootListController.m
FavoriteEmojisPref_INSTALL_PATH = /Library/PreferenceBundles
FavoriteEmojisPref_FRAMEWORKS = UIKit
FavoriteEmojisPref_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/FavoriteEmojisPref.plist$(ECHO_END)
