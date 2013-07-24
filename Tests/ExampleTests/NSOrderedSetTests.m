//
//  NSOrderedSetTests.m
//  Example
//
//  Created by Seivan Heidari on 7/23/13.
//  Copyright (c) 2013 Seivan Heidari. All rights reserved.
//

#import "SHFastEnumerationTests.h"

#import "NSOrderedSetTests.h"

#import "NSOrderedSet+SHFastEnumerationProtocols.h"

@interface NSOrderedSetTests ()
//<SHTestsFastEnumerationBlocks,
//SHTestsFastEnumerationOrderedBlocks,
//SHTestsFastEnumerationOrderedProperties,
//SHTestsFastEnumerationOrdered>

@property(nonatomic,strong) NSOrderedSet             * subject;
@property(nonatomic,strong) NSMutableOrderedSet      * matching;

@end

@interface NSOrderedSetTests (Mutable)
//<SHTestsMutableFastEnumerationBlocks,
//SHTestsMutableFastEnumerationOrdered>
@end

@implementation NSOrderedSetTests


-(void)setUp; {
  [super setUp];
  self.subject =  [NSOrderedSet orderedSetWithArray:
                   @[@"one", @"1", @"two",@"2", @"three", @"3", @"one", @"1"]
                   ];
  self.matching = [NSMutableOrderedSet orderedSet];
}

-(void)tearDown; {
  [super tearDown];
  
  self.subject = nil;
  self.matching = nil;
}


@end
