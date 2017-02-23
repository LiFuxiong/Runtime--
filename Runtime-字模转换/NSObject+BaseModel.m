//
//  NSObject+BaseModel.m
//  Runtime-字模转换
//
//  Created by apple on 2017/2/22.
//  Copyright © 2017年 LFX. All rights reserved.
//

#import "NSObject+BaseModel.h"
#import <objc/runtime.h>

@implementation NSObject (BaseModel)


+ (instancetype)modelWithDic:(NSDictionary *)dic {
    // 遍历模型中的所有属性Key（用Runtime特性）-》去字典通过Key获取Value值-》将Value赋值给模型属性
    
    // 1. 创建对应的对象
    id objc = [[self alloc] init];
    
    // 2. 利用Runtime 给对象中的成员属性赋值
    
    // class_copyIvarList:获取类中的所有成员属性
    // Ivar:成员属性的意思
    // 第一个参数：表示获取那个类中的成员属性
    // 第二个参数：表示这个类有多少个成员属性，传入一个Int变量地址，会自动给这个变量赋值
    // 返回值Ivar *：指的是一个ivar数组，会把所有的成员属性放在一个数组中，通过返回的数据就能回去到所有的成员属性
    
    unsigned int count;
    
    // 获取类中对象的所有成员属性
    Ivar *ivarList = class_copyIvarList(self, &count);
    
    // 遍历对象的所有成员属性
    for(int i = 0; i < count; i ++) {
        // 根据数组角标，获取成员属性
        Ivar ivar = ivarList[i];
        
        // 获取成员属性名
        NSString *name = [NSString stringWithUTF8String:ivar_getName(ivar)];
        
        
        //  处理成员属性名-》字典中的key
        // 从第一个角标开始截取(类型是@“_name”)
        NSString *key = [name substringFromIndex:1];
        
        // 根据成员属性名去字典中查找相应的Value
        
        id value = dic[key];
        
        
        // 二级转换：如果字典里面还有字典，也需要把对应的字典转换成模型
        // 判断下 Value是否是字典
        if([value isKindOfClass:[NSDictionary class]]) {
            // 字典转模型
            // 获取模型的类对象，调用modelWithDic
            // 模型的类名已知，就是成员属性的类型
            
            // 获取变量类型
            NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
            // 生成的是这种@"@\"Person\""类型-》@"Person" 在OC字符串中 \"-》",\转义的意思，不占用字符
            
            // 截取类型字符串 range.location 代表 \"的位置 range.length 代表 \"的长度
            NSRange range = [type rangeOfString:@"\""];
            
            // 去除第一个\"转义
            type = [type substringFromIndex:range.location + range.length];
            
            // 获取后面 \" 的range
            range = [type rangeOfString:@"\""];
            
            // 截取type类型到后面\"的range.location为止,不包括range.location 角标
            type = [type substringToIndex:range.location];
            
            //  获取对应的模型类
            Class classModel = NSClassFromString(type);
            
            // 模型类存在，才转换
            if(classModel) {
                value = [classModel modelWithDic:dic[key]];
            }
        }
        
        // 三级转换：字典当中还有数组，把数组中的字典转换成模型
        // 判断是否是数组
        if([value isKindOfClass:[NSArray class]]) {
            // 判断对应的类有没有实现字典数据转换模型数组的协议
            if([self respondsToSelector:@selector(arrayContainModelClass)]) {
                // 将self 转换成id类型，就能调用任何对象
                id idSelf = self;
                
                // 获取数组中对应的模型类型
                NSString *type = [idSelf arrayContainModelClass][key];
                
                Class classModel = NSClassFromString(type);
                
                // 判断model是否存在
                if(classModel) {
                    // 创建一个存放model的数组
                    NSMutableArray *modelArr = [NSMutableArray array];
                    // 遍历数组里面字典数据
                    for (NSDictionary *dic in value) {
                        id model = [classModel modelWithDic:dic];
                        [modelArr addObject:model];
                    }
                    
                    value = modelArr;
                }
                
            }
        }
        
        // 设置属性的值有两种方式
        // 方式1
        if(value) {
            object_setIvar(objc, ivar, value);
        }
        
        // 方式2
        //        if (value) {  //  有值，才需要给模型的属性赋值
        //            // 利用KVC给模型中的属性赋值
        //            [objc setValue:value forKey:key];
        //        }
        
    }
    
    return objc;
    
}

@end
