//
//  PlaceLocateVCViewController.m
//  FBAndGooglePlace
//
//  Created by bhavik on 9/9/16.
//  Copyright © 2016 bhavik@zaptech. All rights reserved.
//

#import "PlaceLocateVC.h"
#import "tblCellLocationlList.h"
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface PlaceLocateVC()
{
    CLLocation *myCurrentLocation;
    NSArray *arrLocationData;
    NSInteger pointNumber;

}
@end

@implementation PlaceLocateVC
@synthesize mapViewOut,locationManager;

-(void)viewWillAppear:(BOOL)animated {
    self.segmentOut.selectedSegmentIndex = 0;
    self.title = @"Find your place";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    objApplicationData = [ApplicationData sharedInstance];
    self.mapViewOut.delegate = self;
    [self.mapViewOut setShowsUserLocation:YES];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone; //whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager requestAlwaysAuthorization];
    [locationManager startUpdatingLocation];
    firstLaunch=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)segmentContAct:(id)sender
{
    if (self.segmentOut.selectedSegmentIndex == 0) {
        self.mapViewOut.hidden = NO;
        self.tblViewOut.hidden = YES;
    }
    else {
        self.mapViewOut.hidden = YES;
        self.tblViewOut.hidden = NO;
    }
}
#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *currentLocation = [locations lastObject];
    if (currentLocation != nil) {
        myCurrentLocation = currentLocation;
        [mapViewOut setCenterCoordinate:mapViewOut.userLocation.location.coordinate animated:YES];
        // [mapView setRegion:myRegion animated:YES];
        NSLog(@"%@",[NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude]);
        NSLog(@"%@", [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude]);
    }
    
}
-(void) queryGooglePlaces: (NSString *) googleType
{
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=%@&types=%@&sensor=true&key=%@", myCurrentLocation.coordinate.latitude, myCurrentLocation.coordinate.longitude, [NSString stringWithFormat:@"%i", currenDist], googleType, kGOOGLE_API_KEY];
    
    
   

    
   
  
    
    NSURL *googleRequestURL=[NSURL URLWithString:url];
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}
- (void)fetchedData:(NSData *)responseData {
    NSError* error;
    arrLocationData = nil;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    
    NSArray* places = [json objectForKey:@"results"];
    NSLog(@"Google Data: %@", places);
    arrLocationData = places;
    [self.tblViewOut reloadData];
    [self plotPositions:places];
    
    
}

- (void)plotPositions:(NSArray *)data
{
    for (id<MKAnnotation> annotation in mapViewOut.annotations)
    {
        if ([annotation isKindOfClass:[MapPoint class]])
        {
            [mapViewOut removeAnnotation:annotation];
        }
    }
    pointNumber = 0;
    for (int i=0; i<[data count]; i++)
    {
        //Retrieve the NSDictionary object in each index of the array.
        NSDictionary* place = [data objectAtIndex:i];
        
        //There is a specific NSDictionary object that gives us location info.
        NSDictionary *geo = [place objectForKey:@"geometry"];
        
        
        //Get our name and address info for adding to a pin.
        NSString *name=[place objectForKey:@"name"];
        NSString *vicinity=[place objectForKey:@"vicinity"];
        
        NSString *strTempImage;
        
        if ([[place valueForKey:@"photos"] count]) {
            
            NSString *strimgReference = [[[place valueForKey:@"photos"] valueForKey:@"photo_reference"] objectAtIndex:0];
            
            NSLog(@"%@",place);
            
            strTempImage = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=%@&key=%@",strimgReference,kGOOGLE_API_KEY];
                   }
        else {
          
        }
              NSDictionary *loc = [geo objectForKey:@"location"];
        
        CLLocationCoordinate2D placeCoord;
        
        placeCoord.latitude=[[loc objectForKey:@"lat"] doubleValue];
        placeCoord.longitude=[[loc objectForKey:@"lng"] doubleValue];
        
        MapPoint *placeObject = [[MapPoint alloc] initWithtitle:name andAddressIs:vicinity andImageIS:strTempImage andCordinateIs:placeCoord];
        

        [mapViewOut addAnnotation:placeObject];
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *strText = [[NSString stringWithFormat:@"%@",searchBar.text]lowercaseString];
    [searchBar resignFirstResponder];
    [self queryGooglePlaces:strText];
}
- (IBAction)toolBarButtonPress:(id)sender {
  //  UIBarButtonItem *button = (UIBarButtonItem *)sender;
   // NSString *buttonTitle = [button.title lowercaseString];
    //[self queryGooglePlaces:buttonTitle];
}
- (void)viewDidUnload
{
    [self setMapViewOut:nil];
    [super viewDidUnload];
}

#pragma mark - MKMapViewDelegate methods.

- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
    CLLocationCoordinate2D centre = [mv centerCoordinate];
    
    MKCoordinateRegion region;
    
    if (firstLaunch) {
        region = MKCoordinateRegionMakeWithDistance(locationManager.location.coordinate,1000,1000);
        firstLaunch=NO;
    }else {
        region = MKCoordinateRegionMakeWithDistance(centre,currenDist,currenDist);
    }
    [mv setRegion:region animated:YES];
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString *identifier = @"MapPoint";
    
    
    if ([annotation isKindOfClass:[MapPoint class]]) {
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [self.mapViewOut dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            
        } else {
            annotationView.annotation = annotation;
        }
        UIImageView *thumbnailImageView = [[UIImageView alloc] init];
        MapPoint *mapPt = (MapPoint*)annotation;
        NSString *strimgAnnotation = mapPt.image;
        
        
        if (strimgAnnotation.length >10) {
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            dispatch_async(queue, ^(void) {
                UIImage * result;
                
                NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:strimgAnnotation]];
                result = [UIImage imageWithData:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [thumbnailImageView setImage:result];
                });
            });
        }
        else {
            [thumbnailImageView setImage:[UIImage imageNamed:@"dumyPerson"]];
        }

        CGRect newBounds = CGRectMake(0.0, 0.0, 32.0, 32.0);
        [thumbnailImageView setBounds:newBounds];
        annotationView.leftCalloutAccessoryView = thumbnailImageView;
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.animatesDrop = YES;
        
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    MKMapRect mRect = self.mapViewOut.visibleMapRect;
    MKMapPoint eastMapPoint = MKMapPointMake(MKMapRectGetMinX(mRect), MKMapRectGetMidY(mRect));
    MKMapPoint westMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), MKMapRectGetMidY(mRect));
    
    currenDist = MKMetersBetweenMapPoints(eastMapPoint, westMapPoint);
    
    currentCentre = self.mapViewOut.centerCoordinate;
}

#pragma mark - MKMapViewDelegate methods.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrLocationData.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"tblCellLocationlList";
    
    tblCellLocationlList *cell = [self.tblViewOut dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[tblCellLocationlList alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if ([[arrLocationData objectAtIndex:indexPath.row]valueForKey:@"photos"]) {
        
        
            NSString *strimgReference = [[[[arrLocationData objectAtIndex:indexPath.row] valueForKey:@"photos"] valueForKey:@"photo_reference"] objectAtIndex:0];
        
        
        NSLog(@"%@",[arrLocationData objectAtIndex:indexPath.row]);
        
        NSString *mainStr = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=%@&key=%@",strimgReference,kGOOGLE_API_KEY];
        
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            dispatch_async(queue, ^(void) {
                UIImage * result;
                
                NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:mainStr]];
                
                result = [UIImage imageWithData:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.imgViewLocationImg.image = result;
                });
            });
    }
    else {
        cell.imgViewLocationImg.image = [UIImage imageNamed:@"dumyPerson"];
    }
    cell.lblLocationName.text = [[arrLocationData objectAtIndex:indexPath.row] valueForKey:@"name"];
    cell.lblLocationAddress.text = [[arrLocationData objectAtIndex:indexPath.row] valueForKey:@"vicinity"];
    return cell;
}

@end
