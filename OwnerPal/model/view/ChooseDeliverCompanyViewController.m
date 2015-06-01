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
//    NSMutableArray  * firstPYs;
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
@property (nonatomic,strong) NSMutableArray*firstPYs;
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
    self.firstPYs  =nil;
    sortByPY =nil;
    mUIdataArray = [NSMutableArray array];
    mAzArray     = [NSMutableArray array];
    self.firstPYs =[NSMutableArray array];
    sortByPY =[NSMutableArray array];
    
    self.mostChoosed.selected=YES;
    self.mostChoosed.backgroundColor=[UIColor colorWithRed:98/255.0 green:181/255.0 blue:205/255.0 alpha:1.0];
    [self loadDataFromCoreData];
    [self createTableView];
}
// 创建tableView
- (void) createTableView {
    CGRect frame=[[UIScreen mainScreen]bounds];
    self.contactTableView = [[BATableView alloc] initWithFrame:CGRectMake(0, 150, self.view.bounds.size.width, frame.size.height-150)];
    self.contactTableView.delegate = self;
    [self.view addSubview:self.contactTableView];
}
-(void)loadDataFromCoreData{
    self.firstPYs=nil;
    self.firstPYs =[NSMutableArray array];
    self.tempDatas=nil;
    self.tempDatas=[NSMutableArray array];
    NSFetchRequest* request=[[NSFetchRequest alloc]initWithEntityName:@"DeliveryCompanyInfo"];
    NSArray* companys=[ShareAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
    self.MostComs=companys;
    for (DeliveryCompanyInfo* info in companys) {
        ChooseCompanyBean* bean=[[ChooseCompanyBean alloc]init];
        bean.name=info.name;
        bean.phoneNumber=info.phoneNumber;
        bean.key=info.key;
         bean.address=info.address;
        [self.tempDatas addObject:bean];
        //解析，取出首字母
        NSString* name=[info.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        char  firstPY=[OAChineseToPinyin sortSectionTitle:name];
        NSString* f=[NSString stringWithFormat:@"%c",firstPY];
        [self.firstPYs addObject:f];
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
    NSMutableSet* set=[NSMutableSet setWithArray:self.firstPYs];
    self.firstPYs=(NSMutableArray*)[set allObjects];
    self.firstPYs=(NSMutableArray*)[self.firstPYs sortedArrayUsingComparator:sort];
    NSLog(@"companys.count:%lu",(unsigned long)companys.count);
    [self.contactTableView reloadData];
}

- (IBAction)clickOnMostBtn:(id)sender {
    [self.searchBtn resignFirstResponder];
    self.firstPYs=nil;
    self.firstPYs =[NSMutableArray array];
    self.mostChoosed.selected=YES;
    self.allCompanys.selected=NO;
    self.mostChoosed.backgroundColor=[UIColor colorWithRed:98/255.0 green:181/255.0 blue:205/255.0 alpha:1.0];
    self.allCompanys.backgroundColor=[UIColor clearColor];
    [self loadDataFromCoreData];
}
- (IBAction)clickOnAllBtn:(id)sender {
    [self.searchBtn resignFirstResponder];
    self.mostChoosed.selected=NO;
    self.allCompanys.selected=YES;
    self.firstPYs=nil;
    self.firstPYs =[NSMutableArray array];
    self.tempDatas=nil;
    self.tempDatas=[NSMutableArray array];
    self.mostChoosed.backgroundColor=[UIColor clearColor];
    self.allCompanys.backgroundColor=[UIColor colorWithRed:98/255.0 green:181/255.0 blue:205/255.0 alpha:1.0];
    [self loadAllCompanysInfos];
}
/**
 *  加载全部的物流公司数据，如果本地不为空，加载本地的，否则从服务器获取。
 */
-(void)loadAllCompanysInfos{
    
    [self loadAllCompanyDataFromCoreData];
    NSString* isNeedUpdate=[shareValue shareInstance].isNeedToUpdateComs;
    if ([isNeedUpdate isEqualToString:@"1"]) {
        [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    GetDeliveryCompanyRequest* request=[[GetDeliveryCompanyRequest alloc]init];
    [SystemAPI GetDeliveryCompanyRequest:request success:^(GetDeliveryCompanyResponse *response) {
        [shareValue shareInstance].isNeedToUpdateComs=@"0";
        /**
         *  清空本地的数据
         */
        NSFetchRequest* request=[[NSFetchRequest alloc]initWithEntityName:@"DeliveryCompanyAllInfo"];
        NSArray* companys=[ShareAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
        if (companys&&[companys count]) {
            for (NSManagedObject* obj in companys) {
                [ShareAppDelegate.managedObjectContext deleteObject:obj];
            }
        }
        /**
         *  存入新的数据库数据
         */
        self.tempDatas=nil;
        self.tempDatas=[NSMutableArray array];
        NSLog(@"response.body:%@",response.body);
        NSLog(@"response.msg:%@",response.msg);
        self.allComs=nil;
        self.allComs=[NSMutableArray array];
       
        NSDictionary* dic=response.body;
        NSArray* list=[dic objectForKey:@"list"];
        [shareValue shareInstance].mark=[dic objectForKey:@"mark"];
        self.firstPYs=nil;
        self.firstPYs =[NSMutableArray arrayWithCapacity:list.count];
        for (NSDictionary* info in list) {
             ChooseCompanyBean* receiver=[[ChooseCompanyBean alloc]init];
            receiver.name=[info objectForKey:@"name"];
            receiver.phoneNumber=[info objectForKey:@"tel"];
            receiver.py=[info objectForKey:@"py"];
            receiver.key=[info objectForKey:@"key"];
            receiver.address=[info objectForKey:@"address"];
            [self.tempDatas addObject:receiver];
            DeliveryCompanyAllInfo* allInfo=[NSEntityDescription insertNewObjectForEntityForName:@"DeliveryCompanyAllInfo" inManagedObjectContext:ShareAppDelegate.managedObjectContext];
            allInfo.name=[info objectForKey:@"name"];
            allInfo.phoneNumber=[info objectForKey:@"tel"];
            allInfo.key=[info objectForKey:@"key"];
            allInfo.address=[info objectForKey:@"address"];
             [ShareAppDelegate saveContext];
        
            //解析，取出首字母
            NSString* name=[[info objectForKey:@"name"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            char  firstPY=[OAChineseToPinyin sortSectionTitle:name];
            NSString* f=[NSString stringWithFormat:@"%c",firstPY];
            [self.firstPYs addObject:f];
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
            NSMutableSet* set=[NSMutableSet setWithArray:self.firstPYs];
            self.firstPYs=(NSMutableArray*)[set allObjects];
            self.firstPYs=(NSMutableArray*)[self.firstPYs sortedArrayUsingComparator:sort];
        [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
        [self.contactTableView reloadData];
    } fail:^(BOOL notReachable, NSString *desciption) {
        [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
    }];
    }
}
/**
 *  从本地数据库取之前存的承运单位
 */
-(void)loadAllCompanyDataFromCoreData{
    NSFetchRequest* request=[[NSFetchRequest alloc]initWithEntityName:@"DeliveryCompanyAllInfo"];
    NSArray* companys=[ShareAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
    self.firstPYs =[NSMutableArray arrayWithCapacity:companys.count];
    for (DeliveryCompanyAllInfo* info in companys) {
        ChooseCompanyBean* bean=[[ChooseCompanyBean alloc]init];
        bean.name=info.name;
        bean.phoneNumber=info.phoneNumber;
        bean.key=info.key;
        bean.address=info.address;
        [self.tempDatas addObject:bean];
        //解析，取出首字母
        NSString* name=[info.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        char  firstPY=[OAChineseToPinyin sortSectionTitle:name];
        NSString* f=[NSString stringWithFormat:@"%c",firstPY];
        [self.firstPYs addObject:f];
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
    NSMutableSet* set=[NSMutableSet setWithArray:self.firstPYs];
    self.firstPYs=(NSMutableArray*)[set allObjects];
    self.firstPYs=(NSMutableArray*)[self.firstPYs sortedArrayUsingComparator:sort];
    
    [self.contactTableView reloadData];
   
}
/**
 *  处理字母排序
 */
-(void)getNewDataForTableView{
//    sortByPY=nil;
//    sortByPY=[NSMutableArray array];
    NSMutableArray* tempArr=[NSMutableArray array];
    
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
        NSString* name1=[name.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        oldHead=[OAChineseToPinyin sortSectionTitle:name1];
        oldHeader=(NSMutableString*)[NSString stringWithFormat:@"%c",oldHead];
        if (i==0) {
            NSMutableArray *three=[[NSMutableArray alloc] init];
            [three addObject:[self.tempDatas objectAtIndex:i]];
            [tempArr addObject:three];
            continue;
        }
        int j=0;
        for (; j<[tempArr count]; j++) {
            NSMutableArray* arr=(NSMutableArray*)tempArr[j];
            ChooseCompanyBean* name2=arr[0];
            NSString* name3=[name2.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            newHead=[OAChineseToPinyin sortSectionTitle:name3];
            newHeader=(NSMutableString*)[NSString stringWithFormat:@"%c",newHead];
            if ([oldHeader isEqual:newHeader]) {
//                for (ChooseCompanyBean* bean in self.tempDatas[i]) {
//                    [sortByPY[j] addObject:bean];
//                }
                [arr  addObject:name];
                
                break;
            }
        }
        if (j>=tempArr.count) {
            NSMutableArray *three=[[NSMutableArray alloc] init];
            [three addObject:[self.tempDatas objectAtIndex:i]];
            [tempArr addObject:three];
        }
    }
    //排序
    char headerChar;
    NSMutableString* headerLetter;
    NSMutableDictionary* dic=[NSMutableDictionary dictionary];
    for (NSMutableArray* arr in tempArr) {
        ChooseCompanyBean* bean=arr[0];
        NSString* name1=[bean.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        headerChar=[OAChineseToPinyin sortSectionTitle:name1];
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
    NSLog(@"count====%lu",(unsigned long)sortByPY.count);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.firstPYs count];
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.firstPYs[section];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    DeliveryCompanysTableViewCell* cell=(DeliveryCompanysTableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
//    CGSize size=[cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//    if (size.height<44.0) {
//        return 44.0;
//    }else{
//    return size.height+3;
//    }
    return 74;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if ([self.firstPYs count] == 0)
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
//    cell.phoneNumber.text=info.phoneNumber;
    cell.address.text=info.address;
    cell.companyName.text=info.name;
    cell.key=info.key;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DeliveryCompanysTableViewCell* cell=(DeliveryCompanysTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    ChooseCompanyBean* bean=[[ChooseCompanyBean alloc]init];
    bean.name=cell.companyName.text;
    bean.phoneNumber=cell.phoneNumber.text;
    bean.key=cell.key;
    bean.address=cell.address.text;
    self.comDic=bean;
    cell.selected=YES;
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate getDeliverCompany:self.comDic];
}
#pragma BATableViewDelegate
- (NSArray *) sectionIndexTitlesForABELTableView:(BATableView *)tableView {
    return self.firstPYs;
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
            NSString* key=dinfo.key;
            NSRange range=[name rangeOfString:self.searchBtn.text];
            NSRange range2=[num rangeOfString:self.searchBtn.text];
            NSRange range3=[key rangeOfString:self.searchBtn.text];
            if (range.length>0||range2.length>0||range3.length>0) {
                [arr addObject:dinfo];
            }
        }
         self.firstPYs =[NSMutableArray arrayWithCapacity:arr.count];
        for (DeliveryCompanyInfo* info in arr) {
            ChooseCompanyBean* bean=[[ChooseCompanyBean alloc]init];
            bean.name=info.name;
            bean.phoneNumber=info.phoneNumber;
            [self.tempDatas addObject:bean];
            //解析，取出首字母
            char  firstPY=[OAChineseToPinyin sortSectionTitle:info.name];
            NSString* f=[NSString stringWithFormat:@"%c",firstPY];
            [self.firstPYs addObject:f];
        }
      
    }
    if (self.allCompanys.selected) {
        NSFetchRequest* request=[[NSFetchRequest alloc]initWithEntityName:@"DeliveryCompanyAllInfo"];
        NSArray* companys=[ShareAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
        NSMutableArray* arr=[NSMutableArray array];
        for (DeliveryCompanyAllInfo* dinfo in companys) {
            NSString* name=dinfo.name;
            NSString*num=dinfo.phoneNumber;
            NSString* key=dinfo.key;
            NSRange range=[name rangeOfString:self.searchBtn.text];
            NSRange range2=[num rangeOfString:self.searchBtn.text];
            NSRange range3=[key rangeOfString:self.searchBtn.text];
            if (range.length>0||range2.length>0||range3.length>0) {
                [arr addObject:dinfo];
            }
        }
         self.firstPYs =[NSMutableArray arrayWithCapacity:arr.count];
        for (DeliveryCompanyAllInfo* info in arr) {
            ChooseCompanyBean* bean=[[ChooseCompanyBean alloc]init];
            bean.name=info.name;
            bean.phoneNumber=info.phoneNumber;
            [self.tempDatas addObject:bean];
            //解析，取出首字母
            char  firstPY=[OAChineseToPinyin sortSectionTitle:info.name];
            NSString* f=[NSString stringWithFormat:@"%c",firstPY];
            [self.firstPYs addObject:f];
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
        NSMutableSet* set=[NSMutableSet setWithArray:self.firstPYs];
        self.firstPYs=(NSMutableArray*)[set allObjects];
        self.firstPYs=(NSMutableArray*)[self.firstPYs sortedArrayUsingComparator:sort];

        
    }else{
        if (self.searchBtn.text.length>0) {
            
        }else{
                 [self loadAllCompanysInfos];
            }
        
       
    }
    [self.contactTableView reloadData];
}
/**
 *  serachBar shouldEditing
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchBar.text.length==0) {
        [searchBar resignFirstResponder];
        if (self.mostChoosed.selected) {
            [self loadDataFromCoreData];
        }
        if (self.allCompanys.selected) {
            [self loadAllCompanysInfos];
        }
    }

}
@end
