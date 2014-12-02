//
//  PFCustomBadge.h
//  PFTabbarContoller
//
//  Created by MRG on 5/19/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFCustomBadge : UIView {

	BOOL badgeFrame;
	BOOL badgeShining;
	CGFloat badgeCornerRoundness;
	CGFloat badgeScaleFactor;
}
@property(nonatomic,weak) NSString *badgeText;
@property(nonatomic,weak) UIColor *badgeTextColor;
@property(nonatomic,weak) UIColor *badgeInsetColor;
@property(nonatomic,weak) UIColor *badgeFrameColor;

@property(nonatomic,readwrite) BOOL badgeFrame;
@property(nonatomic,readwrite) BOOL badgeShining;

@property(nonatomic,readwrite) CGFloat badgeCornerRoundness;
@property(nonatomic,readwrite) CGFloat badgeScaleFactor;

+ (PFCustomBadge *) customBadgeWithString:(NSString *)badgeString;
+ (PFCustomBadge *) customBadgeWithString:(NSString *)badgeString withStringColor:(UIColor*)stringColor withInsetColor:(UIColor*)insetColor withBadgeFrame:(BOOL)badgeFrameYesNo withBadgeFrameColor:(UIColor*)frameColor withScale:(CGFloat)scale withShining:(BOOL)shining;
- (void) autoBadgeSizeWithString:(NSString *)badgeString;
@end
