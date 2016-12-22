//
//  DPLoopView.h
//  LoopLabel
//
//  Created by Ray on 16/5/9.
//  Copyright © 2016年 Ray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"

@interface DPLoopView : UIView


 
-(void)startTimer ;

-(void)stop ;
-(void)start ;

@property (nonatomic, assign) BOOL isStop ;

@end
