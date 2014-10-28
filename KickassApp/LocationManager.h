//
//  LocationManager.h
//  KickassApp
//
//  Created by Tengyu Cai on 2014-10-17.
//  Copyright (c) 2014 Tengyu Cai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define LM [LocationManager sharedInstance]

@interface LocationManager : NSObject

+(LocationManager *) sharedInstance;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;

- (void)startUpdatingLocation;

@end