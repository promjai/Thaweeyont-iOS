//
//  PFCommentViewController.h
//  thaweeyont
//
//  Created by Pariwat on 11/1/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PFApi.h"

@protocol PFCommentViewControllerDelegate <NSObject>

- (void) PFCommentViewControllerBack;

@end

@interface PFCommentViewController : UIViewController

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFApi *Api;

@property (strong, nonatomic) IBOutlet UITextView *comment;

@end
