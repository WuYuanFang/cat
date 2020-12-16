//
//  XQ_JFAreaInfoManager.m
//  FMDB
//
//  Created by WXQ on 2019/11/7.
//

#import "XQ_JFAreaInfoManager.h"

@interface XQ_JFAreaInfoManager ()

/** <#note#> */
@property (nonatomic, copy) NSArray <XQ_JFProvinceModel *> *provinceModelArr;

@end

@implementation XQ_JFAreaInfoManager

static XQ_JFAreaInfoManager *manager_ = nil;

+ (XQ_JFAreaInfoManager *)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager_ = [[self alloc] init];
        [manager_ initJsonData];
    });
    return manager_;
}

- (void)initJsonData {
    // copy"area.sqlite"到Documents中
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [[NSBundle bundleForClass:[XQ_JFAreaInfoManager class]] pathForResource:@"pca-code" ofType:@"json"];
    NSArray *arr = [NSArray arrayWithContentsOfFile:path];
    NSLog(@"%@", arr);
    self.provinceModelArr = [NSArray yy_modelArrayWithClass:[XQ_JFProvinceModel class] json:[NSArray arrayWithContentsOfFile:path]];
    NSLog(@"model: %@", self.provinceModelArr);
}

- (void)xq_queryAll:(void (^)(NSMutableArray <NSDictionary *> *dataArray))cityData {
    
}

- (NSMutableArray <NSDictionary *> *)xq_queryCityInfoWithCityName:(NSString *)cityName {
    return nil;
}


/// 所有市区的名称
- (void)cityData:(void (^)(NSMutableArray *dataArray))cityData {
    
}

/// 获取当前市的city_number
- (void)cityNumberWithCity:(NSString *)city cityNumber:(void (^)(NSString *cityNumber))cityNumber {
    
}

/// 所有区县的名称
- (void)areaData:(NSString *)cityNumber areaData:(void (^)(NSMutableArray *areaData))areaData {
    
}

/// 根据city_number获取当前城市
- (void)currentCity:(NSString *)cityNumber currentCityName:(void (^)(NSString *name))currentCityName {
    
}

- (void)searchCityData:(NSString *)searchObject result:(void (^)(NSMutableArray *result))result {
    
}

@end
