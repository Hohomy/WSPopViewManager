//
//  WSPopViewHelper.m
//  WSY
//
//  Created by HMY on 2021/9/14.
//  Copyright © 2021 wangshangyuan. All rights reserved.
//

#import "WSPopViewHelper.h"
#import "WSPopViewManager.h"
#import "UIView+Frame.h"
#import "UIView+QKFrame.h"
#import "UIColorAdditions.h"

#define WSKeyWindow [UIApplication sharedApplication].keyWindow

@interface WSPopViewHelper()

@property (nonatomic, assign) BOOL isAnimating;  // 是否正在动画中

@property (nonatomic, assign) AnimationTarget animationTarget;  // 默认unset

@property (nonatomic, strong) UIControl *mask;

@property (nonatomic, assign) CGFloat spring;   // 动画弹性=1

@property (nonatomic, assign) CGFloat initVelocity;   // 动画初始速度=0

@property (nonatomic, assign) CGRect currentFrame;

@property (nonatomic, assign) CGFloat targetViewShadowOpacity;   // =0

@property (nonatomic, assign) NSTimeInterval delayHideTime;

@end

@implementation WSPopViewHelper

- (void)setIsLockTargetView:(BOOL)isLockTargetView {
    if (isLockTargetView) {
        _isLockTargetView = isLockTargetView;
    } else {
        _isLockTargetView = nil;
    }
}

- (void)setIsAnimatedForShadow:(BOOL)isAnimatedForShadow {
    _isAnimatedForShadow = isAnimatedForShadow;
    _targetViewShadowOpacity = _targetView.layer.shadowOpacity;
    _targetView.layer.shadowOpacity = 0;
}

- (void)setAnimationStyle:(AnimationStyle)animationStyle {
    _animationStyle = animationStyle;
    if (_animationStyle == AnimationNormal) {
        _spring = 1;
        _initVelocity = 0;
        _showAnimateDuration = 0.5;
        _hideAnimateDuration = 0.5;
    } else if (_animationStyle == AnimationSpring) {
        _spring = 0.7;
        _initVelocity = 0;
        _showAnimateDuration = 0.5;
        _hideAnimateDuration = 0.5;
    }
}

- (instancetype)initWithSuperView:(UIView *__nullable)superView targetView:(UIView *)targetView viewPopDirection:(ViewPopDirection)viewPopDirection maskStatus:(MaskStatus)maskStatus {
    self = [super init];
    if (self) {
        self.targetView = targetView;
        self.maskStatus = maskStatus;
        if (superView) {
            self.superView = superView;
        } else {
            self.superView = WSKeyWindow;
        }
        self.viewPopDirection = viewPopDirection;
        
        [self initValue];
        
        [self initMask:maskStatus];

        self.targetView.hidden = true;

        if (superView == nil) {
            [[WSPopViewManager shareinstance] addPopViewHelper:self];
        }
    }
    return self;
}

// 初始化设置默认值
- (void)initValue {
    _spring = 1;
    _initVelocity = 0;
    _animationTarget = AnimationTargetUnset;
    _targetViewShadowOpacity = 0;
    _showAnimateDuration = 0.25;
    _hideAnimateDuration = 0.25;
    _showAnimateMinDuration = 0.25;
    _hideAnimateMinDuration = 0.25;
    _showAnimateSpeed = 1500;
    _hideAnimateSpeed = 1500;
    _alpha = @[@1, @1, @1];
    _beginOrigin = CGPointZero;
    _endOrigin = CGPointZero;
    _showOrigin = CGPointZero;
    _maskAlpha = 1;
    _canForceHide = true;
}

- (void)setPopViewDirection {
    switch (_viewPopDirection) {
        case ViewPopDirectionAbove:
        {
            _beginOrigin.x = 0;
            // 隐藏在上面
            _beginOrigin.y = -_targetView.frame.size.height;
            
            _showOrigin.x = 0;
            _showOrigin.y = 0;
            
            if (@available(iOS 11.0, *)) {
                _showOrigin.y += _superView.safeAreaInsets.top;
            }
            
            _endOrigin = _beginOrigin;
        }
            break;
        case ViewPopDirectionBelow: case ViewPopDirectionBelowWithSafeArea:
        {
            _beginOrigin.x = 0;
            // 隐藏在上面
            _beginOrigin.y = _superView.qk_bottom;
            
            _showOrigin.x = 0;
            _showOrigin.y = _superView.height - _targetView.height;
            
            if (@available(iOS 11.0, *)) {
                _showOrigin.y -= _superView.safeAreaInsets.bottom;
            }
            
            _endOrigin = _beginOrigin;
            
            _showAnimateDuration = (double)_targetView.height / (double)_showAnimateSpeed;
            _hideAnimateDuration = (double)_targetView.height / (double)_hideAnimateSpeed;
        }
            break;
        case ViewPopDirectionBelowToCenter:
        {
            _beginOrigin.x = _superView.width/2 - _targetView.width/2;
            //隐藏在下面
            _beginOrigin.y = _superView.qk_bottom;
            
            _showOrigin.x = _superView.width/2 - _targetView.width/2;
            _showOrigin.y = _superView.height/2 - _targetView.height/2;
                        
            _endOrigin = _beginOrigin;
            
            _showAnimateDuration = (double)_targetView.height / (double)_showAnimateSpeed;
            _hideAnimateDuration = (double)_targetView.height / (double)_hideAnimateSpeed;
        }
            break;
        case ViewPopDirectionCenter:
        {
            _beginOrigin.x = _superView.qk_bottom;
            _beginOrigin.y = _superView.height/2 - _targetView.height/2;
            
            _showOrigin.x = _superView.width/2 - _targetView.width/2;
            _showOrigin.y = _superView.height/2 - _targetView.height/2;
            
            _endOrigin.x = -_superView.width;
            _endOrigin.y = _superView.height/2 - _targetView.height/2;
        }
            break;
        case ViewPopDirectionOnlyShowFullScreen:
        {
            _beginOrigin = CGPointMake(0, 0);
            _showOrigin = _beginOrigin;
            _endOrigin = _beginOrigin;
        }
            break;
        case ViewPopDirectionFade:
        {
            _alpha = @[@0, @1, @0];
            _beginOrigin.x = _superView.width/2 - _targetView.width/2;
            _beginOrigin.y = _superView.height/2 - _targetView.height/2;
            _showOrigin = _beginOrigin;
            _endOrigin = _beginOrigin;
        }
            break;
        case ViewPopDirectionBelowWithPadding:
        {
            _beginOrigin.x = _superView.width/2 - _targetView.width/2;
            _beginOrigin.y = _superView.qk_bottom;
            
            _showOrigin.x = _beginOrigin.x;
            _showOrigin.y = _superView.height - _targetView.height - _beginOrigin.x;
            
            if (@available(iOS 11.0, *)) {
                _showOrigin.y -= _superView.safeAreaInsets.bottom;
            }
            
            _endOrigin = _beginOrigin;
            
            _showAnimateDuration = (double)_targetView.height / (double)_showAnimateSpeed;
            _hideAnimateDuration = (double)_targetView.height / (double)_hideAnimateSpeed;
        }
            break;
        case ViewPopDirectionNone:
            break;
        default:
            break;
    }
    
}

- (void)setupUI {
    CGRect rect = CGRectMake(_beginOrigin.x, _beginOrigin.y, _targetView.width, _targetView.height);
    _targetView.frame = rect;
    
    _targetView.alpha = _alpha[0].integerValue;
}

// 初始化半透明遮罩视图
- (void)initMask:(MaskStatus)maskStatus {
    if (maskStatus == MaskHidden) {
        return;
    }
    
    _mask = [[UIControl alloc] initWithFrame:_superView.bounds];
    _mask.alpha = 0;
    
    BOOL isTransparent = maskStatus == MaskTransparent || maskStatus == MaskTransparentAndDisable;
    _mask.backgroundColor = isTransparent ? [UIColor clearColor] : [UIColor colorWithHex:(@"#000000") andAlpha:(0.3)];
    [_mask addTarget:self action:@selector(clickMask) forControlEvents:UIControlEventTouchUpInside];
    
    [_superView addSubview:_mask];
    
    if (@available(iOS 11.0, *)) {
        if (_viewPopDirection == ViewPopDirectionBelowWithSafeArea) {
            // 底部弹出的时候，在安全区域加上白色的填充
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor whiteColor];
            CGFloat height =  _superView.safeAreaInsets.bottom + 1;
            view.frame = CGRectMake(0, _superView.height - height, _superView.width, height);
            [_mask addSubview:view];  // 加在遮罩上，方便每次消失被移除
        }
    }
   
}

// 点击遮罩
- (void)clickMask {
    if (_mask) {
        if ([self.delegate respondsToSelector:@selector(popViewHelperDidClickMask:popViewHelper:)]) {
            [self.delegate popViewHelperDidClickMask:_mask popViewHelper:self];
        }
    }
    
    BOOL clickEnable = _maskStatus != MaskClickDisable && _maskStatus != MaskTransparentAndDisable;
    if (clickEnable) {
        [self hidePoppingView:true];
    }
}

- (void)cancelDelayHideIfNeeded {
    if (_delayHideTime == 0) {
        return;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    _delayHideTime = 0;
}

- (void)showPoppingViewInQueue:(NSInteger)priority {
    self.priority = priority;
    [[WSPopViewManager shareinstance] enQueue:self];
}

- (void)showPoppingView:(BOOL)animated {
    _animationTarget = AnimationTargetShow;
    
    if (_isAnimating || _isShow) {
        return;
    }
    [self setPopViewDirection];
    
    [self setupUI];
    
    if (_mask) {
        [_superView bringSubviewToFront:_mask];
    }
    [_superView addSubview:_targetView];
    [_superView bringSubviewToFront:_targetView];

    _targetView.hidden = false;
    _isShow = true;
    _isAnimating = true;
    
    if (_isAnimatedForShadow) {
        self.targetView.layer.shadowOpacity = self.targetViewShadowOpacity;
    }
    
    if ([self.delegate respondsToSelector:@selector(popViewHelperWillShowPoppingView:popViewHelper:)]) {
        [self.delegate popViewHelperWillShowPoppingView:_targetView popViewHelper:self];
    }
    
    if (animated) {
        [UIView animateWithDuration:MAX(_showAnimateDuration, _showAnimateMinDuration) delay:0 usingSpringWithDamping:_spring initialSpringVelocity:_initVelocity options:0 animations:^{
            [self showAction];
        } completion:^(BOOL finished) {
            [self showCompletionAction];

        }];
    } else {
        [self showAction];
        [self showCompletionAction];
    }
}

- (void)showAction {
    self.mask.alpha = self.maskAlpha;
    CGRect tmpRect = CGRectMake(self.showOrigin.x, self.showOrigin.y, self.targetView.width, self.targetView.height);
    self.targetView.frame = tmpRect;
    self.targetView.alpha = self.alpha[1].integerValue;
    if ([self.delegate respondsToSelector:@selector(popViewHelperShowAnimationBlock:)]) {
        [self.delegate popViewHelperShowAnimationBlock:self.targetView];
    }
}

- (void)showCompletionAction {
    self.isAnimating = false;
    if ([self.delegate respondsToSelector:@selector(popViewHelperDidShowPoppingView:popViewHelper:)]) {
        [self.delegate popViewHelperDidShowPoppingView:self.targetView popViewHelper:self];
    }
    
    if (self.animationTarget == AnimationTargetHide) {
        [self hidePoppingView:true];
    } else {
        self.animationTarget = AnimationTargetUnset;
    }
    
}

- (void)hidePoppingViewAfter:(NSTimeInterval)delayTime {
    _delayHideTime = delayTime;
    
    [self hidePoppingViewDelayIfNeeded];
}

- (void)hidePoppingViewWithAnimated {
    [self hidePoppingView:true];
}

- (void)hidePoppingViewDelayIfNeeded {
    if (_delayHideTime) {
        if (_isShow) {
            [self performSelector:@selector(hidePoppingViewWithAnimated) withObject:nil afterDelay:_delayHideTime];
        }
    }
}

- (void)hidePoppingViewWithCancelDelay:(BOOL)animated {
    [self cancelDelayHideIfNeeded];
    [self hidePoppingView:animated];
}

- (void)hidePoppingView:(BOOL)animated {
    _animationTarget = AnimationTargetHide;
    
    if (_isAnimating || !_isShow) {
        return;
    }
    
    _isAnimating = true;
    
    if ([self.delegate respondsToSelector:@selector(popViewHelperWillHidePoppingView:popViewHelper:)]) {
        [self.delegate popViewHelperWillHidePoppingView:self.targetView popViewHelper:self];
    }
    
    if (self.isAnimatedForShadow) {
        self.targetView.layer.shadowOpacity = 0;
    }
    
    if (animated) {
        
        [UIView animateWithDuration:MAX(_hideAnimateDuration, _hideAnimateMinDuration) delay:0 usingSpringWithDamping:_spring initialSpringVelocity:_initVelocity options:0 animations:^{
            [self hideAction];
        } completion:^(BOOL finished) {
            [self hideCompletionAction];
        }];
    } else {
      
        [self hideAction];
        [self hideCompletionAction];
    }
}

- (void)hideAction {
    self.mask.alpha = 0;
    CGRect tmpRect = CGRectMake(self.endOrigin.x, self.endOrigin.y, self.targetView.width, self.targetView.height);
    self.targetView.frame = tmpRect;
    self.targetView.alpha = self.alpha[2].integerValue;
    if ([self.delegate respondsToSelector:@selector(popViewHelperHideAnimationBlock:)]) {
        [self.delegate popViewHelperHideAnimationBlock:self.targetView];
    }
}

- (void)hideCompletionAction {
    self.isAnimating = false;
    self.isShow = false;
    self.targetView.hidden = true;
    [self.targetView removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(popViewHelperDidHidePoppingView:popViewHelper:)]) {
        [self.delegate popViewHelperDidHidePoppingView:self.targetView popViewHelper:self];
    }

    [[WSPopViewManager shareinstance] deQueue:self];
    
    if (self.animationTarget == AnimationTargetShow) {
        [self showPoppingView:true];
    } else {
        self.animationTarget = AnimationTargetUnset;
    }
    
    // 再次弹出时重新创建
    [_mask removeFromSuperview];
    [_targetView removeFromSuperview];
    
}

//- (void)dealloc {
//    [_mask removeFromSuperview];
//    [_targetView removeFromSuperview];
//
//    NSLog(@"popviewhelper dealloc");
//}

@end
