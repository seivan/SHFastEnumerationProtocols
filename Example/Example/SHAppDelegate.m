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
  //NSArray * matching = @[@(0),@(1),@(2),@(3),@(4),@(5)];
  NSHashTable * matching =  [NSHashTable hashTableWithOptions:NSPointerFunctionsStrongMemory];
  

  for (id obj in @[@"asd",@(1),@(2),@(3),@(4),@(5)])
    [matching addObject:obj];

//  NSLog(@"%@", [@[@"asd",@(1),@(2),@(3),@(4),@(5)] valueForKeyPath:@"@avg.self"]);
  @try {
    NSLog(@"%@", [@[@"asd",@(1),@(2),@(3),@(4),@(5)] valueForKeyPath:@"@sum.self"]);
  }
  @catch (NSException *exception) {
    NSLog(@"EXCEPTION: %@", exception);
  }
  @finally {
    NSLog(@"FINALLLY");
  }
  
//  NSLog(@"%@ ---- %@", [matching valueForKeyPath:@"@avg.self"], matching.SH_collectionAvg);
  

}

@end
