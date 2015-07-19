//
//  LMDropdownView.h
//  LMDropdownView
//
//  Created by LMinh on 16/11/2014.
//  Copyright (c) 2014 LMinh. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 Dropdown view state.
 */
typedef enum : NSUInteger {
    LMDropdownViewStateWillOpen,
    LMDropdownViewStateDidOpen,
    LMDropdownViewStateWillClose,
    LMDropdownViewStateDidClose,
} LMDropdownViewState;

@protocol LMDropdownViewDelegate;

/*!
 *  A simple dropdown view inspired by Tappy.
 */
@interface LMDropdownView : NSObject

/*!
 *  The closed scale of container view.
 *  Set it to 1 to disable container scale animation.
 */
@property (nonatomic, assign) CGFloat closedScale;

/*!
 *  The blur radius of container view.
 */
@property (nonatomic, assign) CGFloat blurRadius;

/*!
 *  The alpha of black mask button.
 */
@property (nonatomic, assign) CGFloat blackMaskAlpha;

/*!
 *  The animation duration.
 */
@property (nonatomic, assign) CGFloat animationDuration;

/*!
 *  The animation bounce height of content view.
 */
@property (nonatomic, assign) CGFloat animationBounceHeight;

/*!
 *  The background color of content view.
 */
@property (nonatomic, strong) UIColor *contentBackgroundColor;

/*!
 *  The current dropdown view state.
 */
@property (nonatomic, assign, readonly) LMDropdownViewState currentState;

/*!
 *  A boolean indicates whether dropdown is open.
 */
@property (nonatomic, assign, readonly) BOOL isOpen;

/*!
 *  The dropdown view delegate.
 */
@property (nonatomic, weak) id<LMDropdownViewDelegate> delegate;

/**
 *  The callback when dropdown view did show in the container view.
 */
@property (nonatomic, copy) dispatch_block_t didShowHandler;

/**
 *  The callback when dropdown view did hide in the container view.
 */
@property (nonatomic, copy) dispatch_block_t didHideHandler;

/*!
 *  Convenience constructor for LMDropdownView.
 */
+ (instancetype)dropdownView;

/*!
 *  Show dropdown view.
 *
 *  @param containerView The containerView to contain.
 *  @param contentView   The contentView to show.
 *  @param origin        The origin point in the container coordinator system.
 */
- (void)showInView:(UIView *)containerView withContentView:(UIView *)contentView atOrigin:(CGPoint)origin;

/*!
 *  Show dropdown view from navigation controller.
 *
 *  @param navigationController The navigation controller to show from.
 *  @param contentView          The contentView to show.
 */
- (void)showFromNavigationController:(UINavigationController *)navigationController withContentView:(UIView *)contentView;

/*!
 *  Hide dropdown view.
 */
- (void)hide;

@end

/*!
 *  Dropdown view delegate.
 */
@protocol LMDropdownViewDelegate <NSObject>

@optional
- (void)dropdownViewWillShow:(LMDropdownView *)dropdownView;
- (void)dropdownViewDidShow:(LMDropdownView *)dropdownView;
- (void)dropdownViewWillHide:(LMDropdownView *)dropdownView;
- (void)dropdownViewDidHide:(LMDropdownView *)dropdownView;

@end
