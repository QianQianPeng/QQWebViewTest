//
//  ViewController.m
//  QQWebViewTest
//
//  Created by 彭倩倩 on 2018/12/27.
//  Copyright © 2018 彭倩倩. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.navigationController pushViewController:[NSClassFromString(@"QQWebViewController") new] animated:YES];
}

@end
