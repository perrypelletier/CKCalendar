//
//  HCPTwoWeekCalendarViewController.m
//  Calendar
//
//  Created by Adam Perry-Pelletier on 4/16/14.
//
//

#import "HCPTwoWeekCalendarViewController.h"
#import "CKCalendarView.h"

@interface HCPTwoWeekCalendarViewController ()

@property(nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation HCPTwoWeekCalendarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self addTwoWeekCalendarView:CGRectMake(0,100,320,112)];
}

- (void)addTwoWeekCalendarView:(CGRect)rect {
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HCTwoWeekCalendarView" owner:nil options:nil];
    UIView *calendarView = [array lastObject];
    calendarView.frame = CGRectMake(0, rect.origin.y, calendarView.frame.size.width, calendarView.frame.size.height);
    UIScrollView *innerCalendarView = (UIScrollView *)[calendarView viewWithTag:1];
    
    CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startMonday
                                                                  style:CKCalendarStyleFlat
                                                         suppressHeader:YES
                                                      suppressDayLabels:YES];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"dd/MM/yyyy"];

    calendar.onlyShowCurrentMonth = NO;
    calendar.adaptHeightToNumberOfWeeksInMonth = YES;
    
    [innerCalendarView addSubview:calendar];
    innerCalendarView.contentSize = calendar.frame.size;
    
    [self.view addSubview:calendarView];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
