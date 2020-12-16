//
//  ZQSearchViewController.h
//  ZQSearchController
//
//  Created by zzq on 2018/9/20.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZQSearchConst.h"

typedef NS_ENUM(NSUInteger, ZQSearchBarStyle) {
    ZQSearchBarStyleNone,
    ZQSearchBarStyleCannel,
    ZQSearchBarStyleBack,
};

typedef NS_ENUM(NSUInteger, ZQSearchState) {
    ZQSearchStateNormal,
    ZQSearchStateEditing,
    ZQSearchStateResult,
};

@class ZQSearchViewController;

@protocol ZQSearchViewDelegate<NSObject>

@required

/**
 具体选择了某个内容(历史记录)

 @param data 选择的数据
 */
- (void)searchViewController:(ZQSearchViewController *)searchViewController resultData:(XQZQSearchModel *)data;

/**
 wxq 搜索框文字在变化

 @param keyString 输入的文字
 @param block 返回搜索到的数据, 给视图显示
 */
- (void)searchViewController:(ZQSearchViewController *)searchViewController refreshWithKeyString:(NSString *)keyString dataBlock:(void(^)(NSArray <XQZQSearchModel *> *dataArr))block;

/**
 wxq 点击键盘的搜索
 */
- (void)searchViewController:(ZQSearchViewController *)searchViewController tapSearchWithKeyString:(NSString *)keyString dataBlock:(void(^)(NSArray <XQZQSearchModel *> *dataArr))block;

/// 选择了返回
- (void)searchViewControllerDidSelectCancel:(ZQSearchViewController *)searchViewController;

@end


@interface ZQSearchViewController : UIViewController

- (instancetype)initSearchViewWithHotDatas:(NSArray <XQZQSearchModel *> *)hotList;

/**
 wxq 代理
 */
@property (nonatomic, weak) id<ZQSearchViewDelegate> delegate;

    
/**
 wxq default is NO, 如果设置为YES，将不显示模糊匹配列表。可以不实现searchEditViewRefreshWithDataBlock和searchConfirmResultWithKeyString这两个代理。
 */
@property (nonatomic, assign) BOOL closeFuzzyTable;

/**
 wxq 搜索栏文字
 */
@property (nonatomic, copy) NSString *placeholder;

/**
 设置搜索栏文字
 */
- (void)xq_setText:(NSString *)text;

@end
