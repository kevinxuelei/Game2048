//
//  RootViewController.h
//  Game2048
//
//  Created by lanou3g on 15/8/16.
//  Copyright (c) 2015年 xhf06. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController <UIAlertViewDelegate>

@property(retain,nonatomic) NSMutableArray *array;
@property(retain,nonatomic) UIView *gameView;
@property NSInteger flag;
@property NSInteger n;
@property NSInteger sum;


@end
