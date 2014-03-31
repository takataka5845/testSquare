//
//  CheckinViewController.m
//  testSquare
//
//  Created by takashi kato on 2014/03/26.
//  Copyright (c) 2014年 StudioDec2July. All rights reserved.
//

#import "CheckinViewController.h"
#import "ColorAnnotation.h"
#import "Foursquare2.h"
#import <MapKit/MapKit.h>

@interface CheckinViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)pushedCheckinButton:(id)sender;

@end

@implementation CheckinViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
    }
}

- (IBAction)pushedCheckinButton:(id)sender {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // チェックイン
    [Foursquare2 checkinAddAtVenue:@"" //self.detailItem.venueId
                             shout:@"test test!!"
                          callback:^(BOOL success, id result) {
                              if (success) {
                                  NSLog(@"result[%@]", result);
                                  //self.checkin = [result valueForKeyPath:@"response.checkin.id"];
                                  [self showAlertViewWithTitle:@"Checkin Successfull" message:nil];
                              }
                              else {
                                  NSError *error = (NSError *)result;
                                  NSString *text = [error.userInfo valueForKey:NSLocalizedDescriptionKey];
                                  NSLog(@"result[%@]", text);
                                  [self showAlertViewWithTitle:@"Checkin Failure" message:text];
                              }
                          }];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"nowLocation  :latitude[%f] longitude[%f]",
          self.nowLocation.coordinate.latitude, self.nowLocation.coordinate.longitude);
    
    NSLog(@"venueLocation:latitude[%f] longitude[%f]",
          self.detailItem.coordinate.latitude, self.detailItem.coordinate.longitude);
    
    // 表示倍率の設定と地図の中心座標をチェックイン対象に設定
    MKCoordinateSpan span = MKCoordinateSpanMake(0.003, 0.003);
    MKCoordinateRegion region = MKCoordinateRegionMake(self.mapView.userLocation.coordinate, span);
    region.center = self.detailItem.coordinate;
    [self.mapView setRegion:region animated:YES];
    
    self.detailDescriptionLabel.text = self.detailItem.name;
}

- (void)viewDidAppear:(BOOL)animated {
    
    // 現在位置
    ColorAnnotation *pin1 = [[ColorAnnotation alloc]init];
    pin1.coordinate = self.nowLocation.coordinate;
    pin1.title = @"現在位置";
    [self.mapView addAnnotation:pin1];
    
    // チェックイン対象
    ColorAnnotation *pin2 = [[ColorAnnotation alloc]init];
    pin2.coordinate = self.detailItem.coordinate;
    pin2.title = self.detailItem.name;
    [self.mapView addAnnotation:pin2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MKMapViewDelegate method
// アノテーションが表示される時に呼ばれる
-(MKAnnotationView*)mapView:(MKMapView*)mapView
          viewForAnnotation:(id)annotation{
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"annotation name[%@]", ((ColorAnnotation *)annotation).title);
    
    MKPinAnnotationView *pin =
    (MKPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"pin"];
    
    if(pin == nil){
        pin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"pin"];
    }
    
    // アニメーションをする
    pin.animatesDrop = YES;
    
    // 現在位置の場合
    ColorAnnotation *color = (ColorAnnotation *)annotation;
    if ((color.coordinate.longitude == self.nowLocation.coordinate.longitude)
        && (color.coordinate.latitude == self.nowLocation.coordinate.latitude) ){
        pin.pinColor = MKPinAnnotationColorRed;  // ピンの色を赤にする
    }
    // チェックイン対象の場合
    else {
        pin.pinColor = MKPinAnnotationColorPurple;  // ピンの色を紫にする
    }
    
    // ピンタップ時にコールアウトを表示する
    pin.canShowCallout = YES;
    
    return pin;
    
}

// アノテーションの追加後に呼ばれる
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    
    for (ColorAnnotation *annotation in self.mapView.annotations) {
        
        if ((annotation.coordinate.longitude == self.nowLocation.coordinate.longitude)
            && (annotation.coordinate.latitude == self.nowLocation.coordinate.latitude) ){
            
            // なにもしない
            
        }
        else {
            [self.mapView selectAnnotation:annotation animated:YES];
        }
        
    }
    
}

#pragma mark - Private method
- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)detail{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:detail
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
