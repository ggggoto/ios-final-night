//
//  RMViewController.h
//  SlowPushwer
//
//  Created by 都筑 友昭 on 2013/07/14.
//  Copyright (c) 2013年 ramuh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XlKit/XlKit.h>
#import <BTKit/BTKit.h>

@interface RMViewController : UIViewController<
UITextFieldDelegate,
RMLpfDelegate,
RMBTPeripheralDelegate,
RMBTCentralDelegate
>

@end
