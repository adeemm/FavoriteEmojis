include $(THEOS)/makefiles/common.mk

TWEAK_NAME = FavoriteEmojis
FavoriteEmojis_FILES = Tweak.xm
FavoriteEmojis_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += favoriteemojispref
include $(THEOS_MAKE_PATH)/aggregate.mk
