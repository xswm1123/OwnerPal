//
//  QueryOrderDetailsViewController.m
//  OwnerPal
//
//  Created by NewDoone on 15/4/15.
//  Copyright (c) 2015年 NewDoone. All rights reserved.
//

#import "QueryOrderDetailsViewController.h"

@interface QueryOrderDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray* details;
@end

@implementation QueryOrderDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"baseInfo:%@",self.baseInfo);
    [self loadData];
    self.tableView.allowsSelection=NO;
    self.tableView.allowsMultipleSelection=NO;
    // Do any additional setup after loading the view.
}
-(void)loadData{
    self.details=nil;
    self.details=[NSMutableArray array];
    self.line.text=[self.baseInfo objectForKey:@"recipientAddress"];
    self.name.text=[self.baseInfo objectForKey:@"recipientEmployee"];
    self.orderCode.text=[self.baseInfo objectForKey:@"billCode"];
    self.phoneNumber.text=[self.baseInfo objectForKey:@"senderTel"];
    self.city.text=[self.baseInfo objectForKey:@""];
    QueryDeliveryDetailsRequest* request=[[QueryDeliveryDetailsRequest alloc]init];
    request.uniqueCode=[self.baseInfo objectForKey:@"uniqueCode"];
    [SystemAPI QueryDeliveryDetailsRequest:request success:^(QueryDeliveryDetailsResponse *response) {
        NSDictionary* dic=(NSDictionary*)response.body;
        NSArray* arr=[dic objectForKey:@"list"];
        for (NSDictionary* dics in arr) {
            [self.details addObject:dics];
        }
        [self.tableView reloadData];
    } fail:^(BOOL notReachable, NSString *desciption) {
        
    }];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64.0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.details.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellID=@"trackDetails";
    OrderTrackDetilsTableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    if (!cell) {
        cell=[[OrderTrackDetilsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    NSDictionary * dic=[self.details objectAtIndex:indexPath.row];
    cell.trackAddress.text=[dic objectForKey:@"history_comment"];
    NSString* date=[dic objectForKey:@"mod_time"];
    NSArray* arr=[date componentsSeparatedByString:@" "];
    cell.date.text=[arr firstObject];
    cell.time.text=[arr lastObject];
    if (indexPath.row==0) {
        cell.stationLine.image=[UIImage imageNamed:@"up.png"];
    }else{
        if (indexPath.row==[self.details count]-1) {
             cell.stationLine.image=[UIImage imageNamed:@"bottom.png"];
        }else{
            cell.stationLine.image=[UIImage imageNamed:@"middle.png"];
        }
    }
    
    
    return cell;
}

@end
