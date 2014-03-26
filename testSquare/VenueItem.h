//
//  VenueItem.h
//  testSquare
//
//  Created by takashi kato on 2014/03/26.
//  Copyright (c) 2014年 StudioDec2July. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface VenueItem : NSObject
@property (nonatomic, strong)NSNumber *distance;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *venueId;
@property (nonatomic, strong)NSString *address;
@property (nonatomic, assign)CLLocationCoordinate2D coordinate;
@end
