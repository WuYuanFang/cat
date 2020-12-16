//
//  XQZQSearchModel.h
//  Pods-ZQSearchController
//
//  Created by WXQ on 2019/7/30.
//

#import <Foundation/Foundation.h>

/**
 wxq 搜索出来的类型
 
 - SearchEditTypeFuzzy: 只有内容
 - SearchEditTypeConfirm: 有图片和详情描述
 */
typedef NS_ENUM(NSUInteger, SearchEditType) {
    SearchEditTypeFuzzy = 0,
    SearchEditTypeConfirm,
};

/**
 wxq 历史记录存储key
 */
#define XQ_Def_History_Key @"XQ_ZQ_Def_History_Key"

NS_ASSUME_NONNULL_BEGIN

@interface XQZQSearchModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) SearchEditType editType;
@property (nonatomic, strong) UIImage *image;//优先加载image图片
@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic, copy) NSString *desc;

/**
 wxq 唯一标识符, 方便外面标记东西
 
 如外面不传, 会默认生成一个uuid
 */
@property (nonatomic, copy) NSString *xq_identifier;

/**
 wxq 外面可以直接存储一个对象进来给里面, 这样更加方便判断出来是什么
 但是历史记录, 这个我并不会去存储, 所以历史记录这个是为空的
 */
@property (nonatomic, strong) id xq_obj;

/**
 wxq 这个是会报错到本地的, 就是搜索历史
 可以把你想要报错的数据, 转为 dic, 然后传进来. 这样下次点击历史记录, 就可以取这个值了
 */
@property (nonatomic, copy) NSDictionary *xq_dic;

/**
 获取历史记录
 */
+ (NSArray <XQZQSearchModel *> *)xq_getHistoryList;

/**
 添加历史记录
 */
+ (void)xq_addHistoryWithModel:(XQZQSearchModel *)model;

/**
 直接覆盖历史记录
 */
+ (void)xq_setHistoryListWithModelArr:(NSArray <XQZQSearchModel *> *)modelArr;

/**
 清除记录
 */
+ (void)xq_removeAllHistory;

@end

NS_ASSUME_NONNULL_END
