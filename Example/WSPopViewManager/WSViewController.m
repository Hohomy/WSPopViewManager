//
//  WSViewController.m
//  WSPopViewManager
//
//  Created by Homey on 10/18/2022.
//  Copyright (c) 2022 Homey. All rights reserved.
//

#import "WSViewController.h"
#import "SelectDatePopView.h"

@interface WSViewController ()

@property (strong, nonatomic) IBOutlet UIButton *selectDateButton;

@end

@implementation WSViewController

#define weak_Self(self) __weak typeof(self) weak_Self = self

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)selectDate:(UIButton *)sender {
    SelectDatePopView *popView = [[NSBundle mainBundle] loadNibNamed:@"SelectDatePopView" owner:nil options:nil].lastObject;
    [popView show];
    weak_Self(self);
    popView.confirmDateCallback = ^(NSString * _Nonnull dateStr) {
        // 显示选择的日期
        [weak_Self.selectDateButton setTitle:dateStr forState:UIControlStateNormal];
    };
}

@end
