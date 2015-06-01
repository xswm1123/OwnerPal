//
//  QueryMyOrderViewController.m
//  OwnerPal
//
//  Created by NewDoone on 15/4/14.
//  Copyright (c) 2015年 NewDoone. All rights reserved.
//

#import "QueryMyOrderViewController.h"
#import "OrderDetailsTableViewCell.h"

@interface QueryMyOrderViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong) NSMutableArray* orders;
@property(nonatomic,strong) NSMutableArray* baseDataArr;
@property(nonatomic,strong) NSMutableArray* moreDataArr;
@property(nonatomic,strong) NSMutableArray* refreshDataArr;

@end

@implementation QueryMyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self loadData];
    self.refreshDataArr=nil;
    self.refreshDataArr=[NSMutableArray array];
    self.moreDataArr=nil;
    self.moreDataArr=[NSMutableArray array];
    
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
 
}
-(void)viewDidAppear:(BOOL)animated{
    [self loadData];
}
- (IBAction)dimissKeyBoard:(id)sender {
    [self resignFirstResponder];
}
-(void)loadNewData{
  
    QueryDeliveryCodeRequest* request=[[QueryDeliveryCodeRequest alloc]init];
    if (self.orders.count>0) {
        NSDictionary* info=[self.orders objectAtIndex:0];
        request.billId=[info objectForKey:@"billId"];
    }else{
         request.billId=@"0";
    }
   
//    request.employeeTel=@"13995089065";
    [SystemAPI QueryDeliveryCodeRequest:request success:^(QueryDeliveryCodeResponse *response) {
        NSMutableDictionary* dic=response.body;
        NSArray* lists=[dic objectForKey:@"list"];
        for (NSDictionary* dics in lists) {
            [self.orders addObject:dics];
        }
//        self.orders=nil;
//        self.orders=[NSMutableArray array];
//        self.orders=self.refreshDataArr;
        
        [self.tableView  reloadData];
        [self.tableView.header endRefreshing];
    } fail:^(BOOL notReachable, NSString *desciption) {

    }];
}
-(void)loadMoreData{

    QueryDeliveryCodeRequest* request=[[QueryDeliveryCodeRequest alloc]init];
    if (self.orders.count>0) {
        NSDictionary* info=[self.orders objectAtIndex:0];
        request.billId=[info objectForKey:@"billId"];
    }else{
        request.billId=@"0";
    }
    [SystemAPI QueryDeliveryCodeRequest:request success:^(QueryDeliveryCodeResponse *response) {
        NSMutableDictionary* dic=response.body;
        NSArray* lists=[dic objectForKey:@"list"];
        for (NSDictionary* dics in lists) {
            [self.orders addObject:dics];
        }
        [self.tableView  reloadData];
        [self.tableView.footer endRefreshing];
    } fail:^(BOOL notReachable, NSString *desciption) {

    }];
}

-(void)loadData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.baseDataArr=nil;
    self.baseDataArr=[NSMutableArray array];
    self.orders=nil;
    self.orders=[NSMutableArray array];
    QueryDeliveryCodeRequest* request=[[QueryDeliveryCodeRequest alloc]init];
    request.billId=@"0";
    [SystemAPI QueryDeliveryCodeRequest:request success:^(QueryDeliveryCodeResponse *response) {
        NSMutableDictionary* dic=response.body;
        NSArray* lists=[dic objectForKey:@"list"];
        for (NSDictionary* dics in lists) {
            [self.baseDataArr addObject:dics];
        }
        self.orders=self.baseDataArr;
        dispatch_async(dispatch_get_main_queue(), ^{
             [self.tableView  reloadData];
        });
        
//        [self.tableView  reloadData];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } fail:^(BOOL notReachable, NSString *desciption) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:desciption toView:self.view];
    }];
}
#pragma TableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85.0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.orders.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellID=@"details";
    OrderDetailsTableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    if (!cell) {
        cell=[[OrderDetailsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary* dic=[self.orders objectAtIndex:indexPath.row];
    cell.orderCode.text=[dic objectForKey:@"billCode"];
    cell.isSignIn.text=[dic objectForKey:@"stateName"];
    cell.line.text=[dic objectForKey:@"recipientAddress"];
    NSString* from=[dic objectForKey:@"startDepot"];
    NSString* to=[dic objectForKey:@"endDepot"];
    cell.fromTo.text=[NSString stringWithFormat:@"%@-%@",from.length>0?from:@"?",to.length>0?to:@"?"];
    cell.lastUpdateTime.text=[dic objectForKey:@"modTime"];
    cell.name.text=[dic objectForKey:@"recipientEmployee"];
    cell.isSender=[dic objectForKey:@"ifSender"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* dic=[self.orders objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"queryDetail" sender:dic];
    self.tabBarController.tabBar.hidden=YES;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    QueryOrderDetailsViewController* vc=segue.destinationViewController;
    vc.baseInfo=sender;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     self.tabBarController.tabBar.hidden=NO;
}
@end


