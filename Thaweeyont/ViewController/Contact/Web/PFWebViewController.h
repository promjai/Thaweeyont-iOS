//
//  PFWebViewController.h
//  Thaweeyont
//
//  Created by Promjai on 10/24/2557 BE.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PFWebViewControllerDelegate <NSObject>

- (void)PFWebViewControllerBack;

@end

@interface PFWebViewController : UIViewController <UIWebViewDelegate>

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property NSString *url;

@property (strong, nonatomic) IBOutlet UIView *waitView;

@end
