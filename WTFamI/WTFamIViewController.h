//
//  WTFamIViewController.h
//  WTFamI
//
//  Created by David Barkman on 10/12/12.
//  Copyright (c) 2012 David Barkman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface WTFamIViewController : UIViewController <CLLocationManagerDelegate, UIAccelerometerDelegate>
{
	CLLocationManager *locationManager;
	
	IBOutlet UILabel *latitudeField;
	IBOutlet UILabel *longitudeField;
	IBOutlet UILabel *altitudeField;
	IBOutlet UILabel *courseField;
	IBOutlet UILabel *speedField;
	IBOutlet UILabel *trueHeadingField;
	IBOutlet UILabel *magneticHeadingField;
	IBOutlet UILabel *distanceField;
	IBOutlet UILabel *maxSpeedField;
	IBOutlet UILabel *averageSpeedField;
	IBOutlet UILabel *timestampField;
	IBOutlet UILabel *xAccelerationLabel;
	IBOutlet UILabel *yAccelerationLabel;
	IBOutlet UILabel *zAccelerationLabel;
    IBOutlet UIProgressView *progress;
	
	UIAccelerationValue x, y, z, calX, calY, calZ;
	
	NSString *latitude;
	NSString *longitude;
	NSString *altitude;
	NSString *course;
	NSString *timestamp;
	NSString *lastTimestamp;
	NSString *speed;
	NSString *lastSpeed;
	NSString *displayedDistance;
	NSString *displayedMaxSpeed;
	NSString *displayedAverageSpped;
	NSString *trueHeading;
	NSString *magneticHeading;
	NSString *displayedAM;
	NSString *displayedX;
	NSString *displayedY;
	NSString *displayedZ;
}

- (IBAction)resetDistance:(id)sender;
- (IBAction)resetMaxSpeed:(id)sender;
- (IBAction)resetAverageSpeed:(id)sender;
- (IBAction)startUpdating:(id)sender;
- (IBAction)stopUpdating:(id)sender;
- (IBAction)pauseCalculations:(id)sender;
- (IBAction)calibrateAccelerometer:(id)sender;

@property (nonatomic) int speedCount;
@property (nonatomic) double sumSpeed;
@property (nonatomic) double maxSpeed;
@property (nonatomic) double averageSpeed;
@property (nonatomic) double calculatedDistance;
@property (nonatomic) bool performCalculations;

@end
