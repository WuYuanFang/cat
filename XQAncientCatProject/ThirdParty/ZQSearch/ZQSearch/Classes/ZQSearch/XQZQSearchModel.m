//
//  XQZQSearchModel.m
//  Pods-ZQSearchController
//
//  Created by WXQ on 2019/7/30.
//

#import "XQZQSearchModel.h"

@implementation XQZQSearchModel



- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"%s, %@, %@", __func__, value, key);
}

- (NSString *)xq_identifier {
    if (!_xq_identifier) {
        _xq_identifier = [NSUUID UUID].UUIDString;
    }
    return _xq_identifier;
}

- (NSDictionary *)xq_getDic {
    NSDictionary *dic = @{
                          @"title": self.title ? self.title : @"",
                          @"editType": @(self.editType),
                          @"iconUrl": self.iconUrl ? self.iconUrl : @"",
                          @"desc": self.desc ? self.desc : @"",
                          @"xq_identifier": self.xq_identifier,
                          @"xq_dic": self.xq_dic,
                          };
    return dic;
}

#pragma mark - wxq 增加存储和清除本地数据

+ (NSArray <XQZQSearchModel *> *)xq_getHistoryList {
    NSArray *arr = [[NSUserDefaults standardUserDefaults] arrayForKey:XQ_Def_History_Key];
    if (!arr) {
        return @[];
    }
    
    NSMutableArray *muArr = [NSMutableArray array];
    for (NSDictionary *item in arr) {
        XQZQSearchModel *model = [XQZQSearchModel new];
        [model setValuesForKeysWithDictionary:item];
        [muArr addObject:model];
    }
    
    return muArr;
}

+ (void)xq_setHistoryListWithModelArr:(NSArray <XQZQSearchModel *> *)modelArr {
    NSMutableArray *muArr = [NSMutableArray array];
    for (XQZQSearchModel * model in modelArr) {
        NSDictionary *dic = [model xq_getDic];
        [muArr addObject:dic];
    }
    [[NSUserDefaults standardUserDefaults] setObject:muArr forKey:XQ_Def_History_Key];
}

+ (void)xq_addHistoryWithModel:(XQZQSearchModel *)model {
    NSDictionary *dic = [model xq_getDic];
    
    NSArray *arr = [[NSUserDefaults standardUserDefaults] arrayForKey:XQ_Def_History_Key];
    NSMutableArray *muArr = nil;
    if (!arr) {
        muArr = [NSMutableArray array];
    }else {
        muArr = arr.mutableCopy;
    }
    
    [muArr addObject:dic];
    [[NSUserDefaults standardUserDefaults] setObject:muArr forKey:XQ_Def_History_Key];
}

+ (void)xq_removeAllHistory {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:XQ_Def_History_Key];
}

- (NSDictionary *)xq_dic {
    if (!_xq_dic) {
        _xq_dic = [NSDictionary dictionary];
    }
    return _xq_dic;
}

@end
