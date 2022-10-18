//
//  WSPoppingAbstractView.m
//  WSY
//
//  Created by HMY on 2021/9/8.
//  Copyright © 2021 wangshangyuan. All rights reserved.
//

#import "WSPoppingAbstractView.h"
#import "WSPopViewHelper.h"

@interface WSPoppingAbstractView()

@property (nonatomic, strong) WSPopViewHelper *popViewHelper;

@end

@implementation WSPoppingAbstractView

- (instancetype)initWithSize:(CGSize)size viewPopDirection:(ViewPopDirection)viewPopDirection maskStatus:(MaskStatus)maskStatus {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self initPopViewHelperWithSize:size viewPopDirection:viewPopDirection maskStatus:maskStatus];
    }
    return self;
}

- (void)initPopViewHelperWithSize:(CGSize)size viewPopDirection:(ViewPopDirection)viewPopDirection maskStatus:(MaskStatus)maskStatus {
    self.frame = CGRectMake(0, 0, size.width, size.height);

    _popViewHelper = [[WSPopViewHelper alloc] initWithSuperView:nil targetView:self viewPopDirection:viewPopDirection maskStatus:maskStatus];
}

- (void)show {
    [_popViewHelper showPoppingView:true];
}

- (void)hide {
    [_popViewHelper hidePoppingView:true];
}

- (void)autoHidePopViewAfter:(NSTimeInterval)delayTime {
    [_popViewHelper hidePoppingViewAfter:delayTime];
}

- (void)toggle {
    if (_popViewHelper.isShow) {
        [_popViewHelper hidePoppingView:true];
    } else {
        [_popViewHelper showPoppingView:true];
    }
}

@end
