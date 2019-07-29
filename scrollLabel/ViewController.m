//
//  ViewController.m
//  scrollLabel
//
//  Created by Young on 2019/7/19.
//  Copyright © 2019 Young. All rights reserved.
//

#import "ViewController.h"
#import "PPScrollLabel.h"

@interface ViewController ()
@property (nonatomic, strong) PPScrollLabel   *scrollLabel;/**< */

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _scrollLabel = [[PPScrollLabel alloc] initWithFrame:CGRectMake(80, 120, 200, 42) withContainsXView:YES];
    [self.view addSubview:self.scrollLabel];
    _scrollLabel.scaleDuration = 0.3;
    _scrollLabel.scrollDuration = 0.4;
    _scrollLabel.scrollAnimationComplete = ^{
        NSLog(@"动画完成");
    };
//    _scrollLabel.backgroundColor = [UIColor grayColor];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setTitle:@"1" forState:UIControlStateNormal];
    [btn1 setBackgroundColor:[UIColor grayColor]];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn1.tag = 1;
    [btn1 addTarget:self action:@selector(numBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    btn1.frame = CGRectMake(80, 200, 100, 30);
    [self.view addSubview:btn1];
    
    UIButton *btn12 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn12 setTitle:@"12" forState:UIControlStateNormal];
    [btn12 setBackgroundColor:[UIColor grayColor]];
    [btn12 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn12.tag = 12;
    [btn12 addTarget:self action:@selector(numBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    btn12.frame = CGRectMake(80, 240, 100, 30);
    [self.view addSubview:btn12];
    
    UIButton *btn111 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn111 setTitle:@"111" forState:UIControlStateNormal];
    [btn111 setBackgroundColor:[UIColor grayColor]];
    [btn111 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn111.tag = 111;
    [btn111 addTarget:self action:@selector(numBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    btn111.frame = CGRectMake(80, 280, 100, 30);
    [self.view addSubview:btn111];
    
    UIButton *btn1314 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1314 setTitle:@"1314" forState:UIControlStateNormal];
    [btn1314 setBackgroundColor:[UIColor grayColor]];
    [btn1314 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn1314.tag = 1314;
    [btn1314 addTarget:self action:@selector(numBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    btn1314.frame = CGRectMake(80, 320, 100, 30);
    [self.view addSubview:btn1314];
    
    UIButton *btn520 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn520 setTitle:@"520000" forState:UIControlStateNormal];
    [btn520 setBackgroundColor:[UIColor grayColor]];
    [btn520 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn520.tag = 52000000;
    [btn520 addTarget:self action:@selector(numBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    btn520.frame = CGRectMake(80, 360, 100, 30);
    [self.view addSubview:btn520];
}

- (void)numBtnAction:(UIButton *)sender {
    [self.scrollLabel startAnimationWithNumbers:sender.tag];
}

@end
