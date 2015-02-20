//
//  MapViewController.h
//  LAB06
//
//  Created by Elizabeth Martínez Gómez on 17/02/15.
//  Copyright (c) 2015 Elizabeth Martínez Gómez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <Accounts/Accounts.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>


@interface MapViewController : UIViewController<UIApplicationDelegate, ADBannerViewDelegate,CLLocationManagerDelegate, GMSMapViewDelegate, UIAlertViewDelegate>
{
    ADBannerView *adView;
    BOOL bannerIsVisible;
}

@property (strong, nonatomic) CLLocationManager     *locationManager;
@property (strong, nonatomic) CLLocation            *location;

@property (strong, nonatomic) IBOutlet UIButton *btnLista;
@property (strong, nonatomic) IBOutlet UIButton *btnMapa;
@property (strong, nonatomic) IBOutlet UIView *viewMap;

- (IBAction)btnIr:(id)sender;

- (IBAction)btnMapa:(id)sender;

@end
