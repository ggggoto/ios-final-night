//
//  RMDebugView.h
//  FinalKnight
//
//  Created by 都筑 友昭 on 2013/08/20.
//  Copyright (c) 2013年 ramuh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XlKit/XlKit.h>
#import <BTKit/BTKit.h>

@interface RMDebugView : UIView<
UITextFieldDelegate,
RMLpfDelegate,
RMBTPeripheralDelegate,
RMBTCentralDelegate
>


@end
