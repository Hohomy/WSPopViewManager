//
//  WSPopViewManager.m
//  WSY
//
//  Created by HMY on 2021/9/15.
//  Copyright © 2021 wangshangyuan. All rights reserved.
//

#import "WSPopViewManager.h"

@implementation PopViewHelperContainer

- (instancetype)initWithPopViewHelper:(WSPopViewHelper*)popViewHelper {
    self = [super init];
    if (self) {
        self.popViewHelper = popViewHelper;
    }
    return self;
}

@end

@implementation WSPopViewManager

+ (instancetype)shareinstance {
    static WSPopViewManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WSPopViewManager alloc] init];
    });
    return instance;
}

- (NSMutableArray<PopViewHelperContainer *> *)popViewHelperContainers {
    if (!_popViewHelperContainers) {
        _popViewHelperContainers = [NSMutableArray array];
    }
    return _popViewHelperContainers;
}

- (NSMutableArray<WSPopViewHelper *> *)popViewHelperQueue {
    if (!_popViewHelperQueue) {
        _popViewHelperQueue = [NSMutableArray array];
    }
    return _popViewHelperQueue;
}

- (void)addPopViewHelper:(WSPopViewHelper *)popViewHelper {
    [self clearReleased];
    
    [_popViewHelperContainers addObject:[[PopViewHelperContainer alloc] initWithPopViewHelper:popViewHelper]];
}

- (void)enQueue:(WSPopViewHelper *)popViewHelper {
    if (_showingPoppingViewHelper == nil) {
        [popViewHelper showPoppingView:true];
        _showingPoppingViewHelper = popViewHelper;
    } else {
        popViewHelper.isLockTargetView = true;
    }
    
    [_popViewHelperQueue addObject:popViewHelper];
}

- (void)deQueue:(WSPopViewHelper *)popViewHelper {
    if ([_popViewHelperQueue containsObject:popViewHelper]) {
        popViewHelper.isLockTargetView = false;
        [_popViewHelperQueue removeObject:popViewHelper];
        _showingPoppingViewHelper = nil;
        [self showInQueue];
    }

}

- (void)showInQueue {
    [_popViewHelperQueue sortUsingComparator:^NSComparisonResult(WSPopViewHelper   * _Nonnull obj1, WSPopViewHelper   * _Nonnull obj2) {
        if (obj1.priority < obj2.priority) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
    
    _showingPoppingViewHelper = [_popViewHelperQueue lastObject];
    [_showingPoppingViewHelper showPoppingView:true];
    [_showingPoppingViewHelper hidePoppingViewDelayIfNeeded];
}

- (void)clearReleased {
    for (PopViewHelperContainer *popViewHelperContainer in [[_popViewHelperContainers reverseObjectEnumerator] allObjects]) {
        if (popViewHelperContainer.popViewHelper == nil) {
            [_popViewHelperContainers removeObject:popViewHelperContainer];
        }
    }
}

@end
