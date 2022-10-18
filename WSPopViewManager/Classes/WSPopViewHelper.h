//
//  PopViewHelper.h
//  WSY
//
//  Created by HMY on 2021/9/14.
//  Copyright © 2021 wangshangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WSPopViewHelper;

NS_ASSUME_NONNULL_BEGIN

@protocol WSPopViewHelperDelegate <NSObject>

- (void)popViewHelperWillShowPoppingView:(UIView *)targetView popViewHelper:(WSPopViewHelper *)popViewHelper;

- (void)popViewHelperWillHidePoppingView:(UIView *)targetView popViewHelper:(WSPopViewHelper *)popViewHelper;

- (void)popViewHelperDidShowPoppingView:(UIView *)targetView popViewHelper:(WSPopViewHelper *)popViewHelper;

- (void)popViewHelperDidHidePoppingView:(UIView *)targetView popViewHelper:(WSPopViewHelper *)popViewHelper;

- (void)popViewHelperDidClickMask:(UIControl *)mask popViewHelper:(WSPopViewHelper *)popViewHelper;

- (void)popViewHelperShowAnimationBlock:(UIView *)animatedTargetView;

- (void)popViewHelperHideAnimationBlock:(UIView *)animatedTargetView;

@end

// 弹出方式
typedef enum : NSUInteger {
    ViewPopDirectionNone,
    ViewPopDirectionAbove,
    ViewPopDirectionBelow,
    ViewPopDirectionBelowWithSafeArea,   // 底部弹出，安全区域填充白色
    ViewPopDirectionBelowToCenter,
    ViewPopDirectionCenter,
    ViewPopDirectionOnlyShowFullScreen,
    ViewPopDirectionFade,
    ViewPopDirectionBelowWithPadding
} ViewPopDirection;

// 动画表现
typedef enum : NSUInteger {
    AnimationNormal,
    AnimationSpring
}AnimationStyle;

// 半透明遮罩视图设置
typedef enum : NSUInteger {
    MaskHidden,         // 不存在
    MaskTransparent,    // 不可见 可点击
    MaskTransparentAndDisable,    // 不可见 不可点击
    MaskNormal,         // 可见 可点击
    MaskClickDisable,   // 可见 不可点击
}MaskStatus;

// 解决问题：调用了隐藏，但是，如果还在显示动画中，不会起效果；或者调用了显示，但是还在隐藏的动画中，该方法调用会失败
typedef enum : NSUInteger {
    AnimationTargetUnset,   // 默认
    AnimationTargetShow,    // 最终要显示
    AnimationTargetHide,    // 最终要隐藏
}AnimationTarget;


@interface WSPopViewHelper : NSObject

@property (nonatomic, weak) id<WSPopViewHelperDelegate> delegate;

// 可定制参数
@property (nonatomic, strong) UIView *targetView;

@property (nonatomic, strong) UIView *strongTargetView;

@property (nonatomic, strong) UIView *superView;

@property (nonatomic, assign) ViewPopDirection viewPopDirection;

@property (nonatomic, assign) NSTimeInterval showAnimateDuration;   // 动画持续时间=0.25

@property (nonatomic, assign) NSTimeInterval hideAnimateDuration;   // 动画持续时间=0.25

@property (nonatomic, assign) NSTimeInterval showAnimateMinDuration;   // 动画持续时间=0.25

@property (nonatomic, assign) NSTimeInterval hideAnimateMinDuration;   // 动画持续时间=0.25

@property (nonatomic, assign) NSTimeInterval showAnimateSpeed;  // =1500

@property (nonatomic, assign) NSTimeInterval hideAnimateSpeed;  // =1500

@property (nonatomic, copy) NSArray<NSNumber *> *alpha;  // [1,1,1]

@property (nonatomic, assign) CGPoint beginOrigin;  // 开始位置=zero

@property (nonatomic, assign) CGPoint showOrigin;  // 弹出后位置=zero

@property (nonatomic, assign) CGPoint endOrigin;  // 收回位置=zero

@property (nonatomic, assign) MaskStatus maskStatus;

@property (nonatomic, assign) CGFloat maskAlpha;  // 遮罩透明度=0.3

@property (nonatomic, assign) BOOL canForceHide;  //=true

@property (nonatomic, assign) NSInteger priority;  // 优先级

@property (nonatomic, assign) BOOL isLockTargetView;

@property (nonatomic, assign) BOOL isAnimatedForShadow;   // 是否存在阴影

@property (nonatomic, assign) BOOL isShow;   // 是否正在显示

@property (nonatomic, assign) AnimationStyle animationStyle;

- (instancetype)initWithSuperView:(UIView *__nullable)superView targetView:(UIView *)targetView viewPopDirection:(ViewPopDirection)viewPopDirection maskStatus:(MaskStatus)maskStatus;

- (void)showPoppingView:(BOOL)animated;

- (void)hidePoppingView:(BOOL)animated;

- (void)hidePoppingViewAfter:(NSTimeInterval)delayTime;

- (void)hidePoppingViewDelayIfNeeded;

@end

NS_ASSUME_NONNULL_END
