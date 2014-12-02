//
//  PFThaweeyontApi.h
//  thaweeyont
//
//  Created by Promjai on 10/14/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@protocol PFThaweeyontApiDelegate <NSObject>

#pragma mark - Register
- (void)PFThaweeyontApi:(id)sender registerWithUsernameResponse:(NSDictionary *)response;
- (void)PFThaweeyontApi:(id)sender registerWithUsernameErrorResponse:(NSString *)errorResponse;

#pragma mark - Login facebook token
- (void)PFThaweeyontApi:(id)sender loginWithFacebookTokenResponse:(NSDictionary *)response;
- (void)PFThaweeyontApi:(id)sender loginWithFacebookTokenErrorResponse:(NSString *)errorResponse;

#pragma mark - login with username password
- (void)PFThaweeyontApi:(id)sender loginWithUsernameResponse:(NSDictionary *)response;
- (void)PFThaweeyontApi:(id)sender loginWithUsernameErrorResponse:(NSString *)errorResponse;

#pragma mark - User
- (void)PFThaweeyontApi:(id)sender meResponse:(NSDictionary *)response;
- (void)PFThaweeyontApi:(id)sender meErrorResponse:(NSString *)errorResponse;

- (void)PFThaweeyontApi:(id)sender getUserSettingResponse:(NSDictionary *)response;
- (void)PFThaweeyontApi:(id)sender getUserSettingErrorResponse:(NSString *)errorResponse;

- (void)PFThaweeyontApi:(id)sender changPasswordResponse:(NSDictionary *)response;
- (void)PFThaweeyontApi:(id)sender changPasswordErrorResponse:(NSString *)errorResponse;

#pragma mark - Overview Protocal Delegate
- (void)PFThaweeyontApi:(id)sender getFeedResponse:(NSDictionary *)response;
- (void)PFThaweeyontApi:(id)sender getFeedErrorResponse:(NSString *)errorResponse;

- (void)PFThaweeyontApi:(id)sender getFeedByIdResponse:(NSDictionary *)response;
- (void)PFThaweeyontApi:(id)sender getFeedByIdErrorResponse:(NSString *)errorResponse;

- (void)PFThaweeyontApi:(id)sender getMessageByIdResponse:(NSDictionary *)response;
- (void)PFThaweeyontApi:(id)sender getMessageByIdErrorResponse:(NSString *)errorResponse;

- (void)PFThaweeyontApi:(id)sender getNotificationResponse:(NSDictionary *)response;
- (void)PFThaweeyontApi:(id)sender getNotificationErrorResponse:(NSString *)errorResponse;

- (void)PFThaweeyontApi:(id)sender checkBadgeResponse:(NSDictionary *)response;
- (void)PFThaweeyontApi:(id)sender checkBadgeErrorResponse:(NSString *)errorResponse;

#pragma mark - Promotion Protocal Delegate
- (void)PFThaweeyontApi:(id)sender getPromotionResponse:(NSDictionary *)response;
- (void)PFThaweeyontApi:(id)sender getPromotionErrorResponse:(NSString *)errorResponse;

- (void)PFThaweeyontApi:(id)sender getPromotionByIdResponse:(NSDictionary *)response;
- (void)PFThaweeyontApi:(id)sender getPromotionByIdErrorResponse:(NSString *)errorResponse;

#pragma mark - Catalog Protocal Delegate
- (void)PFThaweeyontApi:(id)sender getCatalogResponse:(NSDictionary *)response;
- (void)PFThaweeyontApi:(id)sender getCatalogErrorResponse:(NSString *)errorResponse;

- (void)PFThaweeyontApi:(id)sender getCatalogByIdResponse:(NSDictionary *)response;
- (void)PFThaweeyontApi:(id)sender getCatalogByIdErrorResponse:(NSString *)errorResponse;

- (void)PFThaweeyontApi:(id)sender getFolderTypeByURLResponse:(NSDictionary *)response;
- (void)PFThaweeyontApi:(id)sender getFolderTypeByURLErrorResponse:(NSString *)errorResponse;

#pragma mark - Coupon Protocal Delegate
- (void)PFThaweeyontApi:(id)sender getCouponResponse:(NSDictionary *)response;
- (void)PFThaweeyontApi:(id)sender getCouponErrorResponse:(NSString *)errorResponse;

- (void)PFThaweeyontApi:(id)sender getCouponByIdResponse:(NSDictionary *)response;
- (void)PFThaweeyontApi:(id)sender getCouponByIdErrorResponse:(NSString *)errorResponse;

- (void)PFThaweeyontApi:(id)sender getCouponRequestResponse:(NSDictionary *)response;
- (void)PFThaweeyontApi:(id)sender getCouponRequestErrorResponse:(NSString *)errorResponse;

#pragma mark - Contact Protocal Delegate
- (void)PFThaweeyontApi:(id)sender getContactResponse:(NSDictionary *)response;
- (void)PFThaweeyontApi:(id)sender getContactErrorResponse:(NSString *)errorResponse;

- (void)PFThaweeyontApi:(id)sender sendCommentResponse:(NSDictionary *)response;
- (void)PFThaweeyontApi:(id)sender sendCommentErrorResponse:(NSString *)errorResponse;

- (void)PFThaweeyontApi:(id)sender getContactBranchesResponse:(NSDictionary *)response;
- (void)PFThaweeyontApi:(id)sender getContactBranchesErrorResponse:(NSString *)errorResponse;

- (void)PFThaweeyontApi:(id)sender getBranchTelephoneResponse:(NSDictionary *)response;
- (void)PFThaweeyontApi:(id)sender getBranchTelephoneErrorResponse:(NSString *)errorResponse;

@end

@interface PFThaweeyontApi : NSObject

#pragma mark - Property
@property (assign, nonatomic) id delegate;
@property AFHTTPRequestOperationManager *manager;
@property NSUserDefaults *userDefaults;
@property NSString *urlStr;

#pragma mark - Reset App
- (void)saveReset:(NSString *)reset;
- (NSString *)getReset;

#pragma mark - App Language
- (void)saveLanguage:(NSString *)language;
- (NSString *)getLanguage;

#pragma mark - Content Language
- (void)saveContentLanguage:(NSString *)contentlanguage;
- (NSString *)getContentLanguage;

#pragma mark - User_id
- (void)saveUserId:(NSString *)user_id;
- (void)saveAccessToken:(NSString *)access_token;

- (NSString *)getUserId;
- (NSString *)getAccessToken;

#pragma mark - Check Login
- (BOOL)checkLogin;

#pragma mark - Register
- (void)registerWithUsername:(NSString *)username email:(NSString *)email password:(NSString *)password gender:(NSString *)gender birth_date:(NSString *)birth_date;

#pragma mark - Login facebook token
- (void)loginWithFacebookToken:(NSString *)fb_token;

#pragma mark - Login by Username
- (void)loginWithUsername:(NSString *)username password:(NSString *)passeord;

#pragma mark - Log out
- (void)logOut;

#pragma mark - User
- (void)me;
- (void)getUserSetting;
- (void)userPictureUpload:(NSString *)picture_base64;
- (void)updateSetting:(NSString *)profilename email:(NSString *)email website:(NSString *)website tel:(NSString *)tel gender:(NSString *)gender birthday:(NSString *)birthday;
- (void)changePassword:(NSString *)old_password new_password:(NSString *)new_password;

- (void)settingNews:(NSString *)status;
- (void)settingMessage:(NSString *)status;

#pragma mark - Feed
- (void)getFeed:(NSString *)limit link:(NSString *)link;
- (void)getFeedById:(NSString *)news_id;

- (void)getMessageById:(NSString *)message_id;

- (void)getNotification:(NSString *)limit link:(NSString *)link;
- (void)checkBadge;
- (void)clearBadge;

#pragma mark - Promotion
- (void)getPromotion:(NSString *)limit link:(NSString *)link;
- (void)getPromotionById:(NSString *)promotion_id;

#pragma mark - Catalog
- (void)getCatalog:(NSString *)limit link:(NSString *)link;
- (void)getCatalogById:(NSString *)catalog_id;
- (void)getFolderTypeByURL:(NSString *)url;

#pragma mark - Coupon
- (void)getCoupon:(NSString *)limit link:(NSString *)link;
- (void)getCouponById:(NSString *)coupon_id;
- (void)getCouponRequest:(NSString *)coupon_id;

#pragma mark - Contact
- (void)getContact;
- (void)sendComment:(NSString *)comment;
- (void)getContactBranches;
- (void)getBranchTelephone:(NSString *)branch_id;

@end
