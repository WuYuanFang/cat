//
//  XQ_JFAreaDataModel.h
//  FMDB
//
//  Created by WXQ on 2019/11/8.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface XQ_JFAreaDataModel : NSObject <YYModel>

/** <#note#> */
@property (nonatomic, copy) NSNumber *area_number;
/** <#note#> */
@property (nonatomic, copy) NSString *area_name;
/** <#note#> */
@property (nonatomic, copy) NSNumber *city_number;
/** <#note#> */
@property (nonatomic, copy) NSString *city_name;
/** <#note#> */
@property (nonatomic, copy) NSNumber *province_number;
/** <#note#> */
@property (nonatomic, copy) NSString *province_name;

//area_number INTEGER ,area_name TEXT ,city_number INTEGER ,city_name TEXT ,province_number INTEGER ,province_name TEXT);";

@end

NS_ASSUME_NONNULL_END
