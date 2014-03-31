//
//  CheckinViewController.h
//  testSquare
//
//  Created by takashi kato on 2014/03/26.
//  Copyright (c) 2014年 StudioDec2July. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "VenueItem.h"

@interface CheckinViewController : UIViewController

@property (strong, nonatomic) VenueItem *detailItem;
@property (strong, nonatomic) CLLocation *nowLocation;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
