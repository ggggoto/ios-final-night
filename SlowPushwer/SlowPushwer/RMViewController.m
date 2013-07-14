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

@interface RMViewController ()

@end

@implementation RMViewController{
    float threshLose;
    float threshAlert;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    RMLpf *rmlpf = [[RMLpf alloc]init];
    rmlpf.delegate = self;
    
    threshLose = 2.5;
    threshAlert = 1.5;
    
    [self initializeBluetooth];
    
    [self setSliders];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark BT
#pragma mark -
#pragma mark Bluetooth

- (void) initializeBluetooth
{
    RMbt *bluetoothConnection = [[RMbt alloc]init];
    bluetoothConnection.delegate = self;
    [bluetoothConnection initializeBluetooth];
}

- (void) btConnected:(NSString *)peerId
{
    
    NSLog(peerId);
    
}

- (void) btMsgReceived:(NSString *)msg
{
    
    NSLog(msg);
    
}

#pragma mark UI
- (void) setSliders
{
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, 250, 20)];
    label1.text = @"threshold for lose";
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(30, 70, 250, 20)];
    label2.text = @"threshold for alert";
    
    UISlider *sl1 = [[UISlider alloc] initWithFrame:CGRectMake(30, 30, 250, 10)];
    [sl1 addTarget:self action:@selector(hoge1:)forControlEvents:UIControlEventValueChanged];
    
    UISlider *sl2 = [[UISlider alloc] initWithFrame:CGRectMake(30, 90, 250, 10)];
    [sl2 addTarget:self action:@selector(hoge2:)forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:label1];
    [self.view addSubview:label2];
    
    [self.view addSubview:sl1];
    [self.view addSubview:sl2];
}

-(void)hoge1:(UISlider*)slider
{
    threshLose = slider.value * 5;
}

-(void)hoge2:(UISlider*)slider{
    threshAlert = slider.value * 5;
}

#pragma mark XlKit
- (void)LpfUpdate:(float)rms
{
    
    if(rms>=threshLose){
        [self playBeepSound];
    }else if(rms>=threshAlert){
        [self playAlertSound];
    }
}

- (void) playBeepSound
{
    AudioServicesPlaySystemSound(1008);
}

- (void) playAlertSound
{
    AudioServicesPlaySystemSound(1016);
}

@end
