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

@interface LMViewController () <UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, LMDropdownViewDelegate>

@property (strong, nonatomic) NSArray *mapTypes;
@property (assign, nonatomic) NSInteger currentMapTypeIndex;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UIButton *dropPinButton;
@property (weak, nonatomic) IBOutlet UIButton *removeAllPinsButton;

@property (strong, nonatomic) IBOutlet UITableView *menuTableView;
@property (strong, nonatomic) IBOutlet UIView *moreBottomView;

@property (strong, nonatomic) LMDropdownView *dropdownView;

@end

@implementation LMViewController

#pragma mark - VIEW LIFECYCLE

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapTypes = @[@"Standard", @"Satellite", @"Hybrid"];
    self.currentMapTypeIndex = 0;
    
    self.dropPinButton.layer.cornerRadius = 5;
    self.removeAllPinsButton.layer.cornerRadius = 5;
    self.moreButton.layer.cornerRadius = 5;
    self.moreButton.layer.shadowOffset = CGSizeZero;
    self.moreButton.layer.shadowOpacity = 0.5;
    self.moreButton.layer.shadowRadius = 1.0;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.menuTableView.frame = CGRectMake(CGRectGetMinX(self.menuTableView.frame),
                                          CGRectGetMinY(self.menuTableView.frame),
                                          CGRectGetWidth(self.view.bounds),
                                          MIN(CGRectGetHeight(self.view.bounds)/2, self.mapTypes.count * 50));
    self.moreBottomView.frame = CGRectMake(CGRectGetMinX(self.moreBottomView.frame),
                                           CGRectGetMinY(self.moreBottomView.frame),
                                           CGRectGetWidth(self.view.bounds),
                                           CGRectGetHeight(self.moreBottomView.bounds));
}


#pragma mark - DROPDOWN VIEW

- (void)showDropDownViewFromDirection:(LMDropdownViewDirection)direction
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
    }
    self.dropdownView.direction = direction;
    
    // Show/hide dropdown view
    if ([self.dropdownView isOpen]) {
        [self.dropdownView hide];
    }
    else {
        switch (direction) {
            case LMDropdownViewDirectionTop: {
                self.dropdownView.contentBackgroundColor = [UIColor colorWithRed:40.0/255 green:196.0/255 blue:80.0/255 alpha:1];
                
                [self.dropdownView showFromNavigationController:self.navigationController
                                                withContentView:self.menuTableView];
                break;
            }
            case LMDropdownViewDirectionBottom: {
                self.dropdownView.contentBackgroundColor = [UIColor whiteColor];
                
                CGPoint origin = CGPointMake(0, CGRectGetHeight(self.navigationController.view.bounds) - CGRectGetHeight(self.moreBottomView.bounds));
                [self.dropdownView showInView:self.navigationController.view
                              withContentView:self.moreBottomView
                                     atOrigin:origin];
                break;
            }
            default:
                break;
        }
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


#pragma mark - MENU TABLE VIEW

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


#pragma mark - MAP VIEW DELEGATE

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *pinAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"current"];
    pinAnnotationView.animatesDrop = YES;
    pinAnnotationView.canShowCallout = YES;
    pinAnnotationView.pinColor = MKPinAnnotationColorGreen;
    return pinAnnotationView;
}


#pragma mark - EVENTS

- (IBAction)titleButtonTapped:(id)sender
{
    [self.menuTableView reloadData];
    
    [self showDropDownViewFromDirection:LMDropdownViewDirectionTop];
}

- (IBAction)moreButtonTapped:(id)sender
{
    [self showDropDownViewFromDirection:LMDropdownViewDirectionBottom];
}

- (IBAction)removeAllPinsButtonTapped:(id)sender
{
    [self.dropdownView hide];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.dropdownView.animationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.mapView removeAnnotations:self.mapView.annotations];
    });
}

- (IBAction)dropPinButtonTapped:(id)sender
{
    [self.dropdownView hide];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.dropdownView.animationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        point.coordinate = [self.mapView convertPoint:self.mapView.center toCoordinateFromView:self.mapView];
        point.title = @"LMDropdownView";
        [self.mapView addAnnotation:point];
    });
}

@end
