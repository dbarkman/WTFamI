//
//  WTFamIViewController.m
//  WTFamI
//
//  Created by David Barkman on 10/12/12.
//  Copyright (c) 2012 David Barkman. All rights reserved.
//

#import "WTFamIViewController.h"

@implementation WTFamIViewController

@synthesize speedCount, sumSpeed, maxSpeed, averageSpeed, calculatedDistance, performCalculations;

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
		[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / kAccelerometerFrequency)];
		[[UIAccelerometer sharedAccelerometer] setDelegate:self];
	}
	
	performCalculations = YES;
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[progress setProgressTintColor:[UIColor greenColor]];
}

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
	CLLocationSpeed clSpeed = newLocation.speed * 2.2369;
	
	latitude = [NSString stringWithFormat:@"%.4f", newLocation.coordinate.latitude];
	longitude = [NSString stringWithFormat:@"%.4f", newLocation.coordinate.longitude];
	altitude = [NSString stringWithFormat:@"%.2f", newLocation.altitude / 3.28084];
	course = [NSString stringWithFormat:@"%.4f", newLocation.course];
	lastTimestamp = timestamp;
	timestamp = [NSString stringWithFormat:@"%@", newLocation.timestamp.description];
	lastSpeed = speed;
	speed = [NSString stringWithFormat:@"%.1f", clSpeed];
	int lastSpeedInt = [lastSpeed integerValue];
	int speedInt = [speed integerValue];
	if (lastSpeedInt > speedInt) { //slowing down
		float change = lastSpeedInt - speedInt;
		if (change > 10) change = 10;
		if (change >= 0.0f && change <= 4.0f) {
			[progress setProgressTintColor:[UIColor greenColor]];
		} else if (change > 4.0f && change <= 6.0f) {
			[progress setProgressTintColor:[UIColor yellowColor]];
		} else if (change > 6.0f && change <= 8.0f) {
			[progress setProgressTintColor:[UIColor orangeColor]];
		} else if (change > 8.0f && change <= 10.0f) {
			[progress setProgressTintColor:[UIColor redColor]];
		}
		[progress setProgress:(change / 10) animated:YES];
	} else {
		[progress setProgress:0 animated:YES];
	}
	
	if (performCalculations == YES) {
		if (oldLocation != nil) {
			CLLocationDistance distance = [newLocation distanceFromLocation:oldLocation];
			calculatedDistance += distance;
		}
		
		//should set this in a preference
		if (clSpeed > 0) {
			//find max speed
			if (clSpeed > maxSpeed) maxSpeed = clSpeed;
			
			//find average speed
			speedCount++;
			sumSpeed += clSpeed;
			averageSpeed = sumSpeed / speedCount;
		}
	}
	displayedDistance = [NSString stringWithFormat:@"Distance: %.2f", calculatedDistance * 0.00062137119];
	displayedMaxSpeed = [NSString stringWithFormat:@"Max Speed: %.1f", maxSpeed];
	displayedAverageSpped = [NSString stringWithFormat:@"Average Speed: %.1f", averageSpeed];
	
//	NSLog(@"%@", newLocation);
	
	[latitudeField setText:latitude];
	[longitudeField setText:longitude];
	[altitudeField setText:altitude];
	[courseField setText:course];
	[speedField setText:speed];
	[timestampField setText:timestamp];
	[distanceField setText:displayedDistance];
	[maxSpeedField setText:displayedMaxSpeed];
	[averageSpeedField setText:displayedAverageSpped];
}

- (void)locationManager:(CLLocationManager *)manager
	   didUpdateHeading:(CLHeading *)newHeading
{
	trueHeading = [NSString stringWithFormat:@"T: %.3f", newHeading.trueHeading];
	magneticHeading = [NSString stringWithFormat:@"M: %.3f", newHeading.magneticHeading];
	
	//	NSLog(@"%@", trueHeading);
	
	[trueHeadingField setText:trueHeading];
	[magneticHeadingField setText:magneticHeading];
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
//	NSLog(@"Acceleration Sensed!!");
	
    x = acceleration.x + calX;
    y = acceleration.y + calY;
    z = acceleration.z + calZ;
	
	double accelMagnitude = sqrt(
		x * x +
		y * y +
		z * z);
	
	displayedAM = [NSString stringWithFormat:@"%f", accelMagnitude];
//	NSLog(@"%@", displayedAM);
	
	displayedX = [NSString stringWithFormat:@"%.1f", x];
	displayedY = [NSString stringWithFormat:@"%.1f", y];
	displayedZ = [NSString stringWithFormat:@"%.1f", z];
	
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

- (IBAction)resetMaxSpeed:(id)sender
{
	maxSpeed = 0;
	[maxSpeedField setText:@"Max Speed: 0.0"];
}

- (IBAction)resetAverageSpeed:(id)sender
{
	speedCount = 0;
	sumSpeed = 0;
	[averageSpeedField setText:@"Average Speed: 0.0"];
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
