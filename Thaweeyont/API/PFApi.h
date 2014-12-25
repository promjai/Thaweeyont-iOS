//
//  PFApi.h
//  PFApi
//
//  Created by Promjai on 10/14/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@protocol PFApiDelegate <NSObject>

#pragma mark - Register
- (void)PFApi:(id)sender registerWithUsernameResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender registerWithUsernameErrorResponse:(NSString *)errorResponse;

#pragma mark - Login facebook token
- (void)PFApi:(id)sender loginWithFacebookTokenResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender loginWithFacebookTokenErrorResponse:(NSString *)errorResponse;

#pragma mark - login with username password
- (void)PFApi:(id)sender loginWithUsernameResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender loginWithUsernameErrorResponse:(NSString *)errorResponse;

#pragma mark - User
- (void)PFApi:(id)sender meResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender meErrorResponse:(NSString *)errorResponse;

- (void)PFApi:(id)sender getUserSettingResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender getUserSettingErrorResponse:(NSString *)errorResponse;

- (void)PFApi:(id)sender changPasswordResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender changPasswordErrorResponse:(NSString *)errorResponse;

#pragma mark - Overview Protocal Delegate
- (void)PFApi:(id)sender getFeedResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender getFeedErrorResponse:(NSString *)errorResponse;

- (void)PFApi:(id)sender getFeedByIdResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender getFeedByIdErrorResponse:(NSString *)errorResponse;

- (void)PFApi:(id)sender getMessageByIdResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender getMessageByIdErrorResponse:(NSString *)errorResponse;

- (void)PFApi:(id)sender getNotificationResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender getNotificationErrorResponse:(NSString *)errorResponse;

- (void)PFApi:(id)sender deleteNotificationResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender deleteNotificationErrorResponse:(NSString *)errorResponse;

- (void)PFApi:(id)sender checkBadgeResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender checkBadgeErrorResponse:(NSString *)errorResponse;

#pragma mark - Promotion Protocal Delegate
- (void)PFApi:(id)sender getPromotionResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender getPromotionErrorResponse:(NSString *)errorResponse;

- (void)PFApi:(id)sender getPromotionByIdResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender getPromotionByIdErrorResponse:(NSString *)errorResponse;

#pragma mark - Catalog Protocal Delegate
- (void)PFApi:(id)sender getCatalogResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender getCatalogErrorResponse:(NSString *)errorResponse;

- (void)PFApi:(id)sender getCatalogByIdResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender getCatalogByIdErrorResponse:(NSString *)errorResponse;

- (void)PFApi:(id)sender getFolderTypeByURLResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender getFolderTypeByURLErrorResponse:(NSString *)errorResponse;

#pragma mark - Coupon Protocal Delegate
- (void)PFApi:(id)sender getCouponResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender getCouponErrorResponse:(NSString *)errorResponse;

- (void)PFApi:(id)sender getCouponByIdResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender getCouponByIdErrorResponse:(NSString *)errorResponse;

- (void)PFApi:(id)sender getCouponRequestResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender getCouponRequestErrorResponse:(NSString *)errorResponse;

#pragma mark - Contact Protocal Delegate
- (void)PFApi:(id)sender getContactResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender getContactErrorResponse:(NSString *)errorResponse;

- (void)PFApi:(id)sender sendCommentResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender sendCommentErrorResponse:(NSString *)errorResponse;

- (void)PFApi:(id)sender getContactBranchesResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender getContactBranchesErrorResponse:(NSString *)errorResponse;

- (void)PFApi:(id)sender getBranchTelephoneResponse:(NSDictionary *)response;
- (void)PFApi:(id)sender getBranchTelephoneErrorResponse:(NSString *)errorResponse;

@end

@interface PFApi : NSObject

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
- (void)deleteNotification:(NSString *)notify_id;
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
