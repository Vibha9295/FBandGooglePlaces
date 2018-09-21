//
//  MapPoint.m
//  GooglePlaces
//
//  Created by van Lint Jason on 6/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapPoint.h"

@implementation MapPoint
@synthesize name = _name;
@synthesize address = _address;
@synthesize coordinate = _coordinate;
@synthesize image = _image;


-(id)initWithtitle:(NSString*)title andAddressIs:(NSString*)address andImageIS:(NSString*)image andCordinateIs:(CLLocationCoordinate2D)coordinate {
//- (id)initWithName:(NSString*)name address:(NSString*)address image:(NSString*)strimage coordinate:(CLLocationCoordinate2D)coordinate{
    if ((self = [super init])) {
        _name = [title copy];
        _address = [address copy];
        _coordinate = coordinate;
        _image = [image copy];
    }
    return self;
}

- (NSString *)title {
    if ([_name isKindOfClass:[NSNull class]]) 
        return @"Unknown charge";
    else
        return _name;
}

- (NSString *)subtitle {
    return _address;
}

@end
