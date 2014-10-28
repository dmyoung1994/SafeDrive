//
//  MainViewController.m
//  KickassApp
//
//  Created by Tengyu Cai on 2014-10-17.
//  Copyright (c) 2014 Tengyu Cai. All rights reserved.
//

#import "MainViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "LocationManager.h"

@interface MainViewController () <UIAlertViewDelegate>

@end

@implementation MainViewController {
    GMSMapView *mapView_;
    CLLocation *currentLocation;
    NSTimer *timer;
    GMSAddress *currentAddress;
    BOOL start;
    UIButton *button;
    GMSMarker *marker;
}

-(void)loadView {
    [super loadView];
    
    self.view.backgroundColor = RGB(237, 237, 237);
    [LM startUpdatingLocation];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:0 longitude:0 zoom:6];
    mapView_ = [GMSMapView mapWithFrame:(CGRect){0,0,SVB.size.width,SVB.size.height-100} camera:camera];
    mapView_.myLocationEnabled = YES;
    [self.view addSubview:mapView_];
    
    mapView_.settings.myLocationButton = YES;
    
    float y = CGRectGetMaxY(mapView_.frame);
    
    button = [[UIButton alloc] initWithFrame:(CGRect){30, y+20, SVB.size.width-2*30, SVB.size.height-y-2*20}];
    [button addTarget:self action:@selector(startAction) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Start" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:20];
    button.backgroundColor = RGBA(30, 130, 230, 0.8);
    [self.view addSubview:button];
    
    currentAddress = nil;
    start = NO;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(updateAction:) userInfo:nil repeats:YES];
    [timer fire];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    GMSCameraPosition *curLocation = [GMSCameraPosition cameraWithLatitude:mapView_.myLocation.coordinate.latitude
                                                            longitude:mapView_.myLocation.coordinate.longitude
                                                                 zoom:15];
    [mapView_ setCamera:curLocation];
    
    marker = [[GMSMarker alloc] init];
    marker.position = mapView_.myLocation.coordinate;
    marker.title = @"Current Location";
    marker.map = mapView_;
}


-(void)startAction
{
    start = !start;
    if (start) {
        [button setTitle:@"End" forState:UIControlStateNormal];
        button.backgroundColor = [UIColor redColor];
    } else {
        [button setTitle:@"Start" forState:UIControlStateNormal];
        button.backgroundColor = RGBA(30, 130, 230, 0.8);
    }
    
}

-(void)mojioAction:(NSTimer*)timer {
    
    if (!start || !marker) {
        return;
    }
    
    
}


-(void)updateAction:(NSTimer*)timer {
    
    if (!start || !marker) {
        return;
    }
    
//    int rand1 = arc4random()%3-1;
//    int rand2 = arc4random()%3-1;
//    NSLog(@"%d, %d", rand1, rand2);
//    marker.position = CLLocationCoordinate2DMake(marker.position.latitude+0.005*rand1, marker.position.longitude+0.005*rand2);
    NSURL *mojioURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://69.164.195.224:3000/api/mojio"]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:mojioURL
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    [request setHTTPMethod:@"GET"];
    NSError *requestError = NULL;
    NSURLResponse *urlResponse = NULL;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    NSDictionary *dic;
    if (!requestError) {
        dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        NSLog(@"%@", dic);
    } else {
        NSLog(@"ERROR : %@", requestError);
        return;
    }
    
    double lat = [dic[@"location"][@"lat"] doubleValue];
    double lng = [dic[@"location"][@"lng"] doubleValue];
    marker.position = CLLocationCoordinate2DMake(lat, lng);
    
    mapView_.camera = [GMSCameraPosition cameraWithLatitude:marker.position.latitude longitude:marker.position.longitude zoom:14];
    
    [[GMSGeocoder geocoder] reverseGeocodeCoordinate:marker.position completionHandler:^(GMSReverseGeocodeResponse *response, NSError *error) {
        
        GMSAddress *address = response.results[0];
        
        if (!address) {
            return;
        }
        
        if (currentAddress && [address.postalCode isEqualToString:currentAddress.postalCode]) {
            return;
        } else {
            currentAddress = address;
            marker.position = address.coordinate;
            
            // Send hoods request
            NSURL *hoodsURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://69.164.195.224:3000/api/hoods?zip=%@", address.postalCode]];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:hoodsURL
                                                                   cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                               timeoutInterval:10];
            [request setHTTPMethod:@"GET"];
            NSError *requestError = NULL;
            NSURLResponse *urlResponse = NULL;
            NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
            if (!requestError) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
                NSLog(@"%@", dic);
            } else {
                NSLog(@"ERROR : %@", requestError);
            }
            
            // Send crime request
            NSURL *crimeURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://69.164.195.224:3000/api/crime?lat=%f&lon=%f", address.coordinate.latitude, address.coordinate.longitude]];
            request = [NSMutableURLRequest requestWithURL:crimeURL
                                              cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                          timeoutInterval:10];
            [request setHTTPMethod:@"GET"];
            requestError = NULL;
            urlResponse = NULL;
            data = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
            if (!requestError) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
                NSLog(@"%@", dic);
                [self showCrimeMessage:dic];
            } else {
                NSLog(@"ERROR : %@", requestError);
            }
        }
    }];
}

-(void)showCrimeMessage:(NSDictionary*)dic
{
    NSNumber *count = dic[@"totalCrime"];
    if (count.integerValue) {
        [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Crime count: %@", count] message:nil delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];
    }
    
}

#pragma mark - AlertView

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 1:
            break;
            
        default:
            break;
    }
}



-(void)getCurrentLocation
{
    //currentLocation = [LM currentLocation];
    
    NSLog(@"User's location: %@", mapView_.myLocation);
    
    CLLocationCoordinate2D location;
    NSMutableArray *searchArray = @[].mutableCopy;
    
    for (int row = -2; row <= 2; ++row) {
        for (int col = -2; col <= 2; ++col) {
            location = CLLocationCoordinate2DMake(mapView_.myLocation.coordinate.latitude + row*0.01, mapView_.myLocation.coordinate.longitude + col*0.01);
            [[GMSGeocoder geocoder] reverseGeocodeCoordinate:location completionHandler:^(GMSReverseGeocodeResponse *response, NSError *error) {
                
                GMSAddress *address = response.results[0];

                
                [searchArray addObject:address];
                
                NSLog(@"%@",address.postalCode);
                
                // Send hoods request
                NSURL *hoodsURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://69.164.195.224:3000/api/hoods?zip=%@", address.postalCode]];
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:hoodsURL
                                                                       cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                                   timeoutInterval:10];
                [request setHTTPMethod:@"GET"];
                NSError *requestError = NULL;
                NSURLResponse *urlResponse = NULL;
                NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
                if (!requestError) {
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
                    NSLog(@"%@", dic);
                } else {
                    NSLog(@"ERROR : %@", requestError);
                }
                
                // Send crime request
                NSURL *crimeURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://69.164.195.224:3000/api/crime?lat=%f&lng=%f", address.coordinate.latitude, address.coordinate.longitude]];
                request = [NSMutableURLRequest requestWithURL:crimeURL
                                                  cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                              timeoutInterval:10];
                [request setHTTPMethod:@"GET"];
                requestError = NULL;
                urlResponse = NULL;
                data = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
                if (!requestError) {
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
                    NSLog(@"%@", dic);
                } else {
                    NSLog(@"ERROR : %@", requestError);
                }

    
            }];
        }
    }
}


@end
