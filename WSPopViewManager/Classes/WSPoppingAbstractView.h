//
//  WSPoppingAbstractView.h
//  WSY
//
//  Created by HMY on 2021/9/8.
//  Copyright © 2021 wangshangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WSPopViewHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface WSPoppingAbstractView : UIView

- (void)initPopViewHelperWithSize:(CGSize)size viewPopDirection:(ViewPopDirection)viewPopDirection maskStatus:(MaskStatus)maskStatus;

- (void)show;

- (void)hide;

@end

NS_ASSUME_NONNULL_END
