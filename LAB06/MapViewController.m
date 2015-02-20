//
//  MapViewController.m
//  LAB06
//
//  Created by Elizabeth Martínez Gómez on 17/02/15.
//  Copyright (c) 2015 Elizabeth Martínez Gómez. All rights reserved.
//

#import "MapViewController.h"
#import "SBJson.h"
#import "AppDelegate.h"

NSDictionary    *jsonResponse;
NSString    *userID;
int contador;
int i;
NSString    *strUserLocation;
float       mlatitude;
float       mlongitude;

GMSMapView *mapView;


@interface MapViewController(){
    UIApplication *application;
}
@end


@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self cfgiAdBanner];

    
    
    //-------------------------------------------------------------------------------
    //Location
    self.locationManager                    = [[CLLocationManager alloc] init];
    self.locationManager.delegate           = self;
    self.location                           = [[CLLocation alloc] init];
    self.locationManager.desiredAccuracy    = kCLLocationAccuracyKilometer;
    [self.locationManager  requestWhenInUseAuthorization];
    [self.locationManager  requestAlwaysAuthorization];
    
    [self.locationManager startUpdatingLocation];
    
    [self loadService];
    
    NSLog(@"contador %d", contador);
    
    
    
    
}

- (void)cfgiAdBanner
{
    // Setup iAdView
    adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    
    //Set coordinates for adView
    CGRect adFrame      = adView.frame;
    adFrame.origin.y    = self.view.frame.size.height - 50;
    NSLog(@"adFrame.origin.y: %f",adFrame.origin.y);
    adView.frame        = adFrame;
    
    [adView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    [self.view addSubview:adView];
    adView.delegate         = self;
    adView.hidden           = YES;
    self->bannerIsVisible   = NO;
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!self->bannerIsVisible)
    {
        adView.hidden = NO;
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        // banner is invisible now and moved out of the screen on 50 px
        [UIView commitAnimations];
        self->bannerIsVisible = YES;
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (self->bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        // banner is visible and we move it out of the screen, due to connection issue
        [UIView commitAnimations];
        adView.hidden = YES;
        self->bannerIsVisible = NO;
    }
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    NSLog(@"Banner view is beginning an ad action");
    BOOL shouldExecuteAction = YES;
    if (!willLeave && shouldExecuteAction)
    {
        // stop all interactive processes in the app
        // [video pause];
        // [audio pause];
    }
    return shouldExecuteAction;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    // resume everything you've stopped
    // [video resume];
    // [audio resume];
}

/***********       fin banner ***********/




/**********************************************************************************************
 Localization
 **********************************************************************************************/
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.location = locations.lastObject;
    NSLog( @"didUpdateLocation!");
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:self.locationManager.location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         for (CLPlacemark *placemark in placemarks)
         {
             NSString *addressName = [placemark name];
             NSString *city = [placemark locality];
             NSString *administrativeArea = [placemark administrativeArea];
             NSString *country  = [placemark country];
             NSString *countryCode = [placemark ISOcountryCode];
             NSLog(@"name is %@ and locality is %@ and administrative area is %@ and country is %@ and country code %@", addressName, city, administrativeArea, country, countryCode);
             strUserLocation = [[administrativeArea stringByAppendingString:@","] stringByAppendingString:countryCode];
             NSLog(@"gstrUserLocation = %@", strUserLocation);
         }
         mlatitude = self.locationManager.location.coordinate.latitude;
         //[mUserDefaults setObject: [[NSNumber numberWithFloat:mlatitude] stringValue] forKey: pmstrLatitude];
         mlongitude = self.locationManager.location.coordinate.longitude;
         //[mUserDefaults setObject: [[NSNumber numberWithFloat:mlatitude] stringValue] forKey: pmstrLatitude];
         NSLog(@"mlatitude = %f", mlatitude);
         NSLog(@"mlongitude = %f", mlongitude);
     }];
}





- (void)paintMap
{
    //-------------------------------------------------------------------------------
    //Google Maps
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:mlatitude
                                                            longitude:mlongitude
                                                                 zoom:10];
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView.frame = CGRectMake(0, 0, self.viewMap.frame.size.width, self.viewMap.frame.size.height);
    mapView.myLocationEnabled = YES;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(mlatitude, mlongitude);
    marker.title = @"Master UAG";
    marker.snippet = @"A punto de salir!";
    marker.map = mapView;
    [self.viewMap addSubview:mapView];
    
     for (i=0; i<contador; i++) {
        GMSMarker *marker1 = [[GMSMarker alloc] init];
        
        marker1.position = CLLocationCoordinate2DMake([maLatitud[i] floatValue], [maLongitud[i] floatValue]);
        marker1.title = maNames[i];
        marker1.snippet = maTime[i];
        marker1.map = mapView;
        
    }
}




- (void) loadService
{
    @try
    {
        NSString *post = [[NSString alloc] initWithFormat:@"id=%@", userID];
        NSLog(@"postService: %@",post);
        NSURL *url = [NSURL URLWithString:@"http://ec2-52-10-83-70.us-west-2.compute.amazonaws.com/"];
        NSLog(@"URL postService = %@", url);
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        [NSURLRequest requestWithURL:url];
        NSError *error = [[NSError alloc] init];
        NSHTTPURLResponse *response = nil;
        NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        //-------------------------------------------------------------------------------
        if ([response statusCode] >=200 && [response statusCode] <300)
        {
            jsonResponse = [NSJSONSerialization JSONObjectWithData:urlData options:kNilOptions error:&error];
        }
        else
        {
            if (error)
            {
                NSLog(@"Error");
                
            }
            else
            {
                NSLog(@"Conect Fail");
            }
        }
        //-------------------------------------------------------------------------------
    }
    @catch (NSException * e)
    {
        NSLog(@"Exception");
    }
    //-------------------------------------------------------------------------------
    
    NSLog(@"jsonResponse %@", jsonResponse);
    maNames         = [jsonResponse valueForKey:@"nom_lugar"];
    NSLog(@"maNames %@", maNames);
    
    maImgs        = [jsonResponse valueForKey:@"url_imagen"];
    NSLog(@"maImgs %@", maImgs);
    
    
    NSLog(@"jsonResponseMAPAAAAA %@", jsonResponse);
    maLatitud         = [jsonResponse valueForKey:@"latitud"];
    NSLog(@"maLatitud %@", maLatitud);
    contador          = maLatitud.count;
    
    maLongitud        = [jsonResponse valueForKey:@"longitud"];
    NSLog(@"maLongitud %@", maLongitud);
    
    maAddress        = [jsonResponse valueForKey:@"direccion"];
    NSLog(@"maAddress %@", maAddress);
    
    maTime        = [jsonResponse valueForKey:@"horario"];
    NSLog(@"maTime %@", maTime);
    
}

-(void) mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker
{
    
    NSString *message=[NSString stringWithFormat:@"hola mapa %@marker", marker.title];

   UIAlertView *windowTapped=[[UIAlertView alloc]
                              initWithTitle:@"Info Window Tapped!"
                              message:message
                              delegate:nil
                              cancelButtonTitle:@"Alright!"
                              otherButtonTitles:nil];
    [windowTapped show];
    
                              
}



- (IBAction)btnIr:(id)sender {
    NSString *url = [NSString stringWithFormat:@"https://www.google.com.mx/maps/dir/%f,%f/17.0767621,-96.7641893/", mlatitude, mlongitude];
                     
   // NSLog(@"URLLOCATION---- :%@", url);
    
    if (!application) application =   [UIApplication sharedApplication];
                                          [application  openURL:
                                           [NSURL URLWithString:url ]];
}

- (IBAction)btnMapa:(id)sender {
     [self paintMap];
}
@end
