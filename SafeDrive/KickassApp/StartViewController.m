//
//  StartViewController.m
//  KickassApp
//
//  Created by Tengyu Cai on 2014-10-18.
//  Copyright (c) 2014 Tengyu Cai. All rights reserved.
//

#import "StartViewController.h"

@interface StartViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@end

@implementation StartViewController {
    UITableView *startTableView;
    BOOL mojioOn;
    UITextField *userIdField;
    UITextField *passwordField;
}

-(void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = RGB(237, 237, 237);
    
    startTableView = [[UITableView alloc] initWithFrame:SVB style:UITableViewStyleGrouped];
    startTableView.delegate = self;
    startTableView.dataSource = self;
    startTableView.backgroundColor = CCOLOR;
    [startTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"xxx"];
    startTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:startTableView];
    
    mojioOn = false;
}

#pragma mark - Action

-(void)switchAction:(UISwitch*)mySwitch
{
    mojioOn = !mojioOn;
}

#pragma mark - TableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 2;
    }
    return 1;
    
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"xxx" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            userIdField = [[UITextField alloc] initWithFrame:(CGRect){30,5,cell.contentView.frame.size.width-2*30,cell.contentView.frame.size.height-2*5}];
            userIdField.backgroundColor = RGB(230, 230, 230);
            userIdField.placeholder = @" User ID";
            userIdField.delegate = self;
            cell.contentView.backgroundColor = CCOLOR;
            cell.backgroundColor = CCOLOR;
            [cell.contentView addSubview: userIdField];
        } else if (indexPath.row == 1) {
            passwordField = [[UITextField alloc] initWithFrame:(CGRect){30,5,cell.contentView.frame.size.width-2*30,cell.contentView.frame.size.height-2*5}];
            passwordField.backgroundColor = RGB(230, 230, 230);
            passwordField.placeholder = @" Password";
            passwordField.secureTextEntry = YES;
            passwordField.delegate = self;
            cell.contentView.backgroundColor = CCOLOR;
            cell.backgroundColor = CCOLOR;
            [cell.contentView addSubview: passwordField];
        }
        
    } else if (indexPath.section == 1) {
        
//        if (indexPath.row == 0) {
//            cell.textLabel.text = @"Use Mojio";
//            UISwitch *mojioSwitch = [[UISwitch alloc] init];
//            mojioSwitch.frame = (CGRect){0, 0, mojioSwitch.bounds.size};
//            [mojioSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventEditingChanged];
//            cell.accessoryView = mojioSwitch;
//        }
        cell.contentView.backgroundColor = CCOLOR;
        cell.backgroundColor = CCOLOR;
        
    } else if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Log In";
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.backgroundColor = RGBA(30, 130, 230, 1);
            cell.accessoryView.backgroundColor =  RGBA(30, 130, 230, 1);
            
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        if ([self hasAllRequiredFields]) {
            [self.appDelegate transitionToMain];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Enter userId and password" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        }
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 100;
            break;
        case 1:
            return 75;
        case 2:
            return 15;
        default:
            return 0;
            break;
    }
}

#pragma mark - uitextfield delegate
//
//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    if (textField == userIdField || textField == passwordField) {
//        
//        NSCharacterSet *blockedCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890"] invertedSet];
//        if ([string rangeOfCharacterFromSet:blockedCharacters].location != NSNotFound) {
//            return NO;
//        }
//        //textField.text = [textField.text stringByReplacingCharactersInRange:range withString:[string uppercaseString]];
//        return NO;
//    }
//    
//    return YES;
//}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == userIdField) {
        [passwordField becomeFirstResponder];
    } else if (textField == passwordField) {
        [passwordField resignFirstResponder];
    }
    return YES;
}

-(BOOL)hasAllRequiredFields
{
    BOOL has = NO;
    
    if (passwordField.text.length  && userIdField.text.length) {
        has = YES;
    }
    return has;
}


@end
