//
//  XQZQImage.m
//  Pods-ZQSearchController
//
//  Created by WXQ on 2019/7/30.
//

#import "XQZQImage.h"

@implementation XQZQImage

+ (nullable UIImage *)imageNamed:(NSString *)name {
    return [UIImage imageNamed:name inBundle:[NSBundle bundleForClass:[XQZQImage class]] compatibleWithTraitCollection:nil];
}

@end
