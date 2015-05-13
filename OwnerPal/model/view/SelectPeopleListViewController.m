//
//  SelectPeopleListViewController.m
//  OwnerPal
//
//  Created by NewDoone on 15/4/20.
//  Copyright (c) 2015年 NewDoone. All rights reserved.
//

#import "SelectPeopleListViewController.h"
#import "selectPeopleTableViewCell.h"

@interface SelectPeopleListViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property(nonatomic,strong) SelectedReceiverInfoBean* peDic;
@property (weak, nonatomic) IBOutlet UISearchBar *serachBtn;
@property(nonatomic,strong) NSArray* receivers;
@end

@implementation SelectPeopleListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDataFromCoreData];
    
    // Do any additional setup after loading the view.
}
-(void)loadDataFromCoreData{
    NSFetchRequest* req=[[NSFetchRequest alloc]initWithEntityName:@"ReceiverInfo"];
    NSArray* people=[ShareAppDelegate.managedObjectContext executeFetchRequest:req error:nil];
    self.receivers=people;
    [self.tableView reloadData];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
//    [self.delegate getSelectedPeople:self.peDic];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 72.0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.receivers.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellID=@"selectPeople";
    selectPeopleTableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    if (!cell) {
        cell=[[selectPeopleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    ReceiverInfo* info=[self.receivers objectAtIndex:indexPath.row];
    cell.phoneNumber.text=info.phoneNumber;
    cell.name.text=info.name;
    cell.address.text=info.address;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectPeopleTableViewCell* cell=(selectPeopleTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    SelectedReceiverInfoBean* bean=[[SelectedReceiverInfoBean alloc]init];
    bean.name=cell.name.text;
    bean.phoneNumber=cell.phoneNumber.text;
    bean.address=cell.address.text;
    self.peDic=bean;
    cell.selected=YES;
    [self.delegate getSelectedPeople:self.peDic];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma 搜索框代理
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.serachBtn resignFirstResponder];
    NSLog(@"searchBarSearchButtonClicked");
        NSFetchRequest* request=[[NSFetchRequest alloc]initWithEntityName:@"ReceiverInfo"];
        NSArray* companys=[ShareAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
        NSMutableArray* arr=[NSMutableArray array];
        for (ReceiverInfo* dinfo in companys) {
            NSString* name=dinfo.name;
            NSString*num=dinfo.phoneNumber;
            NSString* address=dinfo.address;
            NSRange range=[name rangeOfString:self.serachBtn.text];
            NSRange range2=[num rangeOfString:self.serachBtn.text];
            NSRange range3=[address rangeOfString:self.serachBtn.text];
            if (range.length>0||range2.length>0||range3.length>0) {
                [arr addObject:dinfo];
            }
        }
    self.receivers=arr;
    if (self.receivers.count>0) {
        
    }else{
        if (self.serachBtn.text.length>0) {
            
        }else{
        [self loadDataFromCoreData];
        }
    }
    [self.tableView reloadData];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if (!searchBar.text.length>0) {
        [self.serachBtn resignFirstResponder];
         [self loadDataFromCoreData];
    }
}
@end
