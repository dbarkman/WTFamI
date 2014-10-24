//
//  WTFamIViewController.m
//  WTFamI
//
//  Created by David Barkman on 10/12/12.
//  Copyright (c) 2012 David Barkman. All rights reserved.
//

#import "WTFamIViewController.h"

@interface WTFamIViewController ()

@end

@implementation WTFamIViewController

@synthesize speedCount, sumSpeed, averageSpeed, calculatedDistance, performCalculations;

#define kAccelerometerFrequency 1.0 //Hz

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
	if (self) {
		locationManager = [[CLLocationManager alloc] init];
		[locationManager setDelegate:self];
		[locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
		[locationManager startUpdatingLocation];
		[locationManager startUpdatingHeading];
//		[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / kAccelerometerFrequency)];
//		[[UIAccelerometer sharedAccelerometer] setDelegate:self];
	}
    
	
	performCalculations = YES;
	
	return self;
}

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"Here 1");
	CLLocationSpeed clSpeed = newLocation.speed * 2.2369;
	
	NSString *latitude = [NSString stringWithFormat:@"%.4f", newLocation.coordinate.latitude];
	NSString *longitude = [NSString stringWithFormat:@"%.4f", newLocation.coordinate.longitude];
	NSString *altitude = [NSString stringWithFormat:@"%.2f", newLocation.altitude / 3.28084];
	NSString *course = [NSString stringWithFormat:@"%.4f", newLocation.course];
	NSString *timestamp = [NSString stringWithFormat:@"%@", newLocation.timestamp.description];
	NSString *speed = [NSString stringWithFormat:@"%.1f", clSpeed];
	
	if (performCalculations == YES) {
		if (oldLocation != nil) {
			CLLocationDistance distance = [newLocation distanceFromLocation:oldLocation];
			calculatedDistance += distance;
		}
		
		//should set this in a preference
		if (clSpeed > 0) {
			speedCount++;
			sumSpeed += clSpeed;
			averageSpeed = sumSpeed / speedCount;
		}
	}
	NSString *displayedDistance = [NSString stringWithFormat:@"Distance: %.2f", calculatedDistance * 0.00062137119];
	NSString *displayedAverageSpped = [NSString stringWithFormat:@"Average Speed: %.1f", averageSpeed];
	NSString *displayedSpeedCount = [NSString stringWithFormat:@"%i", speedCount];
	
	NSLog(@"%@", latitude);
	
	[latitudeField setText:latitude];
	[longitudeField setText:longitude];
	[altitudeField setText:altitude];
	[courseField setText:course];
	[speedField setText:speed];
	[timestampField setText:timestamp];
	[distanceField setText:displayedDistance];
	[averageSpeedField setText:displayedAverageSpped];
	[speedCountField setText:displayedSpeedCount];
}

//- (void)locationManager:(CLLocationManager *)manager
//	   didUpdateHeading:(CLHeading *)newHeading
//{
//	NSString *trueHeading = [NSString stringWithFormat:@"T: %.3f", newHeading.trueHeading];
//	NSString *magneticHeading = [NSString stringWithFormat:@"M: %.3f", newHeading.magneticHeading];
//	
//	NSLog(@"%@", trueHeading);
//	
//	[trueHeadingField setText:trueHeading];
//	[magneticHeadingField setText:magneticHeading];
//}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
	NSLog(@"Acceleration Sensed!!");
	
    x = acceleration.x + calX;
    y = acceleration.y + calY;
    z = acceleration.z + calZ;
	
	double accelMagnitude = sqrt(
		x * x +
		y * y +
		z * z);
	
	NSString *displayedAM = [NSString stringWithFormat:@"%f", accelMagnitude];
	NSLog(@"%@", displayedAM);
	
	NSString *displayedX = [NSString stringWithFormat:@"%.1f", x];
	NSString *displayedY = [NSString stringWithFormat:@"%.1f", y];
	NSString *displayedZ = [NSString stringWithFormat:@"%.1f", z];
	
	[xAccelerationLabel setText:displayedX];
	[yAccelerationLabel setText:displayedY];
	[zAccelerationLabel setText:displayedZ];
}

- (IBAction)calibrateAccelerometer:(id)sender
{
	calX = 0 - x;
	calY = 0 - y;
	calZ = 0 - z;
}

- (IBAction)resetDistance:(id)sender
{
	calculatedDistance = 0;
	[distanceField setText:@"Distance: 0.00"];
}

- (IBAction)resetAverageSpeed:(id)sender
{
	speedCount = 0;
	sumSpeed = 0;
	[averageSpeedField setText:@"Average Speed: 0.0"];
	[speedCountField setText:@"0"];
}

- (IBAction)startUpdating:(id)sender
{
	[locationManager startUpdatingLocation];
	[locationManager startUpdatingHeading];
}

- (IBAction)stopUpdating:(id)sender
{
	[locationManager stopUpdatingLocation];
	[locationManager stopUpdatingHeading];
}

- (IBAction)pauseCalculations:(id)sender
{
	if (performCalculations == YES) {
		performCalculations = NO;
	} else if (performCalculations == NO) {
		performCalculations = YES;
	}
}

@end
