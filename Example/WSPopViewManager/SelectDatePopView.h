//
//  SelectDatePopView.h
//  WSY
//
//  Created by HMY on 2021/10/22.
//  Copyright © 2021 wangshangyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WSPoppingAbstractView.h"

NS_ASSUME_NONNULL_BEGIN

// 选择具体日期弹窗
@interface SelectDatePopView : WSPoppingAbstractView

@property (nonatomic, copy) void(^confirmDateCallback)(NSString *dateStr);

@end

NS_ASSUME_NONNULL_END
