//
//  RMViewController.m
//  SlowPushwer
//
//  Created by 都筑 友昭 on 2013/07/14.
//  Copyright (c) 2013年 ramuh. All rights reserved.
//

#import "RMViewController.h"
#import "RMDebugView.h"

#define threshCoef 10

// definition of layout
#define SCREEN_FRAME [[UIScreen mainScreen] applicationFrame]

@interface RMViewController ()

@end

@implementation RMViewController{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self initializeLayout];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UI

#pragma mark Sliders
- (void) initializeLayout
{
    
    UIImage *image = [UIImage imageNamed:@"FFT_Knights.png"];
    UIImageView *titleFigure = [[UIImageView alloc] initWithImage:image];
    titleFigure.frame = CGRectMake(20, 20, 269, 371);
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn1 setTitle:@"game start" forState:UIControlStateNormal];
    btn1.frame = CGRectMake(20, 300, 130, 60);
    [btn1 addTarget:self action:@selector(btn1Pressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn2 setTitle:@"debug start" forState:UIControlStateNormal];
    btn2.frame = CGRectMake(20 * 2 + 130, 300, 130, 60);
    [btn2 addTarget:self action:@selector(btn2Pressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:titleFigure];
    [self.view addSubview:btn1];
    [self.view addSubview:btn2];
    
    titleFigure.alpha = 0.0;
    btn1.alpha = 0.0;
    btn2.alpha = 0.0;
    [UIView animateWithDuration:1.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         //Animation
                         titleFigure.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                         //Completion
                         [UIView animateWithDuration:0.7
                                               delay:0.0
                                             options:UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                              //Animation
                                              btn1.alpha = 1.0;
                                              btn2.alpha = 1.0;
                                          }
                                          completion:^(BOOL finished){
                                              //Completion
                                          }];
                     }];

}

- (void) btn1Pressed
{
    NSLog(@"test");
}

- (void) btn2Pressed
{
    RMDebugView *rmDebugView = [[RMDebugView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_FRAME.size.width, SCREEN_FRAME.size.height)];
    [self.view addSubview:rmDebugView];
}
@end
