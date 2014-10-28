//
//  CommonViewController.m
//  KickassApp
//
//  Created by Tengyu Cai on 2014-10-17.
//  Copyright (c) 2014 Tengyu Cai. All rights reserved.
//

#import "CommonViewController.h"

@interface CommonViewController ()

@end

@implementation CommonViewController  {
    NSMutableArray *propertiesArray;
    UIActivityIndicatorView *activityView;
}


-(void)loadView{
    
    self.view = [[UIView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.autoresizingMask = FLEX_SIZE;
    
    
}

//
//-(UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleLightContent;
//}



-(AppDelegate*)appDelegate{
    return (AppDelegate*) [[UIApplication sharedApplication] delegate];
}


#pragma mark - Button

+(UIButton*)button:(NSString*)imageName target:(id)target action:(SEL)action{
    UIButton *button = BUTTON;
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}


#pragma mark - Rect helpers

+(CGRect)rectWithRect:(CGRect)rect setX:(float)x{
    CGRect _rect = rect;
    _rect.origin.x = x;
    return _rect;
}

+(CGRect)rectWithRect:(CGRect)rect setWidth:(float)width{
    CGRect _rect = rect;
    _rect.size.width = width;
    return _rect;
}

+(CGRect)rectWithRect:(CGRect)rect setHeight:(float)height{
    CGRect _rect = rect;
    _rect.size.height = height;
    return _rect;
}

+(CGRect)rectWithRect:(CGRect)rect setY:(float)y{
    CGRect _rect = rect;
    _rect.origin.y = y;
    return _rect;
}


#pragma mark - Generic properties

-(void)setValue:(id)value withKey:(NSString*)key forObject:(id)_object{
    if(!propertiesArray){
        propertiesArray = @[].mutableCopy;
    }
    
    if (!value) {
        NSArray *resultsArray = [propertiesArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"key == %@ && object == %@",key, _object]];
        if (resultsArray.count > 0) {
            [propertiesArray removeObject:resultsArray[0]];
        }
        return;
    }
    
    [propertiesArray addObject:@{@"object": _object , @"key" : key , @"value" : value}];
    
}

-(id)getValueForKey:(NSString*)key ofObject:(id)_object{
    
    NSArray *resultsArray = [propertiesArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"key == %@ && object == %@",key, _object]];
    if (resultsArray.count > 0) {
        return resultsArray[0][@"value"];
    }
    
    return nil;
}

-(id)getObjectWithKey:(NSString*)_key value:(id)_value{
    
    NSArray *resultsArray = [propertiesArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"key == %@ && value == %@",_key, _value]];
    if (resultsArray.count > 0) {
        return resultsArray[0][@"object"];
    }
    
    return nil;
}

#pragma mark - Activity

-(void)activity:(BOOL)show
{
    if (show) {
        if (!activityView) {
            activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            activityView.frame = (CGRect){SVB.size.width/2 - 120/2, 150, 120, 100};
            activityView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
            activityView.backgroundColor = RGBA(0, 0, 0, 0.6);
            activityView.layer.cornerRadius = 15;
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        }
        [self.view addSubview:activityView];
        [self.view bringSubviewToFront:activityView];
        [activityView startAnimating];
    }else{
        [activityView removeFromSuperview];
        [activityView stopAnimating];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }
    
}

#pragma mark - Generic Queries

-(id)itemWithValue:(id)value forKey:(NSString*)key in:(NSArray*)array{
    
    return [self itemWithPredicate:[NSPredicate predicateWithFormat:@"%K == %@", key, value] in:array];
}

-(id)itemWithPredicate:(NSPredicate*)predicate in:(NSArray*)array{
    
    NSArray *ra = [array filteredArrayUsingPredicate:predicate];
    if (ra.count == 1) {
        return ra[0];
    }
    
    return nil;
}



@end
