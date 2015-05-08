//
//  KLMapViewController.h
//  Klike
//
//  Created by Anton Katekov on 07.05.15.
//  Copyright (c) 2015 SFÇD, LLC. All rights reserved.
//

#import "KLViewController.h"
#import <MapKit/MapKit.h>



@class KLLocation;



@interface KLMapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic) KLLocation *location;

@end



@interface KLAnnotationView : MKAnnotationView

@end



@interface KLMapViewController : KLViewController {
    
    MKMapItem *_mapItem;
    IBOutlet MKMapView *_map;
}

@property (nonatomic) KLLocation * location;

@end
