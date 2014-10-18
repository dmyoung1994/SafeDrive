//
//  LocationManager.m
//  KickassApp
//
//  Created by Tengyu Cai on 2014-10-17.
//  Copyright (c) 2014 Tengyu Cai. All rights reserved.
//

#import "LocationManager.h"

@interface LocationManager () <CLLocationManagerDelegate>

@end


@implementation LocationManager 

+(LocationManager *) sharedInstance
{
    static LocationManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    return instance;
}

- (id)init {
    self = [super init];
    if(self != nil) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = kCLDistanceFilterNone; // meters
        self.locationManager.delegate = self;
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locationManager requestAlwaysAuthorization];
        }
    }
    return self;
}

- (void)startUpdatingLocation
{
    NSLog(@"Starting location updates");
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"Location service failed with error %@", error);
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray*)locations
{
    CLLocation *location = [locations lastObject];
    NSLog(@"Latitude %+.6f, Longitude %+.6f\n",
          location.coordinate.latitude,
          location.coordinate.longitude);
    self.currentLocation = location;
}

@end
