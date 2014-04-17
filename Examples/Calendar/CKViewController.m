#import <CoreGraphics/CoreGraphics.h>
#import "CKViewController.h"
#import "CKCalendarView.h"
#import "HCPTwoWeekCalendarViewController.h"

@interface CKViewController () <CKCalendarDelegate>

@property(nonatomic, weak) CKCalendarView *nonFlatCalendar;
@property(nonatomic, weak) CKCalendarView *flatCalendar;
@property(nonatomic, strong) UILabel *dateLabelFlat;
@property(nonatomic, strong) UILabel *dateLabelNonFlat;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;
@property(nonatomic, strong) NSDate *disabledDate;
@property(nonatomic, strong) UIScrollView *scrollView;

@end

@implementation CKViewController


- (id)init {
    self = [super init];
    if (self) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
        self.scrollView.scrollEnabled = YES;
        self.scrollView.contentSize = CGSizeMake(320, 800);
        
        [self addNonFlatDesignCalendar:CGRectMake(10, 44, 300, 320)];
        [self addFlatDesignCalendar:CGRectMake(10, 420, 300, 320)];
        
        [self addButtonToGotoTwoWeekViewController:CGRectMake(10, 720, 200, 22)];
        
        [self.view addSubview:self.scrollView];
    }
    return self;
}

- (void)addButtonToGotoTwoWeekViewController:(CGRect)rect
{
    UIButton *button = [[UIButton alloc] initWithFrame:rect];
    
    [button setTitle:@"Goto" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    
    [button addTarget:self action:@selector(gotoTwoWeekViewClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:button];
}

- (void)gotoTwoWeekViewClicked:(id)sender
{
    UIViewController *viewController = [[HCPTwoWeekCalendarViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)addNonFlatDesignCalendar:(CGRect)rect {
    CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
    self.nonFlatCalendar = calendar;
    self.nonFlatCalendar.delegate = self;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"dd/MM/yyyy"];
    self.minimumDate = [self.dateFormatter dateFromString:@"20/09/2012"];
    
    self.disabledDate = [self.dateFormatter dateFromString:@"05/01/2014"];
    
    calendar.onlyShowCurrentMonth = NO;
    calendar.adaptHeightToNumberOfWeeksInMonth = YES;
    
    calendar.frame = rect;
    [self.scrollView addSubview:calendar];
    
    self.dateLabelNonFlat = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(calendar.frame), self.view.bounds.size.width, 24)];
    [self.scrollView addSubview:self.dateLabelNonFlat];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localeDidChange) name:NSCurrentLocaleDidChangeNotification object:nil];
}

- (void)addFlatDesignCalendar:(CGRect)rect {
    CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startMonday style:CKCalendarStyleFlat];
    self.flatCalendar = calendar;
    self.flatCalendar.delegate = self;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"dd/MM/yyyy"];
    self.minimumDate = [self.dateFormatter dateFromString:@"20/09/2012"];
    
    self.disabledDate = [self.dateFormatter dateFromString:@"01/05/2014"],
    
    calendar.onlyShowCurrentMonth = NO;
    calendar.adaptHeightToNumberOfWeeksInMonth = YES;
    
    calendar.frame = rect;
    [self.scrollView addSubview:calendar];
    
    self.dateLabelFlat = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(calendar.frame), self.view.bounds.size.width, 24)];
    [self.scrollView addSubview:self.dateLabelFlat];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localeDidChange) name:NSCurrentLocaleDidChangeNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)localeDidChange {
    [self.flatCalendar setLocale:[NSLocale currentLocale]];
    [self.nonFlatCalendar setLocale:[NSLocale currentLocale]];
}

- (BOOL)dateIsDisabled:(NSDate *)date {
    if ([self.disabledDate isEqualToDate:date]) {
        return YES;
    }
    return NO;
}

#pragma mark -
#pragma mark - CKCalendarDelegate

- (void)calendar:(CKCalendarView *)calendar configureDateItem:(CKDateItem *)dateItem forDate:(NSDate *)date {
    // TODO: play with the coloring if we want to...
    if ([self dateIsDisabled:date]) {
        dateItem.backgroundColor = [UIColor redColor];
        dateItem.textColor = [UIColor whiteColor];
    }
}

- (BOOL)calendar:(CKCalendarView *)calendar willSelectDate:(NSDate *)date {
    return ![self dateIsDisabled:date];
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    if (calendar == self.flatCalendar) {
        self.dateLabelFlat.text = [self.dateFormatter stringFromDate:date];
    } else {
        self.dateLabelNonFlat.text = [self.dateFormatter stringFromDate:date];
    }
    
}

- (BOOL)calendar:(CKCalendarView *)calendar willChangeToMonth:(NSDate *)date {
    if ([date laterDate:self.minimumDate] == date) {
        calendar.backgroundColor = [UIColor blueColor];
        return YES;
    } else {
        calendar.backgroundColor = [UIColor redColor];
        return NO;
    }
}

- (void)calendar:(CKCalendarView *)calendar didLayoutInRect:(CGRect)frame {
    NSLog(@"calendar layout: %@", NSStringFromCGRect(frame));
}

@end