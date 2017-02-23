//
//  TestModel.m
//  Runtime-字模转换
//
//  Created by apple on 2017/2/22.
//  Copyright © 2017年 LFX. All rights reserved.
//

#import "TestModel.h"
#import "NSObject+BaseModel.h"


@implementation TestModel

// JSON 数据中有数组要转模型，需实现这个协议
+ (NSDictionary *)arrayContainModelClass {
    return @{@"modelArr":@"TestModel"};
}


@end
