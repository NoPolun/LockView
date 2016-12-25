//
//  SZLockView.h
//  LockView
//
//  Created by 哲 on 16/12/25.
//  Copyright © 2016年 XSZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SZLockView;
@protocol SZLockViewDelegate <NSObject>

-(void)lockView:(SZLockView *)lockView didFinishPath:(NSString *)path;
@end
@interface SZLockView : UIView
@property(nonatomic,assign)IBOutlet id <SZLockViewDelegate> delegate;
@end
