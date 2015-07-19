//
//  LMViewController.m
//  LMDropdownViewDemo
//
//  Created by LMinh on 16/07/2014.
//  Copyright (c) 2014 LMinh. All rights reserved.
//

#import "LMViewController.h"
#import <MapKit/MapKit.h>
#import "LMDropdownView.h"
#import "LMMenuCell.h"

@interface LMViewController () <UITableViewDataSource, UITableViewDelegate, LMDropdownViewDelegate>

@property (strong, nonatomic) NSArray *mapTypes;
@property (assign, nonatomic) NSInteger currentMapTypeIndex;

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UITableView *menuTableView;

@property (strong, nonatomic) LMDropdownView *dropdownView;

@end

@implementation LMViewController

#pragma mark - VIEW LIFECYCLE

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapTypes = @[@"Standard", @"Satellite", @"Hybrid"];
    self.currentMapTypeIndex = 0;
    [self.menuTableView setFrame:CGRectMake(0,
                                            0,
                                            CGRectGetWidth(self.view.bounds),
                                            MIN(CGRectGetHeight(self.view.bounds)/2, self.mapTypes.count * 50))];
}


#pragma mark - DROPDOWN VIEW

- (void)showDropDownView
{
    // Init dropdown view
    if (!self.dropdownView) {
        self.dropdownView = [LMDropdownView dropdownView];
        self.dropdownView.delegate = self;
        
        // Customize Dropdown style
        self.dropdownView.closedScale = 0.85;
        self.dropdownView.blurRadius = 5;
        self.dropdownView.blackMaskAlpha = 0.5;
        self.dropdownView.animationDuration = 0.5;
        self.dropdownView.animationBounceHeight = 20;
        self.dropdownView.contentBackgroundColor = [UIColor colorWithRed:40.0/255 green:196.0/255 blue:80.0/255 alpha:1];
    }
    
    // Show/hide dropdown view
    if ([self.dropdownView isOpen]) {
        [self.dropdownView hide];
    }
    else {
        [self.dropdownView showFromNavigationController:self.navigationController withContentView:self.menuTableView];
    }
}

- (void)dropdownViewWillShow:(LMDropdownView *)dropdownView
{
    NSLog(@"Dropdown view will show");
}

- (void)dropdownViewDidShow:(LMDropdownView *)dropdownView
{
    NSLog(@"Dropdown view did show");
}

- (void)dropdownViewWillHide:(LMDropdownView *)dropdownView
{
    NSLog(@"Dropdown view will hide");
}

- (void)dropdownViewDidHide:(LMDropdownView *)dropdownView
{
    NSLog(@"Dropdown view did hide");
    
    switch (self.currentMapTypeIndex) {
        case 0:
            self.mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            self.mapView.mapType = MKMapTypeSatellite;
            break;
        case 2:
            self.mapView.mapType = MKMapTypeHybrid;
            break;
        default:
            break;
    }
}


#pragma mark - TABLE VIEW

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mapTypes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LMMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell"];
    if (!cell) {
        cell = [[LMMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"menuCell"];
    }
    
    cell.menuItemLabel.text = [self.mapTypes objectAtIndex:indexPath.row];
    cell.selectedMarkView.hidden = (indexPath.row != self.currentMapTypeIndex);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    self.currentMapTypeIndex = indexPath.row;
    
    [self.dropdownView hide];
}


#pragma mark - EVENTS

- (IBAction)titleButtonTapped:(id)sender
{
    [self.menuTableView reloadData];
    
    [self showDropDownView];
}

@end
