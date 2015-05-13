//
//  ChooseDeliverCompanyViewController.m
//  OwnerPal
//
//  Created by NewDoone on 15/4/20.
//  Copyright (c) 2015年 NewDoone. All rights reserved.
//

#import "ChooseDeliverCompanyViewController.h"
#import "DeliveryCompanysTableViewCell.h"
#import "BATableView.h"

 static NSString* cellID=@"chooseCompany";

@interface ChooseDeliverCompanyViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,BATableViewDelegate>
{
    // A-Z段落列表
    NSMutableArray *mAzArray;
    // 原始部门数据
    NSArray        *arraySourceDept;
    // 原始联系人数据
    NSArray        *arraySourceContact;
    // UI实际填充-二维
    NSMutableArray *mUIdataArray;
    //存首字母
    NSMutableArray  * firstPYs;
    //重新排序
    NSMutableArray *sortByPY;
    //临时数组
    NSMutableArray * temp;
}
@property(nonatomic,strong) ChooseCompanyBean* comDic;
@property(nonatomic,strong)NSArray * MostComs;
@property(nonatomic,strong)NSMutableArray * allComs;
@property(nonatomic,strong)NSMutableArray * tempDatas;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBtn;
@property (nonatomic, strong) BATableView *contactTableView;
@end

@implementation ChooseDeliverCompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:@"DeliveryCompanysTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:cellID];
    
    
    self.tableView.allowsSelection=YES;
    self.allComs=nil;
    self.allComs=[NSMutableArray array];
    self.tempDatas=nil;
    self.tempDatas=[NSMutableArray array];
    
    mUIdataArray = nil;
    mAzArray     = nil;
    firstPYs  =nil;
    sortByPY =nil;
    mUIdataArray = [NSMutableArray array];
    mAzArray     = [NSMutableArray array];
    firstPYs =[NSMutableArray array];
    sortByPY =[NSMutableArray array];
    
    self.mostChoosed.selected=YES;
    self.mostChoosed.backgroundColor=[UIColor colorWithRed:98/255.0 green:181/255.0 blue:205/255.0 alpha:1.0];
    [self loadDataFromCoreData];
    [self createTableView];
}
// 创建tableView
- (void) createTableView {
    CGRect frame=[[UIScreen mainScreen]bounds];
    self.contactTableView = [[BATableView alloc] initWithFrame:CGRectMake(0, 150, self.view.bounds.size.width, frame.size.height-164)];
    self.contactTableView.delegate = self;
    [self.view addSubview:self.contactTableView];
}
-(void)loadDataFromCoreData{
    firstPYs=nil;
    firstPYs =[NSMutableArray array];
    self.tempDatas=nil;
    self.tempDatas=[NSMutableArray array];
    NSFetchRequest* request=[[NSFetchRequest alloc]initWithEntityName:@"DeliveryCompanyInfo"];
    NSArray* companys=[ShareAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
    self.MostComs=companys;
    for (DeliveryCompanyInfo* info in companys) {
        ChooseCompanyBean* bean=[[ChooseCompanyBean alloc]init];
        bean.name=info.name;
        bean.phoneNumber=info.phoneNumber;
        [self.tempDatas addObject:bean];
        //解析，取出首字母
        char  firstPY=[OAChineseToPinyin sortSectionTitle:info.name];
        NSString* f=[NSString stringWithFormat:@"%c",firstPY];
        [firstPYs addObject:f];
    }
    NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch|NSNumericSearch|
    NSWidthInsensitiveSearch|NSForcedOrderingSearch;
    NSComparator sort = ^(NSString *obj1,NSString *obj2)
    {
        NSRange range = NSMakeRange(0,obj1.length);
        return [obj1 compare:obj2 options:comparisonOptions range:range];
    };
    //重新处理数据源
    [self getNewDataForTableView];
    //去重
    NSMutableSet* set=[NSMutableSet setWithArray:firstPYs];
    firstPYs=(NSMutableArray*)[set allObjects];
    firstPYs=(NSMutableArray*)[firstPYs sortedArrayUsingComparator:sort];
    NSLog(@"companys.count:%lu",(unsigned long)companys.count);
    [self.contactTableView reloadData];
}

- (IBAction)clickOnMostBtn:(id)sender {
    firstPYs=nil;
    firstPYs =[NSMutableArray array];

    self.mostChoosed.selected=YES;
    self.allCompanys.selected=NO;
    self.mostChoosed.backgroundColor=[UIColor colorWithRed:98/255.0 green:181/255.0 blue:205/255.0 alpha:1.0];
    self.allCompanys.backgroundColor=[UIColor clearColor];
    [self loadDataFromCoreData];
}
- (IBAction)clickOnAllBtn:(id)sender {
    self.mostChoosed.selected=NO;
    self.allCompanys.selected=YES;
    firstPYs=nil;
    firstPYs =[NSMutableArray array];
    self.tempDatas=nil;
    self.tempDatas=[NSMutableArray array];
    self.mostChoosed.backgroundColor=[UIColor clearColor];
    self.allCompanys.backgroundColor=[UIColor colorWithRed:98/255.0 green:181/255.0 blue:205/255.0 alpha:1.0];
    [self loadAllCompanysInfos];
}
-(void)loadAllCompanysInfos{

    GetDeliveryCompanyRequest* request=[[GetDeliveryCompanyRequest alloc]init];
    [SystemAPI GetDeliveryCompanyRequest:request success:^(GetDeliveryCompanyResponse *response) {
        self.tempDatas=nil;
        self.tempDatas=[NSMutableArray array];
        NSLog(@"response.body:%@",response.body);
        NSLog(@"response.msg:%@",response.msg);
        self.allComs=nil;
        self.allComs=[NSMutableArray array];
       
        NSDictionary* dic=response.body;
        NSArray* list=[dic objectForKey:@"list"];
        [shareValue shareInstance].mark=[dic objectForKey:@"mark"];
        for (NSDictionary* info in list) {
             ChooseCompanyBean* receiver=[[ChooseCompanyBean alloc]init];
            receiver.name=[info objectForKey:@"name"];
            receiver.phoneNumber=[info objectForKey:@"tel"];
            receiver.py=[info objectForKey:@"py"];
            [self.tempDatas addObject:receiver];
            NSString* py=[info objectForKey:@"py"];
            NSString* fpy=[py substringWithRange:NSMakeRange(0, 1)];
            [firstPYs addObject:fpy];
            
            DeliveryCompanyAllInfo* allInfo=[NSEntityDescription insertNewObjectForEntityForName:@"DeliveryCompanyAllInfo" inManagedObjectContext:ShareAppDelegate.managedObjectContext];
            allInfo.name=[info objectForKey:@"name"];
            allInfo.phoneNumber=[info objectForKey:@"tel"];
             [ShareAppDelegate saveContext];
        }
//        NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch|NSNumericSearch|
//        NSWidthInsensitiveSearch|NSForcedOrderingSearch;
//        NSComparator sort = ^(NSString *obj1,NSString *obj2)
//        {
//            NSRange range = NSMakeRange(0,obj1.length);
//            return [obj1 compare:obj2 options:comparisonOptions range:range];
//        };
//        //重新处理数据源
//        [self getNewDataForTableView];
//        //去重
//        NSMutableSet* set=[NSMutableSet setWithArray:firstPYs];
//        firstPYs=(NSMutableArray*)[set allObjects];
//        firstPYs=(NSMutableArray*)[firstPYs sortedArrayUsingComparator:sort];
        if (!self.tempDatas.count>0) {
            NSFetchRequest* request=[[NSFetchRequest alloc]initWithEntityName:@"DeliveryCompanyAllInfo"];
            NSArray* companys=[ShareAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
            for (DeliveryCompanyAllInfo* info in companys) {
                ChooseCompanyBean* bean=[[ChooseCompanyBean alloc]init];
                bean.name=info.name;
                bean.phoneNumber=info.phoneNumber;
                [self.tempDatas addObject:bean];
                //解析，取出首字母
                char  firstPY=[OAChineseToPinyin sortSectionTitle:info.name];
                NSString* f=[NSString stringWithFormat:@"%c",firstPY];
                [firstPYs addObject:f];
            }
            NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch|NSNumericSearch|
            NSWidthInsensitiveSearch|NSForcedOrderingSearch;
            NSComparator sort = ^(NSString *obj1,NSString *obj2)
            {
                NSRange range = NSMakeRange(0,obj1.length);
                return [obj1 compare:obj2 options:comparisonOptions range:range];
            };
            //重新处理数据源
            [self getNewDataForTableView];
            //去重
            NSMutableSet* set=[NSMutableSet setWithArray:firstPYs];
            firstPYs=(NSMutableArray*)[set allObjects];
            firstPYs=(NSMutableArray*)[firstPYs sortedArrayUsingComparator:sort];
        }
        [self.contactTableView reloadData];
    } fail:^(BOOL notReachable, NSString *desciption) {
        
    }];
    
    if (self.tempDatas.count==0) {
        NSFetchRequest* request=[[NSFetchRequest alloc]initWithEntityName:@"DeliveryCompanyAllInfo"];
        NSArray* companys=[ShareAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
        for (DeliveryCompanyAllInfo* info in companys) {
            ChooseCompanyBean* bean=[[ChooseCompanyBean alloc]init];
            bean.name=info.name;
            bean.phoneNumber=info.phoneNumber;
            [self.tempDatas addObject:bean];
            //解析，取出首字母
            char  firstPY=[OAChineseToPinyin sortSectionTitle:info.name];
            NSString* f=[NSString stringWithFormat:@"%c",firstPY];
            [firstPYs addObject:f];
        }
        NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch|NSNumericSearch|
        NSWidthInsensitiveSearch|NSForcedOrderingSearch;
        NSComparator sort = ^(NSString *obj1,NSString *obj2)
        {
            NSRange range = NSMakeRange(0,obj1.length);
            return [obj1 compare:obj2 options:comparisonOptions range:range];
        };
        //重新处理数据源
        [self getNewDataForTableView];
        //去重
        NSMutableSet* set=[NSMutableSet setWithArray:firstPYs];
        firstPYs=(NSMutableArray*)[set allObjects];
        firstPYs=(NSMutableArray*)[firstPYs sortedArrayUsingComparator:sort];
         [self.contactTableView reloadData];
    }
    
}
-(void)getNewDataForTableView{
    sortByPY=nil;
    sortByPY=[NSMutableArray array];
    
    //准备排序sort
    NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch|NSNumericSearch|
    NSWidthInsensitiveSearch|NSForcedOrderingSearch;
    NSComparator sort = ^(NSString *obj1,NSString *obj2)
    {
        NSRange range = NSMakeRange(0,obj1.length);
        return [obj1 compare:obj2 options:comparisonOptions range:range];
    };
    
    //重新处理数据源
    char oldHead;
    char newHead;
    NSMutableString* oldHeader;
    NSMutableString* newHeader;
    NSMutableArray* newUIarray;
    newUIarray=nil;
    for (int i=0;  i<[self.tempDatas count];i++) {
        ChooseCompanyBean* name=self.tempDatas[i];
        
        oldHead=[OAChineseToPinyin sortSectionTitle:name.name];
        oldHeader=(NSMutableString*)[NSString stringWithFormat:@"%c",oldHead];
        if (i==0) {
            NSMutableArray *three=[[NSMutableArray alloc] init];
            [three addObject:[self.tempDatas objectAtIndex:i]];
            [sortByPY addObject:three];
            continue;
        }
        int j=0;
        for (; j<[sortByPY count]; j++) {
            NSMutableArray* arr=(NSMutableArray*)sortByPY[j];
            ChooseCompanyBean* name2=arr[0];
            
            newHead=[OAChineseToPinyin sortSectionTitle:name2.name];
            newHeader=(NSMutableString*)[NSString stringWithFormat:@"%c",newHead];
            if ([oldHeader isEqual:newHeader]) {
//                for (ChooseCompanyBean* bean in self.tempDatas[i]) {
//                    [sortByPY[j] addObject:bean];
//                }
                [arr  addObject:name];
                
                break;
            }
        }
        if (j>=sortByPY.count) {
            NSMutableArray *three=[[NSMutableArray alloc] init];
            [three addObject:[self.tempDatas objectAtIndex:i]];
            [sortByPY addObject:three];
        }
    }
    //排序
    char headerChar;
    NSMutableString* headerLetter;
    NSMutableDictionary* dic=[NSMutableDictionary dictionary];
    for (NSMutableArray* arr in sortByPY) {
        ChooseCompanyBean* bean=arr[0];
        headerChar=[OAChineseToPinyin sortSectionTitle:bean.name];
        headerLetter=(NSMutableString*)[NSString stringWithFormat:@"%c",headerChar];
        [dic setObject:arr forKey:headerLetter];
    }
    NSMutableArray* keys=(NSMutableArray*)[dic allKeys];
    keys=(NSMutableArray*)[keys sortedArrayUsingComparator:sort];
    sortByPY=nil;
    sortByPY=[NSMutableArray array];
    for (NSString* key in keys) {
        [sortByPY addObject:[dic objectForKey:key]];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [firstPYs count];
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return firstPYs[section];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if ([firstPYs count] == 0)
    {
        return 0;
    }
    else
    {
        return [sortByPY[section] count];
    }

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString* cellID=@"chooseCompany";
    DeliveryCompanysTableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
         cell = [[[NSBundle mainBundle] loadNibNamed:@"DeliveryCompanysTableViewCell"  owner:self options:nil] lastObject];
    }
//    ChooseCompanyBean* info=[self.tempDatas objectAtIndex:indexPath.row];
    ChooseCompanyBean* info=sortByPY[indexPath.section][indexPath.row];
    cell.phoneNumber.text=info.phoneNumber;
    cell.companyName.text=info.name;
    return cell;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 0.1;
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DeliveryCompanysTableViewCell* cell=(DeliveryCompanysTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    ChooseCompanyBean* bean=[[ChooseCompanyBean alloc]init];
    bean.name=cell.companyName.text;
    bean.phoneNumber=cell.phoneNumber.text;
    self.comDic=bean;
    cell.selected=YES;
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate getDeliverCompany:self.comDic];
}
#pragma BATableViewDelegate
- (NSArray *) sectionIndexTitlesForABELTableView:(BATableView *)tableView {
    return firstPYs;
}

#pragma 搜索框代理
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchBtn resignFirstResponder];
    NSLog(@"searchBarSearchButtonClicked");
    self.tempDatas=nil;
    self.tempDatas=[NSMutableArray array];
    
    if (self.mostChoosed.selected) {
        NSFetchRequest* request=[[NSFetchRequest alloc]initWithEntityName:@"DeliveryCompanyInfo"];
        NSArray* companys=[ShareAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
        NSMutableArray* arr=[NSMutableArray array];
        for (DeliveryCompanyInfo* dinfo in companys) {
            NSString* name=dinfo.name;
            NSString*num=dinfo.phoneNumber;
            NSRange range=[name rangeOfString:self.searchBtn.text];
            NSRange range2=[num rangeOfString:self.searchBtn.text];
            if (range.length>0||range2.length>0) {
                [arr addObject:dinfo];
            }
        }
        for (DeliveryCompanyInfo* info in arr) {
            ChooseCompanyBean* bean=[[ChooseCompanyBean alloc]init];
            bean.name=info.name;
            bean.phoneNumber=info.phoneNumber;
            [self.tempDatas addObject:bean];
            //解析，取出首字母
            char  firstPY=[OAChineseToPinyin sortSectionTitle:info.name];
            NSString* f=[NSString stringWithFormat:@"%c",firstPY];
            [firstPYs addObject:f];
        }
      
    }
    if (self.allCompanys.selected) {
        NSFetchRequest* request=[[NSFetchRequest alloc]initWithEntityName:@"DeliveryCompanyAllInfo"];
        NSArray* companys=[ShareAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
        NSMutableArray* arr=[NSMutableArray array];
        for (DeliveryCompanyAllInfo* dinfo in companys) {
            NSString* name=dinfo.name;
            NSString*num=dinfo.phoneNumber;
            NSRange range=[name rangeOfString:self.searchBtn.text];
            NSRange range2=[num rangeOfString:self.searchBtn.text];
            if (range.length>0||range2.length>0) {
                [arr addObject:dinfo];
            }
        }
        for (DeliveryCompanyAllInfo* info in arr) {
            ChooseCompanyBean* bean=[[ChooseCompanyBean alloc]init];
            bean.name=info.name;
            bean.phoneNumber=info.phoneNumber;
            [self.tempDatas addObject:bean];
            //解析，取出首字母
            char  firstPY=[OAChineseToPinyin sortSectionTitle:info.name];
            NSString* f=[NSString stringWithFormat:@"%c",firstPY];
            [firstPYs addObject:f];
        }
    }
    if (self.tempDatas.count>0) {
        NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch|NSNumericSearch|
        NSWidthInsensitiveSearch|NSForcedOrderingSearch;
        NSComparator sort = ^(NSString *obj1,NSString *obj2)
        {
            NSRange range = NSMakeRange(0,obj1.length);
            return [obj1 compare:obj2 options:comparisonOptions range:range];
        };
        //重新处理数据源
        [self getNewDataForTableView];
        //去重
        NSMutableSet* set=[NSMutableSet setWithArray:firstPYs];
        firstPYs=(NSMutableArray*)[set allObjects];
        firstPYs=(NSMutableArray*)[firstPYs sortedArrayUsingComparator:sort];

        
    }else{
        if (self.searchBtn.text.length>0) {
            
        }else{
                 [self loadAllCompanysInfos];
            }
        
       
    }
    [self.contactTableView reloadData];
}
@end
