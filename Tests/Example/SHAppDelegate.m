//
//  SHAppDelegate.m
//  Example
//
//  Created by Seivan Heidari on 7/15/13.
//  Copyright (c) 2013 Seivan Heidari. All rights reserved.
//

#import "SHAppDelegate.h"

@interface SHSample : NSObject
@property(nonatomic,strong) NSNumber * thatProperty;
-(instancetype)initWithSample:(NSNumber *)thatProperty;
@end

@implementation SHSample
-(instancetype)initWithSample:(NSNumber *)thatProperty; {
  self = [super init];
  if(self) {
    self.thatProperty = thatProperty;
  }
  return self;
}

@end


@implementation SHAppDelegate

-(void)applicationDidFinishLaunching:(NSNotification *)aNotification;{
  NSSet * sample  =  [NSSet setWithArray:@[@(1),@(666),@(43),@(22),@(22)]];
  NSSet * sample2  =  [NSSet setWithArray:@[@(1),@(666),@(43),@(22),@(33)]];
  
//  NSLog(@"%@", [sample valueForKeyPath:@"self"]);
  
  sample  = [NSSet setWithArray:@[
              [[SHSample alloc] initWithSample:@(23)],
              [[SHSample alloc] initWithSample:@(23)],
              [[SHSample alloc] initWithSample:@(999)],
              [[SHSample alloc] initWithSample:@(1000000)],
              [[SHSample alloc] initWithSample:@(666)],
              ]];
  
  sample2  = [NSSet setWithArray:@[
              [[SHSample alloc] initWithSample:nil],
              [[SHSample alloc] initWithSample:@(23)],
              [[SHSample alloc] initWithSample:@(33)],
              [[SHSample alloc] initWithSample:@(666)],
              [[SHSample alloc] initWithSample:@(99900000)],
              ]];
  NSLog(@"1%@", [@[sample,sample2] valueForKeyPath:@"@distinctUnionOfObjects.thatProperty"]);

//  NSLog(@"2%@", [@[sample,sample2] valueForKeyPath:@"@distinctUnionOfArrays.thatProperty"]);

//  NSLog(@"%@", [sample valueForKeyPath:@"thatProperty"]);
  
}

@end
