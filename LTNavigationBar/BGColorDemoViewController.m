//
//  ViewController.m
//  LTNavigationBar
//
//  Created by ltebean on 15-2-15.
//  Copyright (c) 2015年 ltebean. All rights reserved.
//

#import "BGColorDemoViewController.h"
#import "UINavigationBar+Awesome.h"

#define NAVBAR_CHANGE_POINT self.tableView.tableHeaderView.frame.size.height - self.tableView.contentInset.top * 2

@interface BGColorDemoViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation BGColorDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
	// 是否缩放变形
	[self.tableView.tableHeaderView.subviews lastObject].contentMode = UIViewContentModeScaleAspectFill;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	UIColor * color = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1];
	CGFloat offsetY = scrollView.contentOffset.y;
	UIView *headerImage = [self.tableView.tableHeaderView.subviews lastObject];
	if (offsetY > NAVBAR_CHANGE_POINT) { // 渐变色
		CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
		[self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
	} else { //  纯色
		[self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
		if (offsetY < - self.tableView.contentInset.top) { // 到顶了还下拉
			// 缩放方式二：
			// CGFloat scale = 1 - (offsetY + self.tableView.contentInset.top)/500;
			// headerImage.transform = CGAffineTransformMakeScale(scale, scale);
			CGRect frame = headerImage.frame;
			frame.origin.y = offsetY;
			frame.size.height = -offsetY + self.tableView.tableHeaderView.frame.size.height;
			headerImage.frame = frame;
		}
	}
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tableView.delegate = self;
    [self scrollViewDidScroll:self.tableView];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tableView.delegate = nil;
    [self.navigationController.navigationBar lt_reset];
}

#pragma mark UITableViewDatasource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"header";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = @"text";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
