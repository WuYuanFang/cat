//
//  JFSearchView.h
//  JFFootball
//
//  Created by 张志峰 on 2016/11/24.
//  Copyright © 2016年 zhifenx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XQ_JFAreaDataModel.h"

@protocol JFSearchViewDelegate <NSObject>

- (void)searchResults:(XQ_JFAreaDataModel *)dic;
- (void)touchViewToExit;

@end

/// WXQ_ UIView 改为 UITableViewController
@interface JFSearchView : UITableViewController

/** 搜索结果*/
@property (nonatomic, strong) NSMutableArray <XQ_JFAreaDataModel *> *resultMutableArray;
@property (nonatomic, weak) id<JFSearchViewDelegate> delegate;
@end
