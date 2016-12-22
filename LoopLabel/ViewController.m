//
//  ViewController.m
//  LoopLabel
//
//  Created by Ray on 16/5/9.
//  Copyright © 2016年 Ray. All rights reserved.
//

#import "ViewController.h"
#import "DPLoopView.h"

@interface ViewController (){

    DPLoopView *loopView  ;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
     loopView = [[DPLoopView alloc]initWithFrame:CGRectMake(20, 100, 280, 50)];
    
    
    [self.view addSubview:loopView];
    
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom] ;
    [btn setTitle:@"next" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pvt_next) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor grayColor] ;
    btn.frame = CGRectMake(50, 50, 120, 30);
    [self.view addSubview:btn];
    
    
    
}

-(void)pvt_next {

    [loopView start];

}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
