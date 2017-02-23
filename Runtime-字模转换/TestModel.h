//
//  TestModel.h
//  Runtime-字模转换
//
//  Created by apple on 2017/2/22.
//  Copyright © 2017年 LFX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestModel : NSObject

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *age;
@property (strong, nonatomic) TestModel *dic;
@property (strong, nonatomic) NSArray *modelArr;

@end
