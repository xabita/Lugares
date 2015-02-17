//
//  ViewController.m
//  LAB06
//
//  Created by Elizabeth Martínez Gómez on 13/02/15.
//  Copyright (c) 2015 Elizabeth Martínez Gómez. All rights reserved.
//

#import "ViewController.h"
#import "CellLugar.h"
#import "SBJson.h"
#import "AppDelegate.h"


NSDictionary    *jsonResponse;
NSString    *userID;

UIAlertView     *alert;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
     [self cfgiAdBanner];
    [self initController];
    [self postService];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
 Table Functions
 **********************************************************************************************/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//-------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return maNames.count;
}
//-------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}
//-------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"CellLugar");
    static NSString *CellIdentifier = @"CellLugar";
    
    CellLugar *cell = (CellLugar *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[CellLugar alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.lblNombre.text       = maNames[indexPath.row];
   // cell.lblRole.text       = maRole[indexPath.row];
    //cell.lblAge.text        = maAge[indexPath.row];
    
    //NSURL *url = [NSURL URLWithString: maImgs[indexPath.row]];
    // NSData *data =
    //  UIImage *img = [[UIImage alloc] initWithData:data cache:NO];
    //  CGSize size = img.size;
    
    
    
    NSLog(@"URL::: %@", maImgs[indexPath.row]);
    //   cell.imgUser.image      = [UIImage imageNamed: maImgs[indexPath.row]];
    cell.imgView.image  = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:maImgs[indexPath.row]]]];
    
    
    //    cell.imgUser.image      = [UIImage imageNamed: maImgs[indexPath.row]];
    
    return cell;
}

//-------------------------------------------------------------------------------

/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.lblSelectedName.text = maNames[indexPath.row];
    NSString *strTemp;
    
    strTemp = [self.lblSelectedName.text stringByAppendingString: @" fué seleccionado"];
    
    if (indexPath.row == 2)
    {
        alert = [[UIAlertView alloc] initWithTitle:@"Alerta Oaxaca"
                                           message:strTemp
                                          delegate:self
                                 cancelButtonTitle:@"Cancelar"
                                 otherButtonTitles:@"Guardar", @"Publicar", nil];
        [alert show];
    }
}*/

/**********************************************************************************************
 Alert View Functions
 **********************************************************************************************/
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"Alert buttons pressed");
    
    if(buttonIndex == 0)
    {
        NSLog(@"Cancelar");
    }
    else if(buttonIndex == 1)
    {
        NSLog(@"Guardar");
    }
    else if(buttonIndex == 2)
    {
        NSLog(@"Publicar");
    }
}
/*
- (IBAction)btnSharePressed:(id)sender
{
    NSString                    *strMsg;
    NSArray                     *activityItems;
    UIImage                     *imgShare;
    UIActivityViewController    *actVC;
    
    imgShare = [UIImage imageNamed:@"chavo.png"];
    strMsg = @"Hola desde mi clase de iOS de la UAG en Oaxaca =)";
    
    activityItems = @[imgShare, strMsg];
    
    //Init activity view controller
    actVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    actVC.excludedActivityTypes = [NSArray arrayWithObjects:UIActivityTypePrint, UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypeAirDrop, nil];
    
    [self presentViewController:actVC animated:YES completion:nil];
}*/


/*******************************************************************************
 Web Service
 *******************************************************************************/
//-------------------------------------------------------------------------------
- (void) postService
{
    NSLog(@"postService");
    NSOperationQueue *queue = [NSOperationQueue new];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadService) object:nil];
    [queue addOperation:operation];
}
//-------------------------------------------------------------------------------
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
    
  //  maRole        = [jsonResponse valueForKey:@"Surname"];
  //  NSLog(@"maRole %@", maRole);
    
 //   maAge        = [jsonResponse valueForKey:@"Age"];
  //  NSLog(@"maAge %@", maAge);
    
    
    
    //[self.tblMain reloadData];
}


- (IBAction)btnRefresh:(id)sender {
    [self postService];
    [self.tblMain reloadData];

}

- (void)initController
{
    [self postService];
    [self.tblMain reloadData];
   
}

@end
