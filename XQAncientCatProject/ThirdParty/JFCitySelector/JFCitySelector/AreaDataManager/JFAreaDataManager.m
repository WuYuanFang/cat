//
//  JFAreaDataManager.m
//  JFFootball
//
//  Created by 张志峰 on 2016/11/18.
//  Copyright © 2016年 zhifenx. All rights reserved.
//

#import "JFAreaDataManager.h"

#import <FMDB/FMDB.h>

@interface JFAreaDataManager ()

@property (nonatomic, strong) FMDatabase *db;

@end

@implementation JFAreaDataManager

static JFAreaDataManager *manager = nil;
+ (JFAreaDataManager *)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)areaSqliteDBData {
    if (self.db) {
        return;
    }
    
    // copy"area.sqlite"到Documents中
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths.firstObject;
    
    // wxq_ 改了一下路径, 为了能用新的数据库
    NSString *txtPath = [documentsDirectory stringByAppendingPathComponent:@"JFCitySelector/shop_area.sqlite"];
    
    // 复制过去
    if([fileManager fileExistsAtPath:txtPath] == NO) {
        
        [fileManager createDirectoryAtPath:[documentsDirectory stringByAppendingPathComponent:@"JFCitySelector"] withIntermediateDirectories:YES attributes:nil error:&error];
        
        if (error) {
            NSLog(@"创建文件夹失败: %@", error);
        }
        
        // wxq_因为封装成库了, shop_area.sqlite 自然也在库中, 这里取的bundle, 就应该是库中的
        NSString *resourcePath = [[NSBundle bundleForClass:[JFAreaDataManager class]] pathForResource:@"shop_area" ofType:@"sqlite"];
        [fileManager copyItemAtPath:resourcePath toPath:txtPath error:&error];
        
        if (error) {
            NSLog(@"复制文件失败: %@", error);
        }
    }
    
    // 新建数据库并打开
    FMDatabase *db = [FMDatabase databaseWithPath:txtPath];
    self.db = db;
    BOOL success = [db open];
    if (success) {
        // 数据库创建成功!
        NSLog(@"数据库打开成功!");
        NSString *sqlStr = @"CREATE TABLE IF NOT EXISTS shop_area (area_number INTEGER ,area_name TEXT ,city_number INTEGER ,city_name TEXT ,province_number INTEGER ,province_name TEXT);";
        BOOL successT = [self.db executeUpdate:sqlStr];
        if (successT) {
            // 创建表成功!
            NSLog(@"创建表成功!");
        }else{
            // 创建表失败!
            NSLog(@"创建表失败!");
            [self.db close];
        }
    }else{
        // 数据库创建失败!
        NSLog(@"数据库创建失败!");
        [self.db close];
    }
}

- (void)xq_queryAll:(void (^)(NSMutableArray <XQ_JFAreaDataModel *> *dataArray))cityData {
    NSMutableArray <XQ_JFAreaDataModel *> *resultArray1 = [[NSMutableArray alloc] init];
    FMResultSet *result1 = [self.db executeQuery:@"SELECT * FROM shop_area;"];
    while ([result1 next]) {
        XQ_JFAreaDataModel *model = [XQ_JFAreaDataModel yy_modelWithDictionary:[result1 resultDictionary]];
        [resultArray1 addObject:model];
    }
    if (cityData) {
        cityData(resultArray1);
    }
}

- (NSMutableArray <XQ_JFAreaDataModel *> *)xq_queryCityInfoWithCityName:(NSString *)cityName {
    
    // 查市名称
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM shop_area where city_name='%@';", cityName];
    FMResultSet *result1 = [self.db executeQuery:query];
    
    NSMutableArray *resultArray1 = [[NSMutableArray alloc] init];
    while ([result1 next]) {
        [resultArray1 addObject:[XQ_JFAreaDataModel yy_modelWithDictionary:[result1 resultDictionary]]];
    }
    
    // 查区名称...因为有些市就等于区
    if (resultArray1.count == 0) {
        NSString *query = [NSString stringWithFormat:@"SELECT * FROM shop_area where province_name='%@';", cityName];
        FMResultSet *result1 = [self.db executeQuery:query];
        while ([result1 next]) {
            [resultArray1 addObject:[XQ_JFAreaDataModel yy_modelWithDictionary:[result1 resultDictionary]]];
        }
    }
    
    return resultArray1;
}


/// 所有市区的名称
- (void)cityData:(void (^)(NSMutableArray <NSString *> *dataArray))cityData {
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    FMResultSet *result = [self.db executeQuery:@"SELECT DISTINCT city_name FROM shop_area;"];
    while ([result next]) {
        NSString *cityName = [result stringForColumn:@"city_name"];
        [resultArray addObject:cityName];
    }
    cityData(resultArray);
}

/// 获取当前市的city_number
- (void)cityNumberWithCity:(NSString *)city cityNumber:(void (^)(NSString *cityNumber))cityNumber {
    FMResultSet *result = [self.db executeQuery:[NSString stringWithFormat:@"SELECT DISTINCT city_number FROM shop_area WHERE city_name = '%@';",city]];
    while ([result next]) {
        NSString *number = [result stringForColumn:@"city_number"];
        cityNumber(number);
    }
}

/// 所有区县的名称
- (void)areaData:(NSString *)cityNumber areaData:(void (^)(NSMutableArray <NSString *> *areaData))areaData {
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    NSString *sqlString = [NSString stringWithFormat:@"SELECT area_name FROM shop_area WHERE city_number ='%@';",cityNumber];
    FMResultSet *result = [self.db executeQuery:sqlString];
    while ([result next]) {
        NSString *areaName = [result stringForColumn:@"area_name"];
        [resultArray addObject:areaName];
    }
    areaData(resultArray);
}

/// 根据city_number获取当前城市
- (void)currentCity:(NSString *)cityNumber currentCityName:(void (^)(NSString *name))currentCityName {
    FMResultSet *result = [self.db executeQuery:[NSString stringWithFormat:@"SELECT DISTINCT city_name FROM shop_area WHERE city_number = '%@';",cityNumber]];
    while ([result next]) {
        NSString *name = [result stringForColumn:@"city_name"];
        currentCityName(name);
    }
}

- (void)searchCityData:(NSString *)searchObject result:(void (^)(NSMutableArray <XQ_JFAreaDataModel *> *result))result {
    NSMutableArray <XQ_JFAreaDataModel *> *resultArray = [[NSMutableArray alloc] init];
    
    // wxq_搜索县城
//    FMResultSet *areaResult = [self.db executeQuery:[NSString stringWithFormat:@"SELECT DISTINCT province_name,province_number,area_name,area_number,city_name,city_number FROM shop_area WHERE area_name LIKE '%@%%';",searchObject]];
    FMResultSet *areaResult = [self.db executeQuery:[NSString stringWithFormat:@"SELECT * FROM shop_area WHERE area_name LIKE '%@%%';",searchObject]];
    while ([areaResult next]) {
        XQ_JFAreaDataModel *model = [XQ_JFAreaDataModel yy_modelWithDictionary:[areaResult resultDictionary]];
        [resultArray addObject:model];
    }
    
    // wxq_没有, 搜索城市
    if (resultArray.count == 0) {
        FMResultSet *cityResult = [self.db executeQuery:[NSString stringWithFormat:@"SELECT * FROM shop_area WHERE city_name LIKE '%@%%';", searchObject]];
            while ([cityResult next]) {
                XQ_JFAreaDataModel *model = [XQ_JFAreaDataModel yy_modelWithDictionary:[cityResult resultDictionary]];
                [resultArray addObject:model];
            }
    }
    
    // wxq_没有, 搜索省份
    if (resultArray.count == 0) {
        FMResultSet *provinceResult = [self.db executeQuery:[NSString stringWithFormat:@"SELECT * FROM shop_area WHERE province_name LIKE '%@%%';", searchObject]];
        
        while ([provinceResult next]) {
            XQ_JFAreaDataModel *model = [XQ_JFAreaDataModel yy_modelWithDictionary:[provinceResult resultDictionary]];
            [resultArray addObject:model];
        }
    }
    
    // 这里应该排除相同数据
    
    
    //统一在数组中传字典是为了JFSearchView解析数据时方便
//    if (resultArray.count == 0) {
//        [resultArray addObject:@{@"city":@"抱歉",@"super":@"未找到相关位置，可尝试修改后重试!"}];
//    }
    
    // 返回结果
    result(resultArray);
}

@end
