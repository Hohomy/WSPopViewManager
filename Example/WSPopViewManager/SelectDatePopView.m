//
//  SelectDatePopView.m
//  WSY
//
//  Created by HMY on 2021/10/22.
//  Copyright © 2021 wangshangyuan. All rights reserved.
//

#import "SelectDatePopView.h"

#define WSWIDTH [UIScreen mainScreen].bounds.size.width  //屏幕宽

@interface SelectDatePopView()

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (nonatomic, strong) NSDate *selectedDate;

@end

@implementation SelectDatePopView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initPopViewHelperWithSize:CGSizeMake(WSWIDTH, 318) viewPopDirection:ViewPopDirectionBelowWithSafeArea maskStatus:MaskNormal];
    
    
    // 设置日期范围
//    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
//    NSDate *currentDate = [NSDate date];
//    NSDateComponents * comps = [[NSDateComponents alloc] init];
//    [comps setYear:100];
//    NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
//    _datePicker.maximumDate = maxDate;
    // 设置当前日期为最小值(不加这个，iOS12上面默认日期不是当日!)
    _datePicker.minimumDate = [NSDate date];

    // 初始值
    _selectedDate = _datePicker.date;
}

- (IBAction)changeDate:(UIDatePicker *)sender {
    _selectedDate = sender.date;
}

- (IBAction)calcelClick:(UIButton *)sender {
    [self hide];
}

- (IBAction)confirmClick:(UIButton *)sender {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    // 默认是UTC时间，转化为本地时间格式
//    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
//    [formatter setTimeZone:localTimeZone];
    NSString *dateStr = [formatter stringFromDate:_selectedDate];
    if (self.confirmDateCallback) {
        self.confirmDateCallback(dateStr);
    }
    [self hide];
}

@end
