//
//  WSPopViewManager.h
//  WSY
//
//  Created by HMY on 2021/9/15.
//  Copyright © 2021 wangshangyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSPopViewHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface PopViewHelperContainer : NSObject
    
@property (nonatomic, strong) WSPopViewHelper *popViewHelper;

@end



@interface WSPopViewManager : NSObject

@property (nonatomic, strong) NSMutableArray<PopViewHelperContainer *> *popViewHelperContainers;

@property (nonatomic, strong) NSMutableArray<WSPopViewHelper *> *popViewHelperQueue;

@property (nonatomic, strong) WSPopViewHelper *showingPoppingViewHelper;

+ (instancetype)shareinstance;

- (void)addPopViewHelper:(WSPopViewHelper *)popViewHelper;

- (void)clearReleased;

- (void)enQueue:(WSPopViewHelper *)popViewHelper;

- (void)deQueue:(WSPopViewHelper *)popViewHelper;

@end

NS_ASSUME_NONNULL_END
