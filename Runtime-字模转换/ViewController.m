//
//  ViewController.m
//  Runtime-字模转换
//
//  Created by apple on 2017/2/22.
//  Copyright © 2017年 LFX. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+BaseModel.h"
#import "TestModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSDictionary *dic  = @{@"name":@"张三",@"age":@"18",
                           @"dic":@{@"name":@"李四",@"age":@"20"},
                           @"modelArr":@[@{@"name":@"王五",@"age":@"30"},
                                         @{@"name":@"刘能",@"age":@"30"}]};
    
    TestModel *model =  [TestModel modelWithDic:dic];
    NSLog(@"%@ + %@",model.age,model.name);
    NSLog(@"%@ + %@",model.dic.age,model.dic.name);
    
    for (NSUInteger i=0,n = model.modelArr.count; i < n; i ++) {
        TestModel *m = model.modelArr[i];
        NSLog(@"%@ + %@",m.age,m.name);
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
