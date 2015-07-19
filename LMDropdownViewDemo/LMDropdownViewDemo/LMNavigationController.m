//
//  LMNavigationController.m
//  LMDropdownViewDemo
//
//  Created by LMinh on 7/19/15.
//  Copyright (c) 2015 LMinh. All rights reserved.
//

#import "LMNavigationController.h"

@implementation LMNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationBar setTranslucent:NO];
    [self.navigationBar setBarTintColor:[UIColor colorWithRed:11.0/255 green:150.0/255 blue:246.0/255 alpha:1]];
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bounds.size.height - 2, self.navigationBar.bounds.size.width, 2)];
    lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    lineView.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.2];
    [self.navigationBar addSubview:lineView];
    [self.navigationBar bringSubviewToFront:lineView];
}

@end
