//
//  NormalViewController.m
//  HelloXcode
//
//  Created by Pheylix on 15-7-6.
//  Copyright (c) 2015年 Telecom. All rights reserved.
//

#import "NormalViewController.h"

@interface NormalViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation NormalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.edgesForExtendedLayout = UIRectEdgeNone;
}




@end
