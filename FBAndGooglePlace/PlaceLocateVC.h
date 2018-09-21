//
//  PlaceLocateVCViewController.h
//  FBAndGooglePlace
//
//  Created by bhavik on 9/9/16.
//  Copyright © 2016 bhavik@zaptech. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ApplicationData.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MapPoint.h"

#define kGOOGLE_API_KEY @"AIzaSyAz1ppHohtpvT10KLZCK7KScmamx5QThNc"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
@interface PlaceLocateVC : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    CLLocationManager *locationManager;
    
    CLLocationCoordinate2D currentCentre;
    int currenDist;
    BOOL firstLaunch;
    ApplicationData *objApplicationData;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentOut;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBarOut;
- (IBAction)segmentContAct:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tblViewOut;
@property (weak, nonatomic) IBOutlet MKMapView *mapViewOut;
@property (strong ,nonatomic)    CLLocationManager *locationManager;

@end
