//
//  PFApi.m
//  PFApi
//
//  Created by Promjai on 10/14/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import "PFApi.h"

@implementation PFApi

- (id) init
{
    if (self = [super init])
    {
        self.manager = [AFHTTPRequestOperationManager manager];
        self.userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

#pragma mark - Reset
- (void)saveReset:(NSString *)reset {
    [self.userDefaults setObject:reset forKey:@"reset"];
}

- (NSString *)getReset {
    return [self.userDefaults objectForKey:@"reset"];
}

#pragma mark - App Language
- (void)saveLanguage:(NSString *)language {
    [self.userDefaults setObject:language forKey:@"language"];
}

- (NSString *)getLanguage {
    return [self.userDefaults objectForKey:@"language"];
}


#pragma mark - Content Language
- (void)saveContentLanguage:(NSString *)contentlanguage {
    [self.userDefaults setObject:contentlanguage forKey:@"contentlanguage"];
}

- (NSString *)getContentLanguage {
    return [self.userDefaults objectForKey:@"contentlanguage"];
}

#pragma mark - Access Token
- (void)saveAccessToken:(NSString *)access_token {
    [self.userDefaults setObject:access_token forKey:@"access_token"];
}

- (NSString *)getAccessToken {
    return [self.userDefaults objectForKey:@"access_token"];
}

#pragma mark - User ID
- (void)saveUserId:(NSString *)user_id {
    [self.userDefaults setObject:user_id forKey:@"user_id"];
}

- (NSString *)getUserId {
    return [self.userDefaults objectForKey:@"user_id"];
}

#pragma mark - Check Log in
- (BOOL)checkLogin {
    if ([self.userDefaults objectForKey:@"user_id"] != nil || [self.userDefaults objectForKey:@"access_token"] != nil) {
        return true;
    } else {
        return false;
    }
}

#pragma mark - Register
- (void)registerWithUsername:(NSString *)username email:(NSString *)email password:(NSString *)password gender:(NSString *)gender birth_date:(NSString *)birth_date {

    self.urlStr = [[NSString alloc] initWithFormat:@"%@register",API_URL];
    NSDictionary *parameters = @{@"username":username , @"password":password , @"email":email ,@"birth_date":birth_date , @"gender":gender};
    [self.manager POST:self.urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self registerWithUsernameResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self registerWithUsernameErrorResponse:[error localizedDescription]];
    }];

}

#pragma mark - Login facebook token
- (void)loginWithFacebookToken:(NSString *)fb_token {

    self.urlStr = [[NSString alloc] initWithFormat:@"%@oauth/facebook",API_URL];
    
    NSDictionary *parameters;
    
    if ([[self.userDefaults objectForKey:@"deviceToken"] isEqualToString:@""] || [[self.userDefaults objectForKey:@"deviceToken"] isEqualToString:@"(null)"]) {
        
        parameters = @{@"facebook_token":fb_token , @"ios_device_token[key]":@"" , @"ios_device_token[type]":@"product"};
        
    } else {
        
        parameters = @{@"facebook_token":fb_token , @"ios_device_token[key]":[self.userDefaults objectForKey:@"deviceToken"] , @"ios_device_token[type]":@"product"};
        
    }
    
    [self.manager POST:self.urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self loginWithFacebookTokenResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self loginWithFacebookTokenErrorResponse:[error localizedDescription]];
    }];
    
}

#pragma mark - Login by Username
- (void)loginWithUsername:(NSString *)username password:(NSString *)password {

    self.urlStr = [[NSString alloc] initWithFormat:@"%@oauth/password",API_URL];
    
    NSDictionary *parameters = @{@"username":username , @"password":password , @"ios_device_token[key]":[self.userDefaults objectForKey:@"deviceToken"] , @"ios_device_token[type]":@"product"};
    
    [self.manager POST:self.urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self loginWithUsernameResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self loginWithUsernameErrorResponse:[error localizedDescription]];
    }];
    
}

#pragma mark - Log out
- (void)logOut {
    [self.userDefaults removeObjectForKey:@"deviceToken"];
    [self.userDefaults removeObjectForKey:@"access_token"];
    [self.userDefaults removeObjectForKey:@"user_id"];
}

#pragma mark - Me
- (void)me {
    self.urlStr = [[NSString alloc] initWithFormat:@"%@user/%@",API_URL,[self getUserId]];
    [self.manager GET:self.urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self meResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self meErrorResponse:[error localizedDescription]];
    }];
}

- (void)getUserSetting {
    self.urlStr = [[NSString alloc] initWithFormat:@"%@user/setting/%@",API_URL,[self getUserId]];
    [self.manager GET:self.urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self getUserSettingResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self getUserSettingErrorResponse:[error localizedDescription]];
    }];
}

- (void)userPictureUpload:(NSString *)picture_base64 {
    NSDictionary *parameters = @{@"picture":picture_base64};
    self.urlStr = [[NSString alloc] initWithFormat:@"%@user/%@",API_URL,[self getUserId]];
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.manager.requestSerializer setValue:nil forHTTPHeaderField:@"X-Auth-Token"];
    [self.manager PUT:self.urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self meResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self meErrorResponse:[error localizedDescription]];
    }];
}

- (void)updateSetting:(NSString *)profilename email:(NSString *)email website:(NSString *)website tel:(NSString *)tel gender:(NSString *)gender birthday:(NSString *)birthday {
    self.urlStr = [[NSString alloc] initWithFormat:@"%@user/%@",API_URL,[self getUserId]];
    NSDictionary *parameters = @{@"display_name":profilename , @"email":email , @"website":website , @"mobile":tel , @"gender":gender , @"birth_date":birthday};
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.manager.requestSerializer setValue:nil forHTTPHeaderField:@"X-Auth-Token"];
    [self.manager PUT:self.urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self getUserSettingResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self getUserSettingErrorResponse:[error localizedDescription]];
    }];
}

- (void)changePassword:(NSString *)old_password new_password:(NSString *)new_password {
    self.urlStr = [[NSString alloc] initWithFormat:@"%@user/change_password/%@",API_URL,[self getUserId]];
    NSDictionary *parameters = @{@"old_password":old_password , @"new_password":new_password  };
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.manager.requestSerializer setValue:nil forHTTPHeaderField:@"X-Auth-Token"];
    [self.manager PUT:self.urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self changPasswordResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self changPasswordErrorResponse:[error localizedDescription]];
    }];
}

- (void)settingNews:(NSString *)status {
    
    self.urlStr = [[NSString alloc] initWithFormat:@"%@user/setting/%@",API_URL,[self getUserId]];
    
    NSDictionary *parameters = @{@"notify_update":status};
    
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.manager.requestSerializer setValue:nil forHTTPHeaderField:@"X-Auth-Token"];
    [self.manager PUT:self.urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self getUserSettingResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self getUserSettingErrorResponse:[error localizedDescription]];
    }];
    
}

- (void)settingMessage:(NSString *)status {
    
    self.urlStr = [[NSString alloc] initWithFormat:@"%@user/setting/%@",API_URL,[self getUserId]];
    
    NSDictionary *parameters = @{@"notify_message":status};
    
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.manager.requestSerializer setValue:nil forHTTPHeaderField:@"X-Auth-Token"];
    [self.manager PUT:self.urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self getUserSettingResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self getUserSettingErrorResponse:[error localizedDescription]];
    }];
    
}

#pragma mark - Feed
- (void)getFeed:(NSString *)limit link:(NSString *)link {
    
    if ([link isEqualToString:@"NO"] ) {
        self.urlStr = [[NSString alloc] initWithFormat:@"%@feed?limit=%@",API_URL,limit];
    } else if ([limit isEqualToString:@"NO"]) {
        self.urlStr = link;
    }
    
    [self.manager GET:self.urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self getFeedResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self getFeedErrorResponse:[error localizedDescription]];
    }];
    
}

- (void)getFeedById:(NSString *)news_id {
    
    self.urlStr = [[NSString alloc] initWithFormat:@"%@feed/%@",API_URL,news_id];
    
    [self.manager GET:self.urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self getFeedByIdResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self getFeedByIdErrorResponse:[error localizedDescription]];
    }];
    
}

- (void)getMessageById:(NSString *)message_id {

    self.urlStr = [[NSString alloc] initWithFormat:@"%@message/%@",API_URL,message_id];
    
    [self.manager GET:self.urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self getMessageByIdResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self getMessageByIdErrorResponse:[error localizedDescription]];
    }];
    
}

- (void)getNotification:(NSString *)limit link:(NSString *)link {

    if ([link isEqualToString:@"NO"] ) {
        self.urlStr = [[NSString alloc] initWithFormat:@"%@user/notify?limit=%@",API_URL,limit];
    } else if ([limit isEqualToString:@"NO"]) {
        self.urlStr = link;
    }
    
    NSDictionary *parameters = @{@"access_token":[self getAccessToken]};
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [self.manager.requestSerializer setValue:nil forHTTPHeaderField:@"X-Auth-Token"];
    [self.manager GET:self.urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self getNotificationResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self getNotificationErrorResponse:[error localizedDescription]];
    }];

}

- (void)deleteNotification:(NSString *)notify_id {
    
    self.urlStr = [[NSString alloc] initWithFormat:@"%@user/notify/%@",API_URL,notify_id];
    
    [self.manager DELETE:self.urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self deleteNotificationResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self deleteNotificationErrorResponse:[error localizedDescription]];
    }];
    
}

- (void)checkBadge {
    
    if ([[self.userDefaults objectForKey:@"access_token"] length] != 0) {
        
        NSString *strUrl = [[NSString alloc] initWithFormat:@"%@user/notify/unopened",API_URL];
        
        self.manager = [AFHTTPRequestOperationManager manager];
        self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
        self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [self.manager.requestSerializer setValue:nil forHTTPHeaderField:@"X-Auth-Token"];
        
        NSDictionary *parameters = @{@"access_token":[self getAccessToken]};
        
        [self.manager  GET:strUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self.delegate PFApi:self checkBadgeResponse:responseObject];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.delegate PFApi:self checkBadgeErrorResponse:[error localizedDescription]];
        }];
    }
    
}

- (void)clearBadge {
    
    self.urlStr = [[NSString alloc] initWithFormat:@"%@user/notify/clear_badge",API_URL];
    
    NSDictionary *parameters = @{@"access_token":[self getAccessToken]};
    
    [self.manager GET:self.urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"clear : %@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

#pragma mark - Promotion
- (void)getPromotion:(NSString *)limit link:(NSString *)link {
    
    if ([link isEqualToString:@"NO"] ) {
        self.urlStr = [[NSString alloc] initWithFormat:@"%@promotion?limit=%@",API_URL,limit];
    } else if ([limit isEqualToString:@"NO"]) {
        self.urlStr = link;
    }
    
    [self.manager GET:self.urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self getPromotionResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self getPromotionErrorResponse:[error localizedDescription]];
    }];
    
}

- (void)getPromotionById:(NSString *)promotion_id {

    self.urlStr = [[NSString alloc] initWithFormat:@"%@promotion/%@",API_URL,promotion_id];
    [self.manager GET:self.urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self getPromotionByIdResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self getPromotionByIdErrorResponse:[error localizedDescription]];
    }];

}

#pragma mark - Catalog
- (void)getCatalog:(NSString *)limit link:(NSString *)link {

    if ([link isEqualToString:@"NO"] ) {
        self.urlStr = [[NSString alloc] initWithFormat:@"%@service?limit=%@",API_URL,limit];
    } else if ([limit isEqualToString:@"NO"]) {
        self.urlStr = link;
    }
    
    [self.manager GET:self.urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self getCatalogResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self getCatalogErrorResponse:[error localizedDescription]];
    }];
    
}

- (void)getCatalogById:(NSString *)catalog_id {

    self.urlStr = [[NSString alloc] initWithFormat:@"%@service/%@/picture",API_URL,catalog_id];
    
    [self.manager GET:self.urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self getCatalogByIdResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self getCatalogByIdErrorResponse:[error localizedDescription]];
    }];
    
}

- (void)getFolderTypeByURL:(NSString *)url {
    
    self.urlStr = [[NSString alloc] initWithFormat:@"%@",url];
    [self.manager GET:self.urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self getFolderTypeByURLResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self getFolderTypeByURLErrorResponse:[error localizedDescription]];
    }];
    
}

#pragma mark - Coupon
- (void)getCoupon:(NSString *)limit link:(NSString *)link {

    if ([link isEqualToString:@"NO"] ) {
        self.urlStr = [[NSString alloc] initWithFormat:@"%@coupon?limit=%@",API_URL,limit];
    } else if ([limit isEqualToString:@"NO"]) {
        self.urlStr = link;
    }
    
    if ([self getAccessToken].length != 0) {
        
        NSDictionary *parameters = @{@"access_token":[self getAccessToken]};
        
        [self.manager GET:self.urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self.delegate PFApi:self getCouponResponse:responseObject];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.delegate PFApi:self getCouponErrorResponse:[error localizedDescription]];
        }];
    
    } else {
        
        [self.manager GET:self.urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self.delegate PFApi:self getCouponResponse:responseObject];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.delegate PFApi:self getCouponErrorResponse:[error localizedDescription]];
        }];
    
    }
    
}

- (void)getCouponById:(NSString *)coupon_id {
    
    self.urlStr = [[NSString alloc] initWithFormat:@"%@coupon/%@",API_URL,coupon_id];

    if ([self getAccessToken].length != 0) {
        
        NSDictionary *parameters = @{@"access_token":[self getAccessToken]};
        
        [self.manager GET:self.urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self.delegate PFApi:self getCouponByIdResponse:responseObject];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.delegate PFApi:self getCouponByIdErrorResponse:[error localizedDescription]];
        }];
        
    } else {
        
        [self.manager GET:self.urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self.delegate PFApi:self getCouponByIdResponse:responseObject];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.delegate PFApi:self getCouponByIdErrorResponse:[error localizedDescription]];
        }];
        
    }
    
}

- (void)getCouponRequest:(NSString *)coupon_id {

    self.urlStr = [[NSString alloc] initWithFormat:@"%@coupon/request/%@",API_URL,coupon_id];
    
    NSDictionary *parameters = @{@"access_token":[self getAccessToken]};
    
    [self.manager POST:self.urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self getCouponRequestResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self getCouponRequestErrorResponse:[error localizedDescription]];
    }];
    
}

#pragma mark - Contact
- (void)getContact {

    self.urlStr = [[NSString alloc] initWithFormat:@"%@contact",API_URL];
    
    [self.manager GET:self.urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self getContactResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self getContactErrorResponse:[error localizedDescription]];
    }];
}

- (void)sendComment:(NSString *)comment {
    
    self.urlStr = [[NSString alloc] initWithFormat:@"%@contact/comment",API_URL];
    
    NSDictionary *parameters = @{ @"message":comment , @"access_token":[self getAccessToken] };
    [self.manager POST:self.urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self sendCommentResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self sendCommentErrorResponse:[error localizedDescription]];
    }];
}

- (void)getContactBranches {
    
    self.urlStr = [[NSString alloc] initWithFormat:@"%@contact/branches",API_URL];
    
    [self.manager GET:self.urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self getContactBranchesResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self getContactBranchesErrorResponse:[error localizedDescription]];
    }];
}

- (void)getBranchTelephone:(NSString *)branch_id {

    self.urlStr = [[NSString alloc] initWithFormat:@"%@contact/branches/%@/tel",API_URL,branch_id];
    
    [self.manager GET:self.urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate PFApi:self getBranchTelephoneResponse:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate PFApi:self getBranchTelephoneErrorResponse:[error localizedDescription]];
    }];

}

@end
