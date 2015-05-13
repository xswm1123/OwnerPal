//
//  SelectPeopleListViewController.h
//  OwnerPal
//
//  Created by NewDoone on 15/4/20.
//  Copyright (c) 2015年 NewDoone. All rights reserved.
//

#import "BaseViewController.h"
#import "SelectedReceiverInfoBean.h"
@class SelectPeopleListViewController;
@protocol SelectedPeopleDelegate <NSObject>

-(void)getSelectedPeople:(SelectedReceiverInfoBean*) peopleDic;

@end


@interface SelectPeopleListViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *tf_search;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,weak) id<SelectedPeopleDelegate> delegate;
@end
