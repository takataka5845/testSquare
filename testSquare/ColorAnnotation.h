//
//  ColorAnnotation.h
//  testSquare
//
//  Created by takashi kato on 2014/03/31.
//  Copyright (c) 2014年 StudioDec2July. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface ColorAnnotation : NSObject <MKAnnotation>

@property(nonatomic, assign)CLLocationCoordinate2D coordinate;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *subtitle;

@end
