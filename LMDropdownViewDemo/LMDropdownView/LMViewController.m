//
//  LMViewController.m
//  LMDropdownView
//
//  Created by LMinh on 16/07/2014.
//  Copyright (c) Năm 2014 LMinh. All rights reserved.
//

#import "LMViewController.h"
#import <MapKit/MapKit.h>
#import "LMDropdownView.h"
#import "LMDefaultMenuItemCell.h"

@interface LMViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *mapTypes;
@property (assign, nonatomic) NSInteger currentMapTypeIndex;

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UITableView *menuTableView;
@property (strong, nonatomic) IBOutlet UIButton *mapTypeButton;

@property (strong, nonatomic) LMDropdownView *dropdownView;

@end

@implementation LMViewController

#pragma mark - VIEW LIFECYCLE

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapTypes = @[@"Standard", @"Satellite", @"Hybrid"];
    self.currentMapTypeIndex = 0;
    
    self.navigationItem.titleView = self.mapTypeButton;
}


#pragma mark - DROPDOWN VIEW

- (void)setCurrentMapTypeIndex:(NSInteger)currentMapTypeIndex
{
    _currentMapTypeIndex = currentMapTypeIndex;
    switch (_currentMapTypeIndex) {
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

- (IBAction)mapTypeButtonTapped:(id)sender
{
    [self.menuTableView setFrame:CGRectMake(self.menuTableView.frame.origin.x,
                                            self.menuTableView.frame.origin.y,
                                            self.view.bounds.size.width,
                                            MIN(self.view.bounds.size.height / 2, self.mapTypes.count * 50))];
    [self.menuTableView reloadData];
    
    // Init dropdown view
    if (!self.dropdownView)
    {
        self.dropdownView = [[LMDropdownView alloc] init];
        self.dropdownView.menuContentView = self.menuTableView;
        self.dropdownView.menuBackgroundColor = [UIColor colorWithRed:40.0/255 green:196.0/255 blue:80.0/255 alpha:1];
    }
    
    // Show/hide dropdown view
    if ([self.dropdownView isOpen])
    {
        [self.dropdownView hide];
    }
    else
    {
        [self.dropdownView showInView:self.view withFrame:self.view.bounds];
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
    LMDefaultMenuItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"defaultMenuItemCell"];
    if (!cell) {
        NSArray *xibs = [[NSBundle mainBundle] loadNibNamed:@"LMDefaultMenuItemCell" owner:self options:nil];
        cell = [xibs firstObject];
    }
    
    // Set data for cell
    NSString *mapType = mapType = [self.mapTypes objectAtIndex:indexPath.row];
    cell.menuItemLabel.text = mapType;
    cell.selectedMarkView.hidden = (indexPath.row != self.currentMapTypeIndex);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.menuTableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [self.dropdownView hide];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.dropdownView.animationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.currentMapTypeIndex = indexPath.row;
    });
}

@end
