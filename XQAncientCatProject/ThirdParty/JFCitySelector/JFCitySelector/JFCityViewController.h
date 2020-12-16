//
//  JFCityViewController.h
//  JFFootball
//
//  Created by 张志峰 on 2016/11/21.
//  Copyright © 2016年 zhifenx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XQ_JFAreaDataModel.h"

@class JFCityViewController;

@protocol JFCityViewControllerDelegate <NSObject>

/**
 wxq_改动了一下名称, 规范一点
 增加多了一个info接口
 */
@optional
- (void)cityViewControllercity:(JFCityViewController *)cityViewController cityName:(NSString *)cityName;
- (void)cityViewControllercity:(JFCityViewController *)cityViewController cityInfo:(XQ_JFAreaDataModel *)cityInfo;

@end

@interface JFCityViewController : UIViewController

@property (nonatomic, weak) id<JFCityViewControllerDelegate> delegate;

@end
