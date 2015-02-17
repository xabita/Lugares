//
//  MapaViewController.h
//  LAB06
//
//  Created by Elizabeth Martínez Gómez on 17/02/15.
//  Copyright (c) 2015 Elizabeth Martínez Gómez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <Accounts/Accounts.h>


@interface MapaViewController : UIViewController <UIApplicationDelegate, ADBannerViewDelegate, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
{
    ADBannerView *adView;
    BOOL bannerIsVisible;
}


@property (strong, nonatomic) IBOutlet UIButton *btnRegresar;

@end
