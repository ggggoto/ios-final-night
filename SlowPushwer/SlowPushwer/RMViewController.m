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

@interface RMViewController ()

@end

@implementation RMViewController{
    float threshLose;
    float threshAlert;
    
    UILabel *num1;
    UILabel *num2;
    
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
    
    [self setSliders];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    sl1.value = 0.5;
    
    UISlider *sl2 = [[UISlider alloc] initWithFrame:CGRectMake(30, 90, 250, 10)];
    [sl2 addTarget:self action:@selector(hoge2:)forControlEvents:UIControlEventValueChanged];
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

-(void)hoge1:(UISlider*)slider
{
    threshLose = slider.value * threshCoef;
    num1.text = [NSString stringWithFormat:@"%f", threshLose];
}

-(void)hoge2:(UISlider*)slider{
    threshAlert = slider.value * threshCoef;
    num2.text = [NSString stringWithFormat:@"%f", threshAlert];
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

@end
