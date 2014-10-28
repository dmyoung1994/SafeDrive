//
//  CommonViewController.h
//  KickassApp
//
//  Created by Tengyu Cai on 2014-10-17.
//  Copyright (c) 2014 Tengyu Cai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

//Colors
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define CCOLOR [UIColor clearColor]


//Rect and alignment
#define rectX(rect,x) [CommonViewController rectWithRect:rect setX:x]
#define rectWidth(rect,width) [CommonViewController rectWithRect:rect setWidth:width]
#define rectHeight(rect,height) [CommonViewController rectWithRect:rect setHeight:height]
#define rectY(rect,y) [CommonViewController rectWithRect:rect setY:y]

//Resizing masks
#define FLEX_SIZE UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth

#define BUTTON  [UIButton buttonWithType:UIButtonTypeCustom];

#define SVB self.view.bounds
#define SVF self.view.frame

@interface CommonViewController : UIViewController

-(AppDelegate*)appDelegate;


+(UIButton*)button:(NSString*)imageName target:(id)target action:(SEL)action;


//Rect helpers
+(CGRect)rectWithRect:(CGRect)rect setX:(float)x;
+(CGRect)rectWithRect:(CGRect)rect setWidth:(float)width;
+(CGRect)rectWithRect:(CGRect)rect setY:(float)y;
+(CGRect)rectWithRect:(CGRect)rect setHeight:(float)height;

//Activity View
-(void)activity:(BOOL)show;

//Generic properties
-(void)setValue:(id)value withKey:(NSString*)key forObject:(id)_object;
-(id)getValueForKey:(NSString*)key ofObject:(id)_object;
-(id)getObjectWithKey:(NSString*)_key value:(id)_value;

//Generic queries
-(id)itemWithValue:(id)value forKey:(NSString*)key in:(NSArray*)array;
-(id)itemWithPredicate:(NSPredicate*)predicate in:(NSArray*)array;


@end
