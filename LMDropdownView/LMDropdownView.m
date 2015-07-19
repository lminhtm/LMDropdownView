//
//  LMDropdownView.m
//  LMDropdownView
//
//  Created by LMinh on 16/11/2014.
//  Copyright (c) 2014 LMinh. All rights reserved.
//

#import "LMDropdownView.h"
#import "UIImage+LMExtension.h"

#define kDefaultClosedScale                 0.85
#define kDefaultBlurRadius                  5
#define kDefaultBlackMaskAlpha              0.5
#define kDefaultAnimationDuration           0.5
#define kDefaultAnimationBounceHeight       20
#define kDefaultAnimationBounceScale        0.05

@interface LMDropdownView ()
{
    CGPoint originContentCenter;
    CGPoint desContentCenter;
}
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIView *contentWrapperView;
@property (nonatomic, strong) UIImageView *containerWrapperView;
@property (nonatomic, strong) UIButton *backgroundButton;

@end

@implementation LMDropdownView

#pragma mark - INIT

+ (instancetype)dropdownView
{
    return [[LMDropdownView alloc] init];
}

- (id)init
{
    self = [super init];
    if (self) {
        _closedScale = kDefaultClosedScale;
        _blurRadius = kDefaultBlurRadius;
        _blackMaskAlpha = kDefaultBlackMaskAlpha;
        _animationDuration = kDefaultAnimationDuration;
        _animationBounceHeight = kDefaultAnimationBounceHeight;
        _currentState = LMDropdownViewStateDidClose;
    }
    return self;
}


#pragma mark - PUBLIC METHOD

- (BOOL)isOpen
{
    return (_currentState == LMDropdownViewStateDidOpen);
}

- (void)showInView:(UIView *)containerView withContentView:(UIView *)contentView atOrigin:(CGPoint)origin
{
    if (_currentState != LMDropdownViewStateDidClose) {
        return;
    }
    
    // Start showing
    _currentState = LMDropdownViewStateWillOpen;
    if (self.delegate && [self.delegate respondsToSelector:@selector(dropdownViewWillShow:)]) {
        [self.delegate dropdownViewWillShow:self];
    }
    
    // Setup menu in view
    [self setupContentView:contentView inView:containerView atOrigin:origin];
    
    // Animate menu view controller
    [self addContentAnimationForState:_currentState];
    
    // Animate content view controller
    if (self.closedScale < 1) {
        [self addContainerAnimationForState:_currentState];
    }
    
    // Finish showing
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.animationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        _currentState = LMDropdownViewStateDidOpen;
        if (self.delegate && [self.delegate respondsToSelector:@selector(dropdownViewDidShow:)]) {
            [self.delegate dropdownViewDidShow:self];
        }
        if (self.didShowHandler) {
            self.didShowHandler();
        }
    });
}

- (void)showInView:(UIView *)containerView withContentView:(UIView *)contentView atView:(UIView *)atView
{
    CGPoint origin = CGPointMake(CGRectGetMinX(atView.frame), CGRectGetMaxY(atView.frame));
    [self showInView:containerView withContentView:contentView atOrigin:origin];
}

- (void)showFromNavigationController:(UINavigationController *)navigationController withContentView:(UIView *)contentView
{
    [self showInView:navigationController.visibleViewController.view withContentView:contentView atOrigin:CGPointZero];
}

- (void)hide
{
    if (_currentState != LMDropdownViewStateDidOpen) {
        return;
    }
    
    // Start hiding
    _currentState = LMDropdownViewStateWillClose;
    if (self.delegate && [self.delegate respondsToSelector:@selector(dropdownViewWillHide:)]) {
        [self.delegate dropdownViewWillHide:self];
    }
    
    // Animate menu view controller
    [self addContentAnimationForState:_currentState];
    
    // Animate content view controller
    if (self.closedScale < 1) {
        [self addContainerAnimationForState:_currentState];
    }
    
    // Finish hiding
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.animationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        _currentState = LMDropdownViewStateDidClose;
        if (self.delegate && [self.delegate respondsToSelector:@selector(dropdownViewDidHide:)]) {
            [self.delegate dropdownViewDidHide:self];
        }
        if (self.didHideHandler) {
            self.didHideHandler();
        }
        
        [UIView animateWithDuration:0.2 animations:^{
            self.mainView.alpha = 0;
        } completion:^(BOOL finished) {
            self.mainView.alpha = 1;
            [self.contentWrapperView removeFromSuperview];
            [self.backgroundButton removeFromSuperview];
            [self.containerWrapperView removeFromSuperview];
            [self.mainView removeFromSuperview];
        }];
    });
}


#pragma mark - PRIVATE

- (void)setupContentView:(UIView *)contentView inView:(UIView *)containerView atOrigin:(CGPoint)origin
{
    /*!
     *  Prepare container captured image
     */
    CGSize containerSize = [containerView bounds].size;
    CGFloat scale = (3 - 2 * self.closedScale);
    CGSize capturedSize = CGSizeMake(containerSize.width * scale, containerSize.height * scale);
    UIImage *capturedImage = [UIImage imageFromView:containerView withSize:capturedSize];
    UIImage *blurredCapturedImage = [capturedImage blurredImageWithRadius:self.blurRadius iterations:5 tintColor:[UIColor clearColor]];
    
    /*!
     *  Main View
     */
    if (!self.mainView) {
        self.mainView = [[UIScrollView alloc] init];
        self.mainView.backgroundColor = [UIColor blackColor];
    }
    self.mainView.frame = containerView.bounds;
    [containerView addSubview:self.mainView];
    
    /*!
     *  Container Wrapper View
     */
    if (!self.containerWrapperView) {
        self.containerWrapperView = [[UIImageView alloc] init];
        self.containerWrapperView.backgroundColor = [UIColor blackColor];
        self.containerWrapperView.contentMode = UIViewContentModeCenter;
    }
    self.containerWrapperView.image = blurredCapturedImage;
    self.containerWrapperView.bounds = CGRectMake(0,
                                                  0,
                                                  capturedSize.width,
                                                  capturedSize.height);
    self.containerWrapperView.center = self.mainView.center;
    [self.mainView addSubview:self.containerWrapperView];
    
    /*!
     *  Background Button
     */
    if (!self.backgroundButton) {
        self.backgroundButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.backgroundButton addTarget:self action:@selector(backgroundButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    UIColor *maskColor = [[UIColor blackColor] colorWithAlphaComponent:self.blackMaskAlpha];
    self.backgroundButton.backgroundColor = maskColor;
    self.backgroundButton.frame = self.mainView.bounds;
    [self.mainView addSubview:self.backgroundButton];
    
    /*!
     *  Content Wrapper View
     */
    if (!self.contentWrapperView) {
        self.contentWrapperView = [[UIView alloc] init];
    }
    self.contentWrapperView.backgroundColor = self.contentBackgroundColor;
    
    contentView.frame = CGRectMake(0,
                                   self.animationBounceHeight,
                                   CGRectGetWidth(contentView.frame),
                                   CGRectGetHeight(contentView.frame));
    [self.contentWrapperView addSubview:contentView];
    
    CGFloat contentWrapperViewHeight = CGRectGetHeight(contentView.frame) + self.animationBounceHeight;
    self.contentWrapperView.frame = CGRectMake(origin.x,
                                               origin.y - contentWrapperViewHeight,
                                               CGRectGetWidth(contentView.frame),
                                               contentWrapperViewHeight);
    [self.mainView addSubview:self.contentWrapperView];
    
    originContentCenter = CGPointMake(CGRectGetMidX(self.contentWrapperView.frame), CGRectGetMidY(self.contentWrapperView.frame));
    desContentCenter = CGPointMake(CGRectGetMidX(self.contentWrapperView.frame), origin.y + contentWrapperViewHeight/2 - self.animationBounceHeight);
}

- (void)backgroundButtonTapped:(id)sender
{
    [self hide];
}

- (void)setClosedScale:(CGFloat)closedScale
{
    _closedScale = MIN(closedScale, 1);
}


#pragma mark - KEYFRAME ANIMATION

- (void)addContentAnimationForState:(LMDropdownViewState)state
{
    CAKeyframeAnimation *contentBounceAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    contentBounceAnim.duration = self.animationDuration;
    contentBounceAnim.delegate = self;
    contentBounceAnim.removedOnCompletion = NO;
    contentBounceAnim.fillMode = kCAFillModeForwards;
    contentBounceAnim.values = [self contentPositionValuesForState:state];
    contentBounceAnim.timingFunctions = [self contentTimingFunctionsForState:state];
    contentBounceAnim.keyTimes = [self contentKeyTimesForState:state];
    
    [self.contentWrapperView.layer addAnimation:contentBounceAnim forKey:nil];
    [self.contentWrapperView.layer setValue:[contentBounceAnim.values lastObject] forKeyPath:@"position"];
}

- (void)addContainerAnimationForState:(LMDropdownViewState)state
{
    CAKeyframeAnimation *containerScaleAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    containerScaleAnim.duration = self.animationDuration;
    containerScaleAnim.delegate = self;
    containerScaleAnim.removedOnCompletion = NO;
    containerScaleAnim.fillMode = kCAFillModeForwards;
    containerScaleAnim.values = [self containerTransformValuesForState:state];
    containerScaleAnim.timingFunctions = [self containerTimingFunctionsForState:state];
    containerScaleAnim.keyTimes = [self containerKeyTimesForState:state];
    
    [self.containerWrapperView.layer addAnimation:containerScaleAnim forKey:nil];
    [self.containerWrapperView.layer setValue:[containerScaleAnim.values lastObject] forKeyPath:@"transform"];
}


#pragma mark - PROPERTIES FOR KEYFRAME ANIMATION

- (NSArray *)contentPositionValuesForState:(LMDropdownViewState)state
{
    CGFloat positionX = self.contentWrapperView.layer.position.x;
    CGFloat positionY = self.contentWrapperView.layer.position.y;
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
    [values addObject:[NSValue valueWithCGPoint:self.contentWrapperView.layer.position]];
    
    if (state == LMDropdownViewStateWillOpen || state == LMDropdownViewStateDidOpen)
    {
        [values addObject:[NSValue valueWithCGPoint:CGPointMake(positionX, desContentCenter.y + self.animationBounceHeight)]];
        [values addObject:[NSValue valueWithCGPoint:CGPointMake(positionX, desContentCenter.y)]];
    }
    else
    {
        [values addObject:[NSValue valueWithCGPoint:CGPointMake(positionX, positionY + self.animationBounceHeight)]];
        [values addObject:[NSValue valueWithCGPoint:CGPointMake(positionX, originContentCenter.y)]];
    }
    
    return values;
}

- (NSArray *)contentKeyTimesForState:(LMDropdownViewState)state
{
    NSMutableArray *keyTimes = [[NSMutableArray alloc] init];
    [keyTimes addObject:[NSNumber numberWithFloat:0]];
    [keyTimes addObject:[NSNumber numberWithFloat:0.5]];
    [keyTimes addObject:[NSNumber numberWithFloat:1]];
    return keyTimes;
}

- (NSArray *)contentTimingFunctionsForState:(LMDropdownViewState)state
{
    NSMutableArray *timingFunctions = [[NSMutableArray alloc] init];
    [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    return timingFunctions;
}

- (NSArray *)containerTransformValuesForState:(LMDropdownViewState)state
{
    CATransform3D transform = self.containerWrapperView.layer.transform;
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
    [values addObject:[NSValue valueWithCATransform3D:transform]];
    
    if (state == LMDropdownViewStateWillOpen || state == LMDropdownViewStateDidOpen)
    {
        CGFloat scale = self.closedScale - kDefaultAnimationBounceScale;
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DScale(transform, scale, scale, scale)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DScale(transform, self.closedScale, self.closedScale, self.closedScale)]];
    }
    else
    {
        CGFloat scale = 1 - kDefaultAnimationBounceScale;
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DScale(transform, scale, scale, scale)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
    }
    
    return values;
}

- (NSArray *)containerKeyTimesForState:(LMDropdownViewState)state
{
    NSMutableArray *keyTimes = [[NSMutableArray alloc] init];
    [keyTimes addObject:[NSNumber numberWithFloat:0]];
    [keyTimes addObject:[NSNumber numberWithFloat:0.5]];
    [keyTimes addObject:[NSNumber numberWithFloat:1]];
    return keyTimes;
}

- (NSArray *)containerTimingFunctionsForState:(LMDropdownViewState)state
{
    NSMutableArray *timingFunctions = [[NSMutableArray alloc] init];
    [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    return timingFunctions;
}

@end
