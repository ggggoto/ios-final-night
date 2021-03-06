//
//  RMDebugView.m
//  FinalKnight
//
//  Created by 都筑 友昭 on 2013/08/20.
//  Copyright (c) 2013年 ramuh. All rights reserved.
//

#import "RMDebugView.h"
#import <XlKit/XlKit.h>
#import <BTKit/BTKit.h>
#import <AudioToolbox/AudioServices.h>

#define threshCoef 10

// definition of layout
#define SCREEN_FRAME [[UIScreen mainScreen] applicationFrame]
#define MARGIN_LEFT 10

@implementation RMDebugView{
    float threshLose;
    float threshAlert;
    
    UIScrollView *sv;
    
    UILabel *num1;
    UILabel *num2;
    
    UITextField *tf1;
    UITextField *tf2;
    
    UITextView *tv;
    
    RMBTPeripheral *rmBtPeripheral;
    RMBTCentral *rmBtCentral;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setBackgroundColor:[UIColor whiteColor]];
        
        RMLpf *rmlpf = [[RMLpf alloc]init:20 c1:0.001 c2:0.999];
        rmlpf.delegate = self;
        [rmlpf startLpf];
        
        threshLose = 2.5;
        threshAlert = 1.5;
        
        sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_FRAME.size.width, SCREEN_FRAME.size.height)];
        sv.contentSize = CGSizeMake(SCREEN_FRAME.size.width, SCREEN_FRAME.size.height + 1);
        [self addSubview:sv];
        
        //UI initialization
        [self initializeSliders];
        [self initializeBTConfigLayout];
        
    }
    return self;
}

#pragma mark UI
#pragma mark Sliders
- (void) initializeSliders
{
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(MARGIN_LEFT, 10, 250, 20)];
    label1.text = @"threshold for lose";
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(MARGIN_LEFT, 70, 250, 20)];
    label2.text = @"threshold for alert";
    
    UISlider *sl1 = [[UISlider alloc] initWithFrame:CGRectMake(MARGIN_LEFT, 30, 250, 10)];
    [sl1 addTarget:self action:@selector(sl1Changed:)forControlEvents:UIControlEventValueChanged];
    sl1.value = 0.5;
    
    UISlider *sl2 = [[UISlider alloc] initWithFrame:CGRectMake(MARGIN_LEFT, 90, 250, 10)];
    [sl2 addTarget:self action:@selector(sl2Changed:)forControlEvents:UIControlEventValueChanged];
    sl2.value = 0.25;
    
    num1 = [[UILabel alloc]initWithFrame:CGRectMake(200, 10, 250, 20)];
    num1.text = [NSString stringWithFormat:@"%f",sl1.value * threshCoef];
    
    num2 = [[UILabel alloc]initWithFrame:CGRectMake(200, 70, 250, 20)];
    num2.text = [NSString stringWithFormat:@"%f",sl2.value * threshCoef];
    
    [sv addSubview:label1];
    [sv addSubview:label2];
    
    [sv addSubview:sl1];
    [sv addSubview:sl2];
    
    [sv addSubview:num1];
    [sv addSubview:num2];
    
}

-(void)sl1Changed:(UISlider*)slider
{
    threshLose = slider.value * threshCoef;
    num1.text = [NSString stringWithFormat:@"%f", threshLose];
}

-(void)sl2Changed:(UISlider*)slider{
    threshAlert = slider.value * threshCoef;
    num2.text = [NSString stringWithFormat:@"%f", threshAlert];
}

#pragma mark Buttons
- (void) initializeBTConfigLayout
{
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn1 setTitle:@"peripheral start" forState:UIControlStateNormal];
    btn1.frame = CGRectMake(MARGIN_LEFT, 180, 130, 30);
    [btn1 addTarget:self action:@selector(btn1Pressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn2 setTitle:@"notification start" forState:UIControlStateNormal];
    btn2.frame = CGRectMake(MARGIN_LEFT * 2 + 130, 180, 130, 30);
    [btn2 addTarget:self action:@selector(btn2Pressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn3 setTitle:@"central start" forState:UIControlStateNormal];
    btn3.frame = CGRectMake(MARGIN_LEFT, 250, 100, 30);
    [btn3 addTarget:self action:@selector(btn3Pressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn4 setTitle:@"notification start" forState:UIControlStateNormal];
    btn4.frame = CGRectMake(MARGIN_LEFT * 2 + 130, 250, 130, 30);
    [btn4 addTarget:self action:@selector(btn4Pressed) forControlEvents:UIControlEventTouchUpInside];
    
    [sv addSubview:btn1];
    [sv addSubview:btn2];
    [sv addSubview:btn3];
    [sv addSubview:btn4];
    
    tf1 = [[UITextField alloc] initWithFrame:CGRectMake(MARGIN_LEFT, 130, 130, 30)];
    tf1.borderStyle = UITextBorderStyleRoundedRect;
    tf1.delegate = self;
    tf1.placeholder = @"ID peripheral";
    
    tf2 = [[UITextField alloc] initWithFrame:CGRectMake(MARGIN_LEFT * 2 + 130, 130, 130, 30)];
    tf2.borderStyle = UITextBorderStyleRoundedRect;
    tf2.delegate = self;
    tf2.placeholder = @"ID central";
    
    [sv addSubview:tf1];
    [sv addSubview:tf2];
    
    tv = [[UITextView alloc] initWithFrame:CGRectMake(MARGIN_LEFT,300, 300, 200)];
    tv.editable = NO;
    
    [sv addSubview:tv];
    
}

- (void) btn1Pressed
{
    [self initializePeripheral];
}

- (void) btn2Pressed
{
    NSData *data = [@"This must be log string to be shown capability of data transfer" dataUsingEncoding:NSUTF8StringEncoding];
    NSString *receivedString= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", receivedString);
    [rmBtPeripheral notifyData:data];
}

- (void) btn3Pressed
{
    [self initializecCentral];
}

- (void) btn4Pressed
{
    NSData *data = [@"Write value to peripheral" dataUsingEncoding:NSUTF8StringEncoding];
    [rmBtCentral writeDataToPeriperal:data];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark XlKit
- (void)LpfUpdate:(float)rms
{
    if(rms>=threshLose){
        [self threshLost];
    }else if(rms>=threshAlert){
        [self playAlertSound];
    }
}

- (void) threshLost
{
    AudioServicesPlaySystemSound(1008);
}

- (void) playAlertSound
{
    AudioServicesPlaySystemSound(1016);
}

#pragma mark BT
- (void) initializePeripheral
{
    rmBtPeripheral = [[RMBTPeripheral alloc]init];
    [rmBtPeripheral initWithDelegate:self peripheralId:tf1.text];
}

- (void) initializecCentral
{
    rmBtCentral = [[RMBTCentral alloc]init];
    [rmBtCentral initWithDelegate:self centralId:tf2.text];
}

#pragma mark RMBTDelegate
- (void) centralError:(NSString *)errorMsg
{
    NSLog(@"%@", errorMsg);
}

- (void) cannotFindServiceError
{
    NSLog(@"this is fatal error. BT setting needs to be off -> on to recover");
}

- (void) peripheralFound
{
    for (CBPeripheral *peripheral in rmBtCentral.peripherals){
        NSLog(peripheral.name);
    }
}

- (void) ackNotReceived
{
    NSLog(@"ack not received");
}

- (void) logPeripheral:(NSString *)logText
{
    NSString *tmpString = [[[NSString alloc]initWithFormat:@"%@\n%@", tv.text, logText]autorelease];
    tv.text = tmpString;
}

- (void) logCentral:(NSString *)logText
{
    NSString *tmpString = [[[NSString alloc]initWithFormat:@"%@\n%@", tv.text, logText]autorelease];
    tv.text = tmpString;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
