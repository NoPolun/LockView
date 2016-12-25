//
//  SZLockView.m
//  LockView
//
//  Created by 哲 on 16/12/25.
//  Copyright © 2016年 XSZ. All rights reserved.
//

#import "SZLockView.h"
//const 定义只读的变量名，在其他的类中不能声明同样的变量名
CGFloat const btnCount = 9;
CGFloat const btnW = 74;
CGFloat const btnH =74;
CGFloat const viewY = 200;
int const columnCount = 3;
#define SZSreenWidth [UIScreen mainScreen].bounds.size.width
@interface SZLockView()
//选择的按钮
@property(nonatomic,strong)NSMutableArray *selectedBtns;
//当前点
@property(nonatomic,assign)CGPoint currentPoint;
@end
@implementation SZLockView

-(NSMutableArray *)selectedBtns
{
    if (_selectedBtns == nil) {
        _selectedBtns = [NSMutableArray array];
    }
    return _selectedBtns;
}
//使用代码创建调用方法
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addButton];
    }
    return self;
}
//使用xib和storyboard创建代用方法
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self addButton];
    }
    return self;
}
-(void)addButton
{
    CGFloat height = 0;
    for (int i = 0; i < btnCount; i++) {
        UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
        btn.userInteractionEnabled = NO;
        [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_normal" ] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_highlighted" ] forState:UIControlStateSelected];
        btn.tag = i;
        int row = i / columnCount; // 第几行
        int column = i % columnCount; //第几列
        //边距
        CGFloat margin = (SZSreenWidth - columnCount *btnW)/(columnCount + 1);
        //x轴
        CGFloat btnX = margin + column *(btnW + margin);
        //y轴
        CGFloat btnY =  row *(btnW + margin);
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        height = btnH + btnY;
        [self addSubview:btn];
    }
    self.frame = CGRectMake(0, viewY, SZSreenWidth, height);
    
}
#pragma mark - 触摸方法
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //拿到触摸的点
    CGPoint point = [self pointWithTouch:touches];
 //根据触摸的点拿到响应的按钮
    UIButton *btn =[self buttonWithPoint:point];
    if (btn && btn.selected == NO) {
        btn.selected = YES;
         [self.selectedBtns addObject:btn]; //往数组或者字典添加对象要判断对象是否存在
    }
    
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //拿到触摸的点
    CGPoint point = [self pointWithTouch:touches];
    //根据触摸的点拿到响应的按钮
    UIButton *btn =[self buttonWithPoint:point];
    if (btn && btn.selected == NO) {
        btn.selected = YES;
        [self.selectedBtns addObject:btn]; //往数组或者字典添加对象要判断对象是否存在
        
    }else{
        self.currentPoint = point;
    }
    [self setNeedsDisplay];
 
   
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(lockView:didFinishPath:)]) {
        NSMutableString *path =[NSMutableString string];
        for (UIButton *btn in self.selectedBtns) {
            [path appendFormat:@"%ld",(long)btn.tag];
        }
        [self.delegate lockView:self didFinishPath:path];
    }
    
    //清空按钮的选中状态
//    makeObjectsPerformSelector向数组中的每一个对象发送方法，setSelected参数为NULL(NO)
    [self.selectedBtns makeObjectsPerformSelector:@selector(setSelected:) withObject:NULL];
    [self.selectedBtns removeAllObjects];
    [self setNeedsDisplay];
}
//触摸被打断
-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

-(CGPoint)pointWithTouch:(NSSet *)touches
{
    //拿到触摸的点
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    return point;
}
-(UIButton *)buttonWithPoint:(CGPoint)point
{
    //根据触摸的点拿到响应的按钮
    for (UIButton *btn in self.subviews) {
        //第一个参数为矩形框
        //第二个参数为触摸的点
        if (CGRectContainsPoint(btn.frame, point)) {
            return btn;
        }
    }
    return  nil;
    
}


-(void)drawRect:(CGRect)rect
{
    if (self.selectedBtns.count == 0) {
        return;
    }
    UIBezierPath *path = [UIBezierPath bezierPath];
    //线宽
    path.lineWidth = 8;
    //线的样式
    path.lineJoinStyle = kCGLineCapRound;
    [[UIColor colorWithRed:32/255.0 green:210/255.0 blue:254/255.0 alpha:0.5] set];
    
    for (int i = 0; i < self.selectedBtns.count; i++) {
        UIButton *button = self.selectedBtns[i];
        if (i == 0) {
//            起点
            [path moveToPoint:button.center];
        }else{
            //连线
            [path addLineToPoint:button.center];
        }
    }
    [path addLineToPoint:self.currentPoint];
    [path stroke];
    
}
@end
