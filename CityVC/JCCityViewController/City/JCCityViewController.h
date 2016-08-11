//
//  JCCityViewController.h
//  JCCityViewController
//
//  Created by wang on 16/8/10.
//  Copyright © 2016年 wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JCCityBlockCallBack)(NSString *cityName);

@interface JCCityViewController : UIViewController

@property(nonatomic,copy) JCCityBlockCallBack callBlock;

@end
