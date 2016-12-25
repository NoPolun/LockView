//
//  ViewController.m
//  LockView
//
//  Created by 哲 on 16/12/25.
//  Copyright © 2016年 XSZ. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

-(void)lockView:(SZLockView *)lockView didFinishPath:(NSString *)path
{
    NSLog(@"输出的路径%@",path);
    if ([path isEqualToString:@"12345678"]) {
        [self titleString:@"密码正确"];
    }else {
        [self titleString:@"密码错误"];
    }
}
-(void)titleString:(NSString *)title
{
    UIAlertController *alter =[UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alter addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil]];
    [alter addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alter animated:YES completion:nil];
}


@end
