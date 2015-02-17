//
//  ViewController.h
//  LAB06
//
//  Created by Elizabeth Martínez Gómez on 13/02/15.
//  Copyright (c) 2015 Elizabeth Martínez Gómez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <Accounts/Accounts.h>


@interface ViewController : UIViewController <UIApplicationDelegate, ADBannerViewDelegate, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
{
    ADBannerView *adView;
    BOOL bannerIsVisible;
}

@property (strong, nonatomic) IBOutlet UITableView *tblMain;

- (IBAction)btnRefresh:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnMapa;

@end

