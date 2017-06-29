#include <UIKit/UIKit.h>
#define PLIST_PATH @"/var/mobile/Library/Preferences/com.adeemm.favoriteemojispref.plist"


@interface EMFEmojiPreferences
- (NSArray *)recentEmojis;
+ (id)_recentEmojiStrings;
@end

@interface EMFEmojiPreferencesClient
- (void)writeEmojiDefaults;
- (void)didUseEmoji:(id)arg1 usageMode:(id)arg2 typingName:(id)arg3 ;
- (void)didUseEmoji:(id)arg1 usageMode:(id)arg2 ;
- (void)didUseEmoji:(id)arg1 ;
@end

@interface EMFEmojiToken
- (void)setString:(NSString *)arg1 ;
- (NSString *)string;
@end

@interface UIKeyboardEmojiLayout
- (void)prepareLayout;
@end

@interface UIKeyboardEmojiCategory
+ (id)displayName:(long long)arg1 ;
@end


BOOL runOnce = NO;

inline bool isEnabled()
{
  return [[[NSDictionary dictionaryWithContentsOfFile:PLIST_PATH] valueForKey:@"enabled"] boolValue];
}

inline NSString* getFavs()
{
  return [[NSDictionary dictionaryWithContentsOfFile:PLIST_PATH] valueForKey:@"prefFavs"];
}


%group EmojiFound

%hook EMFEmojiPreferences

- (NSArray *)recentEmojis {
  if(isEnabled())
  {
    NSString *favList = getFavs();
    NSMutableArray *temp = [NSMutableArray array];

    for(int i = 0; i < [favList length]; i++)
    {
      EMFEmojiToken *e = [[%c(EMFEmojiToken) alloc] init];
      NSString *ch = [favList substringWithRange:[favList rangeOfComposedCharacterSequenceAtIndex:i]];
      [e setString:ch];
      EMFEmojiToken *last = [temp lastObject];

      if(![[last string] isEqualToString:ch])
        [temp addObject:e];
    }

    return [temp copy];
  }
  else
    return %orig;
}

+ (id)_recentEmojiStrings {
  if(isEnabled())
  {
    NSString *favList = getFavs();
    NSMutableArray *temp = [NSMutableArray array];

    for(int i = 0; i < [favList length]; i++)
    {
      NSString *ch = [favList substringWithRange:[favList rangeOfComposedCharacterSequenceAtIndex:i]];

      if(![[temp lastObject] isEqualToString:ch])
        [temp addObject:ch];
    }

    return [temp copy];
  }
  else
    return %orig;
}

%end

//nops
%hook EMFEmojiPreferencesClient
- (void)writeEmojiDefaults { if(!isEnabled()) %orig; }
- (void)didUseEmoji:(id)arg1 usageMode:(id)arg2 typingName:(id)arg3 { if(!isEnabled()) %orig; }
- (void)didUseEmoji:(id)arg1 usageMode:(id)arg2 { if(!isEnabled()) %orig; }
- (void)didUseEmoji:(id)arg1 { if(!isEnabled()) %orig; }
%end

%end


%group UI

%hook UIKeyboardEmojiLayout

- (void)prepareLayout {
  if(isEnabled() && !runOnce)
  {
    %init(EmojiFound);
    runOnce = YES;
  }
  %orig;
}

%end


%hook UIKeyboardEmojiCategory

+ (id)displayName:(long long)arg1 {
  if(isEnabled())
  {
    if(arg1 == (long long)0)
      return @"Favorites";
    else
      return %orig;
  }
  else
    return %orig;
}

%end

%end


%ctor {
  %init(UI);
}
