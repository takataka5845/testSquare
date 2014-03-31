//
//  MasterViewController.m
//  testSquare
//
//  Created by takashi kato on 2014/03/26.
//  Copyright (c) 2014年 StudioDec2July. All rights reserved.
//

#import "MasterViewController.h"

#import "CheckinViewController.h"
#import "Foursquare2.h"
#import "VenueItem.h"
#import <CoreLocation/CoreLocation.h>

@interface MasterViewController () <CLLocationManagerDelegate, UITableViewDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray *nearbyVenues;
@property (strong, nonatomic) VenueItem *selectedItem;
@property (strong, nonatomic) CLLocation *nowLocation;
@end

@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                               target:self
                                                                               action:@selector(pushedLogoutButton:)];

    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                   target:self
                                                                                   action:@selector(pushedRefreshButton:)];

    self.navigationItem.leftBarButtonItem = refreshButton;
    self.navigationItem.rightBarButtonItem = cancelButton;
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if ([Foursquare2 isAuthorized] == NO) {
        
        NSLog(@"Authorized NO!!");
        
        [self loginToFoursquare];
        
    }
    else {
        NSLog(@"Authorized YES!!");
        [self.locationManager startUpdatingLocation];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.nearbyVenues.count) {
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.nearbyVenues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    VenueItem *venue = self.nearbyVenues[indexPath.row];
    cell.textLabel.text = [venue name];
    
    if (venue.address) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@m, %@",
                                     venue.distance,
                                     venue.address];
    } else {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@m",
                                     venue.distance];
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [self.objects removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//    }
//}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        VenueItem *venue = self.nearbyVenues[indexPath.row];
        [[segue destinationViewController] setDetailItem:venue];
    }
}

#pragma mark - UITableViewDelegate method
-(void)tableView: (UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // 選択状態の解除
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 選択したVenueの内容を保持する
    self.selectedItem = self.nearbyVenues[indexPath.row];
    
    [self userDidSelectVenue];
    
}

#pragma mark - CLLocationManagerDelegate method
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    self.nowLocation = newLocation;
    
    [self.locationManager stopUpdatingLocation];
    [self getVenuesForLocation:newLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"error:%@", [error localizedDescription]);
    [self.locationManager stopUpdatingLocation];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"エラー"
                                                   message:[error localizedDescription]
                                                  delegate:nil
                                         cancelButtonTitle:nil
                                         otherButtonTitles:@"確認", nil];
    [alert show];
    
}

#pragma mark - UIAlertViewDelegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (buttonIndex == 0) {
        NSLog(@"pushed NO Button");
    }
    // はいを選択した場合
    else if (buttonIndex == 1) {
        NSLog(@"pushed YES Button");
        [Foursquare2 removeAccessToken];
    }
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // はいを選択した場合
    if (buttonIndex == 1) {
        
        if ([Foursquare2 isAuthorized] == NO) {
        
            NSLog(@"Authorized NO!!");
        
            [self loginToFoursquare];
        
        }
    }
}

#pragma mark - Private method
- (void) loginToFoursquare {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [Foursquare2 authorizeWithCallback:^(BOOL success, id result) {
        if (success) {
            [Foursquare2  userGetDetail:@"self"
                               callback:^(BOOL success, id result){
                                   if (success) {
                                       NSLog(@"Approved !!");
                                   }
                                   else {
                                       NSLog(@"Not approved...");
                                   }
                               }];
        }
    }];
    
}

- (void)getVenuesForLocation:(CLLocation *)location {
    
    [Foursquare2 venueSearchNearByLatitude:@(location.coordinate.latitude)
                                 longitude:@(location.coordinate.longitude)
                                     query:nil
                                     limit:@(20)
                                    intent:intentCheckin
                                    radius:@(500)
                                categoryId:nil
                                  callback:^(BOOL success, id result){
                                      if (success) {
                                          
                                          NSDictionary *dic = result;
                                          NSArray *venues = [dic valueForKeyPath:@"response.venues"];
                                          for (NSDictionary *venue  in venues) {
                                              NSLog(@"[%@]", [[venue valueForKeyPath:@"categories"]valueForKeyPath:@"id"]);
                                          }
                                          
                                          self.nearbyVenues = [self convertToObjects:venues];
                                          
                                          for (VenueItem *item in self.nearbyVenues) {
                                              NSLog(@"distance[%@]", item.distance);
                                          }
                                          
                                          NSLog(@"nearbyVenues count[%lu]", (unsigned long)self.nearbyVenues.count);
                                          [self.tableView reloadData];
                                          
                                      }
                                  }];
}

- (NSMutableArray *)convertToObjects:(NSArray *)venues {
    
    NSMutableArray *objects = [NSMutableArray array];
    
    for (NSDictionary *venue  in venues) {
        VenueItem *item = [[VenueItem alloc]init];
        item.name = venue[@"name"];
        item.venueId = venue[@"id"];
        
        item.address = venue[@"location"][@"address"];
        item.distance = venue[@"location"][@"distance"];
        
        [item setCoordinate:CLLocationCoordinate2DMake([venue[@"location"][@"lat"] doubleValue],
                                                       [venue[@"location"][@"lng"] doubleValue])];
        [objects addObject:item];
    }
    
    // 距離でソートする
    NSSortDescriptor *sortDistance = [[NSSortDescriptor alloc] initWithKey:@"distance"
                                                                 ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObjects:sortDistance, nil];
    
    return (NSMutableArray *)[objects sortedArrayUsingDescriptors:sortArray];
}

- (void)userDidSelectVenue {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CheckinViewController *checkin = [storyboard instantiateViewControllerWithIdentifier:@"CheckinVC"];
    checkin.detailItem = self.selectedItem;
    checkin.nowLocation = self.nowLocation;
    [self.navigationController pushViewController:checkin animated:YES];
    
}

#pragma mark - Button CallBack
- (void)pushedLogoutButton:(id)sender {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"確認"
                                                   message:@"Foursquareからログアウト\nしますか？"
                                                  delegate:self
                                         cancelButtonTitle:@"いいえ"
                                         otherButtonTitles:@"はい", nil];
    [alert show];
    
}

- (void)pushedRefreshButton:(id)sender {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self.locationManager startUpdatingLocation];
    
}

@end
