//
//  JFAreaDataManager.h
//  JFFootball
//
//  Created by 张志峰 on 2016/11/18.
//  Copyright © 2016年 zhifenx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XQ_JFAreaDataModel.h"

@interface JFAreaDataManager : NSObject

+ (JFAreaDataManager *)shareInstance;

- (void)areaSqliteDBData;


/**
 wxq_查询所有
 */
- (void)xq_queryAll:(void (^)(NSMutableArray <XQ_JFAreaDataModel *> *dataArray))cityData;

/**
 wxq_查询某个城市信息

 @param cityName 城市名称
 */
- (NSMutableArray <XQ_JFAreaDataModel *> *)xq_queryCityInfoWithCityName:(NSString *)cityName;

/**
 wxq_获取所有市名称

 @param cityData 查询返回值，所有市区数组
 */
- (void)cityData:(void (^)(NSMutableArray <NSString *> *dataArray))cityData;


/**
 获取市对应的city_number

 @param city 查询对象（城市名）
 @param cityNumber 查询返回值（city_number）
 */
- (void)cityNumberWithCity:(NSString *)city cityNumber:(void (^)(NSString *cityNumber))cityNumber;

/**
 获取某个市的所有区县名称

 @param cityNumber 查询对象
 @param areaData 查询返回值,该市的所有区县数组
 */
- (void)areaData:(NSString *)cityNumber areaData:(void (^)(NSMutableArray <NSString *> *areaData))areaData;


/**
 根据city_number获取当前城市名字

 @param cityNumber 城市ID
 @param currentCityName 当前城市名字
 */
- (void)currentCity:(NSString *)cityNumber currentCityName:(void (^)(NSString *name))currentCityName;


/**
 使用搜索框，搜索城市

 @param searchObject 搜索对象
 @param result 搜索回调结果
 */
- (void)searchCityData:(NSString *)searchObject result:(void (^)(NSMutableArray <XQ_JFAreaDataModel *> *result))result;

@end
