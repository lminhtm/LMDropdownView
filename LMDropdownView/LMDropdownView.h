//
//  LMDropdownView.h
//  LMDropdownView
//
//  Created by LMinh on 16/11/2014.
//  Copyright (c) 2014 LMinh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    LMDropdownViewStateWillOpen,
    LMDropdownViewStateDidOpen,
    LMDropdownViewStateWillClose,
    LMDropdownViewStateDidClose,
} LMDropdownViewState;

@protocol LMDropdownViewDelegate;

@interface LMDropdownView : NSObject

@property (nonatomic, assign) CGFloat closedScale;
@property (nonatomic, assign) CGFloat blurRadius;
@property (nonatomic, assign) CGFloat blackMaskAlpha;
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, assign) CGFloat animationBounceHeight;
@property (nonatomic, strong) UIColor *contentBackgroundColor;

@property (nonatomic, assign, readonly) LMDropdownViewState currentState;
@property (nonatomic, assign, readonly) BOOL isOpen;

@property (nonatomic, weak) id<LMDropdownViewDelegate> delegate;
@property (nonatomic, copy) dispatch_block_t didShowHandler;
@property (nonatomic, copy) dispatch_block_t didHideHandler;

+ (instancetype)dropdownView;

- (void)showInView:(UIView *)containerView withContentView:(UIView *)contentView atOrigin:(CGPoint)origin;

- (void)showFromNavigationController:(UINavigationController *)navigationController withContentView:(UIView *)contentView;

- (void)hide;

@end

@protocol LMDropdownViewDelegate <NSObject>

@optional
- (void)dropdownViewWillShow:(LMDropdownView *)dropdownView;
- (void)dropdownViewDidShow:(LMDropdownView *)dropdownView;
- (void)dropdownViewWillHide:(LMDropdownView *)dropdownView;
- (void)dropdownViewDidHide:(LMDropdownView *)dropdownView;

@end
