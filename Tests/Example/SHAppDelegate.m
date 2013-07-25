//
//  SHAppDelegate.m
//  Example
//
//  Created by Seivan Heidari on 7/15/13.
//  Copyright (c) 2013 Seivan Heidari. All rights reserved.
//

#import "SHAppDelegate.h"
#import "SHFastEnumerationProtocols.h"


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
  NSCountedSet
}

@end
