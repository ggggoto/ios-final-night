//
//  RMViewController.m
//  SlowPushwer
//
//  Created by 都筑 友昭 on 2013/07/14.
//  Copyright (c) 2013年 ramuh. All rights reserved.
//

#import "RMViewController.h"
#import <XlKit/XlKit.h>
#import <BTKit/BTKit.h>
#import <AudioToolbox/AudioServices.h>

#define threshCoef 10

// definition of layout
#define MARGIN_LEFT 10

@interface RMViewController ()

@end

@implementation RMViewController{
    float threshLose;
    float threshAlert;
    
    UILabel *num1;
    UILabel *num2;
    
    UITextField *tf1;
    UITextField *tf2;
    
    RMBTPeripheral *rmBtPeripheral;
    RMBTCentral *rmBtCentral;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    RMLpf *rmlpf = [[RMLpf alloc]init:20 c1:0.001 c2:0.999];
    rmlpf.delegate = self;
    [rmlpf startLpf];
    
    threshLose = 2.5;
    threshAlert = 1.5;
    
    //UI initialization
    [self initializeSliders];
    [self initializeBTConfigLayout];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    [self.view addSubview:label1];
    [self.view addSubview:label2];
    
    [self.view addSubview:sl1];
    [self.view addSubview:sl2];
    
    [self.view addSubview:num1];
    [self.view addSubview:num2];
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

#pragma mark Sliders
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
    
    [self.view addSubview:btn1];
    [self.view addSubview:btn2];
    [self.view addSubview:btn3];
    
    tf1 = [[UITextField alloc] initWithFrame:CGRectMake(MARGIN_LEFT, 130, 130, 30)];
    tf1.borderStyle = UITextBorderStyleRoundedRect;
    tf1.placeholder = @"ID peripheral";
    
    tf2 = [[UITextField alloc] initWithFrame:CGRectMake(MARGIN_LEFT * 2 + 130, 130, 130, 30)];
    tf2.borderStyle = UITextBorderStyleRoundedRect;
    tf2.placeholder = @"ID central";
    
    [self.view addSubview:tf1];
    [self.view addSubview:tf2];
    
}

- (void) btn1Pressed
{
    [self initializePeripheral];
}

- (void) btn2Pressed
{
    NSData *data = [@"notification data etst test tset" dataUsingEncoding:NSUTF8StringEncoding];
    NSString *receivedString= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", receivedString);
    [rmBtPeripheral notifyData:data];
}

- (void) btn3Pressed
{
    [self initializecCentral];
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
    threshLose -= 0.1;
    num1.text = [NSString stringWithFormat:@"%f", threshLose];
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

@end
