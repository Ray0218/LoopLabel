//
//  DPLoopView.m
//  LoopLabel
//
//  Created by Ray on 16/5/9.
//  Copyright © 2016年 Ray. All rights reserved.
//

#import "DPLoopView.h"

@interface DPLoopView ()<UITableViewDelegate,UITableViewDataSource>{
    UILabel* _labelShow ;
    UILabel* _labelShow2 ;
    UILabel* _firstLab  ;
    UILabel* _secondLab  ;
    UILabel* _thirdLab  ;

    NSMutableArray* _recentWinArray ;
    int _index ;
    
    
    CGFloat _offSetY ;
    
}

@property (nonatomic, strong)UITableView *tableView ;
@property (nonatomic, strong)CADisplayLink *displayLink ;



@end
@implementation DPLoopView

-(void)dealloc {
    [self stop] ;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _recentWinArray = [[NSMutableArray alloc]init];
        self.userInteractionEnabled = NO ;
        self.clipsToBounds = YES ;
        
        for (int i= 0; i<20; i++) {
            NSString *str = [NSString stringWithFormat:@"标签%d",i] ;
            [_recentWinArray addObject:str];
            
        }
        
        self.backgroundColor = [UIColor greenColor] ;
        
        [self initViews];
//        [self addSubview:self.tableView];
    }
    return self;
}


-(void)initViews {


    _firstLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 120, 30) ];
    _firstLab.text =_recentWinArray[0];
    
    _secondLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 30, 120, 30)] ;
    _secondLab.text = _recentWinArray[1];
    
    _thirdLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 60, 120, 30)];
    _thirdLab.text = _recentWinArray[2];
    
    
    _firstLab.backgroundColor = [UIColor orangeColor] ;
    _secondLab.backgroundColor = [UIColor yellowColor] ;
    _thirdLab.backgroundColor = [UIColor lightGrayColor] ;
    
    [self addSubview:_firstLab];
    [self addSubview:_secondLab];
    [self addSubview:_thirdLab];
    
    
    
}





-(void)layoutSubviews {

    self.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) ;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3 ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static  NSString *cellIdentify = @"cellIdentify" ;
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify] ;
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        cell.contentView.backgroundColor = [UIColor clearColor] ;
        
    }
    
    cell.textLabel.text = _recentWinArray[indexPath.row%_recentWinArray.count] ;
    return cell ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 30 ;
}

-(UITableView*)tableView {
    
    if (_tableView ==nil) {
        _tableView = [[UITableView alloc]init];
        _tableView.backgroundColor = [UIColor greenColor] ;
        _tableView.delegate =self ;
        _tableView.dataSource =self ;
        _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone ;
        _tableView.userInteractionEnabled = NO ;
        
    }
    
    return  _tableView ;
    
}

-(CADisplayLink*)displayLink {

    if (_displayLink == nil) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateTableview)];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes] ;
        _displayLink.paused = YES ;
//        _displayLink.frameInterval = 2 ;

    }
    
    return _displayLink ;
}


-(void)setIsStop:(BOOL)isStop {
    
    if (isStop) {
        self.displayLink.paused = YES ;
        [self.displayLink invalidate];
        self.displayLink = nil;

    }

}

-(void)stop {

    self.displayLink.paused = YES ;
    [self.displayLink invalidate];
    self.displayLink = nil;

}

-(void)start {

//    self.displayLink.paused = NO ;
    
    
    
    __weak typeof(self) weakSelf = self;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 0.04 * NSEC_PER_SEC, 0);
    
    __block  NSInteger rowNum = 3 ;

    dispatch_source_set_event_handler(_timer, ^{
        
        if (weakSelf.isStop) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //倒计时结束
            });
            
        } else {
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                _offSetY  = 1 ;
                
                CGRect firstFrame = _firstLab.frame ;
                CGRect secondFrame = _secondLab.frame ;
                CGRect thirdFrame = _thirdLab.frame ;
                
                
                
                firstFrame.origin.y -= _offSetY ;
                secondFrame.origin.y -= _offSetY ;
                thirdFrame.origin.y -= _offSetY ;
                
                NSString *newxtStr = _recentWinArray[rowNum] ;
                
                if (thirdFrame.origin.y <= -30) {
                    thirdFrame.origin.y = (secondFrame.origin.y + 30) ;
                    rowNum+=1 ;
                    _thirdLab.text = newxtStr ;
                 }
                
                if (secondFrame.origin.y <= -30) {
                    secondFrame.origin.y = (firstFrame.origin.y + 30) ;
                    _secondLab.text = newxtStr ;
                    rowNum+=1 ;

                }
                
                if (firstFrame.origin.y <= -30) {
                    firstFrame.origin.y = (thirdFrame.origin.y + 30) ;
                    _firstLab.text = newxtStr ;
                    rowNum+=1 ;

                }
                
                if (rowNum >= _recentWinArray.count) {
                    rowNum = 0 ;
                }
                
                
                _firstLab.frame = firstFrame ;
                _secondLab.frame = secondFrame ;
                _thirdLab.frame = thirdFrame ;

            
            });
            
        }
        
     });
    dispatch_resume(_timer);

 }


-(void)updateTableview {
    _offSetY  = 0.5 ;

    CGRect firstFrame = _firstLab.frame ;
    CGRect secondFrame = _secondLab.frame ;
    CGRect thirdFrame = _thirdLab.frame ;
    
    
    
    firstFrame.origin.y -= _offSetY ;
    secondFrame.origin.y -= _offSetY ;
    thirdFrame.origin.y -= _offSetY ;
    
    if (thirdFrame.origin.y <= -30) {
        thirdFrame.origin.y = (secondFrame.origin.y + 30) ;
    }
    
    if (secondFrame.origin.y <= -30) {
        secondFrame.origin.y = (firstFrame.origin.y + 30) ;
    }

    if (firstFrame.origin.y <= -30) {
        firstFrame.origin.y = (thirdFrame.origin.y + 30) ;
    }
    
    
    
    
    _firstLab.frame = firstFrame ;
    _secondLab.frame = secondFrame ;
    _thirdLab.frame = thirdFrame ;
    
    
    return ;
    
    
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//        NSLog(@"_offSetY ===  %.2f",_offSetY) ;
//        [self.tableView scrollRectToVisible:CGRectOffset(self.tableView.frame, 0, _offSetY) animated:NO];
    
    
    [self.tableView setContentOffset:CGPointMake(0, _offSetY) animated:NO];
//
//    });
//
    if (_offSetY >= self.tableView.contentSize.height - CGRectGetHeight(self.tableView.frame)) {
        self.displayLink.paused = YES ;
        [self.tableView setContentOffset:CGPointZero animated:NO];
        self.displayLink.paused = NO ;
        _offSetY = 0 ;
        
    }

    return ;



    __weak typeof(self) weakSelf = self;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 0.02 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        
        if (weakSelf.isStop) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //倒计时结束
            });
            
        } else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (_offSetY >= weakSelf.tableView.contentSize.height) {
                    _offSetY = 0 ;
                    [weakSelf.tableView scrollRectToVisible:CGRectOffset(weakSelf.tableView.frame, 0, _offSetY) animated:YES];
                }else
                
                    [weakSelf.tableView scrollRectToVisible:CGRectOffset(weakSelf.tableView.frame, 0, _offSetY) animated:YES];
                
            });
            
        }
        
        _offSetY+= 3.5 ;
    });
    dispatch_resume(_timer);

}

@end
