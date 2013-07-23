//
//  NSArrayTests.m
//  Example
//
//  Created by Seivan Heidari on 7/22/13.
//  Copyright (c) 2013 Seivan Heidari. All rights reserved.
//


#import "NSArrayTests.h"

#import "NSArray+SHFastEnumerationProtocols.h"

@interface NSArrayTests ()
@property(nonatomic,strong) NSArray             * subject;
@property(nonatomic,strong) NSMutableArray      * matching;

@end

@implementation NSArrayTests

-(void)setUp; {
  [super setUp];
  self.subject = @[ @"one", @"1", @"two",@"2", @"three", @"3", @"one", @"1"];
  self.matching = @[].mutableCopy;
}

-(void)tearDown; {
  [super tearDown];
  
  self.subject = nil;
  self.matching = nil;
}

-(void)testEach;{
  [self.subject SH_each:^(id obj) {
    [self.matching addObject:obj];
  }];
  
  STAssertEqualObjects(self.subject, self.matching, nil);
  
}

-(void)testEachWithIndex;{

  [self.subject SH_eachWithIndex:^(id obj, NSUInteger index) {
    [self.matching addObject:@(index)];
  }];

  for (NSNumber * obj in self.matching) {
    STAssertNotNil(self.subject[obj.unsignedIntegerValue], nil);
  }

  
}

-(void)testMap;{
  self.matching = self.subject.mutableCopy;
  [self.matching removeLastObject];
  
  self.subject = [self.subject SH_map:^id(id obj) {
      return obj;
  }];
  NSMutableArray * modifySubject =  self.subject.mutableCopy;
  [modifySubject removeLastObject];
  self.subject = modifySubject;
  STAssertEqualObjects(self.subject, self.matching, nil);
}

-(void)testReduce;{
  self.matching = [self.subject SH_reduceValue:@[].mutableCopy withBlock:^id(id memo, id obj) {
    [(NSMutableArray*)memo addObject:obj];
    return memo;
  }].mutableCopy;

  STAssertEqualObjects(self.subject, self.matching, nil);
}

-(void)testFind;{
  NSUInteger index = self.subject.count/2;
//  self.matching = self.subject[index];
  
  id value = [self.subject SH_find:^BOOL(id obj) {
    return [self.subject indexOfObject:obj] == index;
  }];
  [self.matching addObject:value];

  STAssertEqualObjects(self.subject[self.subject.count/2], self.matching[0], nil);
  
}

-(void)testFindAll;{
  self.matching = [self.subject SH_findAll:^BOOL(id obj) {
    return [self.subject indexOfObject:obj] % 2 == 0 ;
  }].mutableCopy;

  for (id obj in self.matching) {
    NSInteger index = [self.subject indexOfObject:obj];
    STAssertTrue([self.subject containsObject:obj], nil);
    STAssertTrue(index % 2 == 0, nil);
  }
  STAssertTrue(self.matching.count > 0, nil);

}

-(void)testReject;{
  self.matching = [self.subject SH_reject:^BOOL(id obj) {
    return [self.subject indexOfObject:obj] % 2 == 0 ;
  }].mutableCopy;

  for (id obj in self.matching) {
    NSInteger index = [self.subject indexOfObject:obj];
    STAssertTrue(index % 2 != 0, nil);
  }
  STAssertTrue(self.matching.count < self.subject.count, nil);
  STAssertTrue(self.matching.count > 0, nil);
}

-(void)testAll;{
  self.matching = self.subject.mutableCopy;
  BOOL testAllTrue = [self.subject SH_all:^BOOL(id obj) {
    return [self.matching containsObject:obj];
  }];
  
  [self.matching removeLastObject];
  [self.matching removeLastObject];
  [self.matching removeLastObject];
  BOOL testAllNotAllTrue = [self.subject SH_all:^BOOL(id obj) {
    return [self.matching containsObject:obj];
  }];
  
  self.matching = @[].mutableCopy;
  if(testAllTrue) [self.matching addObject:@(1)];
  if(testAllNotAllTrue == NO) [self.matching addObject:@(2)];

  NSArray * matching = (NSArray * )self.matching;
  STAssertTrue([matching containsObject:@(1)], nil);
  STAssertTrue([matching containsObject:@(2)], nil);



}

-(void)testAny;{
  self.matching = self.subject.mutableCopy;
  BOOL testAllTrue = [self.subject SH_any:^BOOL(id obj) {
    return [self.matching containsObject:obj];
  }];
  
  [self.matching removeLastObject];
  [self.matching removeLastObject];
  [self.matching removeLastObject];

  
  BOOL testAllNotAllTrue = [self.subject SH_any:^BOOL(id obj) {
    return [self.matching containsObject:obj];
  }];

  BOOL testAllAllFalse = [self.subject SH_any:^BOOL(id obj) {
    return NO;
  }];

  self.matching = @[].mutableCopy;
  
  if(testAllTrue) [self.matching addObject:@(1)];
  if(testAllNotAllTrue) [self.matching addObject:@(2)];
  if(testAllAllFalse == NO) [self.matching addObject:@(3)];
  
  NSArray * matching = (NSArray * )self.matching;
  
  STAssertTrue([matching containsObject:@(1)], nil);
  
  STAssertTrue([matching containsObject:@(2)], nil);
  
  STAssertTrue([matching containsObject:@(3)], nil);




}

-(void)testNone; {
  self.matching = self.subject.mutableCopy;
  
  BOOL testAllTrue = [self.subject SH_none:^BOOL(id obj) {
    return NO;
  }];

  BOOL testAllFalse = [self.subject SH_none:^BOOL(id obj) {
    return YES;
  }];

  self.matching = @[].mutableCopy;
  
  if(testAllTrue) [self.matching addObject:@(1)];
  if(testAllFalse == NO) [self.matching addObject:@(2)];

  NSArray * matching = (NSArray * )self.matching;
  STAssertTrue([matching containsObject:@(1)], nil);
  STAssertTrue([matching containsObject:@(2)], nil);

  
}

-(void)testSelfMap; {
  __block NSUInteger counter = 0;
  self.matching = self.subject.mutableCopy;
  [self.matching SH_selfMap:^id(id obj) {
    counter +=1;
    if(counter == 1)
      return obj;
    else
      return nil;
  }];
  
  
  STAssertTrue(self.matching.count < self.subject.count, nil);
  STAssertTrue(self.matching.count == 1, nil);
  STAssertEqualObjects(self.matching[0], self.subject[0], nil);
  

}

-(void)testSelfFindAll; {
  self.matching = self.subject.mutableCopy;
  
  [self.matching SH_selfFindAll:^BOOL(id obj) {
    return [self.matching indexOfObject:obj] % 2 == 0 ;
  }];
  
  for (id obj in self.matching) {
    NSInteger index = [self.subject indexOfObject:obj];
    STAssertTrue(index % 2 == 0, nil);
  }
  STAssertTrue(self.matching.count < self.subject.count, nil);
  STAssertTrue(self.matching.count > 0, nil);
  
}

-(void)testSelfReject; {

  self.matching = self.subject.mutableCopy;
  
  [self.matching SH_selfReject:^BOOL(id obj) {
    return [self.matching indexOfObject:obj] % 2 == 0 ;
  }];
  

  for (id obj in self.matching) {
    NSInteger index = [self.subject indexOfObject:obj];
    STAssertTrue(index % 2 != 0, nil);
  }
  STAssertTrue(self.matching.count < self.subject.count, nil);
  STAssertTrue(self.matching.count > 0, nil);
}


@end
