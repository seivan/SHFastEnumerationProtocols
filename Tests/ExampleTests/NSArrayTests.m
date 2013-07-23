//
//  NSArrayTests.m
//  Example
//
//  Created by Seivan Heidari on 7/22/13.
//  Copyright (c) 2013 Seivan Heidari. All rights reserved.
//


#import "SHFastEnumerationTests.h"

#import "NSArrayTests.h"

#import "NSArray+SHFastEnumerationProtocols.h"

@interface NSArrayTests ()
<SHTestsFastEnumerationBlocks,
SHTestsFastEnumerationOrderedBlocks,
SHTestsFastEnumerationOrderedProperties,
SHTestsFastEnumerationOrdered>

@property(nonatomic,strong) NSArray             * subject;
@property(nonatomic,strong) NSMutableArray      * matching;

@end

@interface NSArrayTests (Mutable)
<SHTestsMutableFastEnumerationBlocks,
SHTestsMutableFastEnumerationOrdered>
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

#pragma mark - <SHTestsFastEnumerationBlocks>
-(void)testEach;{
  [self.subject SH_each:^(id obj) {
    [self.matching addObject:obj];
  }];
  
  STAssertEqualObjects(self.subject, self.matching, nil);
  
}

-(void)testMap;{
  __block NSInteger skipOne = -1;
  self.matching = [self.subject SH_map:^id(id obj) {
    skipOne += 1;
    if(skipOne == 0)
      return nil;
    else
      return obj;
  }].mutableCopy;
  
  NSMutableArray * modifySubject =  self.subject.mutableCopy;
  [modifySubject removeObjectAtIndex:0];
  self.subject = modifySubject;

  STAssertEqualObjects(self.subject, self.matching, nil);
  
}

-(void)testReduce;{
  self.matching = [self.subject SH_reduceValue:@[].mutableCopy
                                     withBlock:^id(NSMutableArray * memo, id obj) {
    [memo addObject:obj];
    return memo;
  }].mutableCopy;

  STAssertEqualObjects(self.subject, self.matching, nil);
}

-(void)testFind;{
  NSUInteger index = self.subject.count/2;
  
  id value = [self.subject SH_find:^BOOL(id obj) {
    return [self.subject indexOfObject:obj] == index;
  }];
  [self.matching addObject:value];

  STAssertEqualObjects(self.subject[index], self.matching[0], nil);
  
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

#pragma mark - <SHTestsFastEnumerationOrderedBlocks>
-(void)testEachWithIndex;{
  
  [self.subject SH_eachWithIndex:^(id obj, NSUInteger index) {
    [self.matching addObject:@(index)];
  }];
  
  STAssertTrue(self.matching.count > 0, nil);
  for (NSNumber * obj in self.matching)
    STAssertNotNil(self.subject[obj.unsignedIntegerValue], nil);
  
  
  
  
}


#pragma mark - <SHTestsFastEnumerationOrderedProperties>
-(void)testFirstObject; {
  self.matching = self.subject.mutableCopy;
  
  STAssertEqualObjects(self.matching.SH_firstObject,
                       self.subject[0], nil);
  
  self.matching = @[].mutableCopy;
  
  STAssertNoThrow([self.matching SH_firstObject], nil);
  STAssertNil(self.matching.SH_firstObject, nil);
  
}

-(void)testLastObject; {
  self.matching = self.subject.mutableCopy;
  
  STAssertEqualObjects(self.matching.SH_lastObject,
                       self.subject.lastObject, nil);
  
  self.matching = @[].mutableCopy;
  
  STAssertNoThrow([self.matching SH_lastObject], nil);
  STAssertNil(self.matching.SH_lastObject, nil);
  
  
}

#pragma mark - <SHTestsFastEnumerationOrdered>
-(void)testReverse; {

  self.matching = [self.subject SH_reverse].mutableCopy;
  STAssertEqualObjects(self.subject.reverseObjectEnumerator.allObjects, self.matching, nil);
  STAssertTrue(self.matching.count > 0, nil);

  
}

#pragma mark - <SHTestsMutableFastEnumerationBlocks>
-(void)testModifyMap; {
  __block NSUInteger counter = 0;
  self.matching = self.subject.mutableCopy;
  [self.matching SH_modifyMap:^id(id obj) {
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

-(void)testModifyFindAll; {
  self.matching = self.subject.mutableCopy;
  
  [self.matching SH_modifyFindAll:^BOOL(id obj) {
    return [self.matching indexOfObject:obj] % 2 == 0 ;
  }];
  
  for (id obj in self.matching) {
    NSInteger index = [self.subject indexOfObject:obj];
    STAssertTrue(index % 2 == 0, nil);
  }
  STAssertTrue(self.matching.count < self.subject.count, nil);
  STAssertTrue(self.matching.count > 0, nil);
  
}

-(void)testModifyReject; {

  self.matching = self.subject.mutableCopy;
  
  [self.matching SH_modifyReject:^BOOL(id obj) {
    return [self.matching indexOfObject:obj] % 2 == 0 ;
  }];
  

  for (id obj in self.matching) {
    NSInteger index = [self.subject indexOfObject:obj];
    STAssertTrue(index % 2 != 0, nil);
  }
  STAssertTrue(self.matching.count < self.subject.count, nil);
  STAssertTrue(self.matching.count > 0, nil);
}

#pragma mark - <SHTestsMutableFastEnumerationOrdered>

-(void)testModifyReverse; {
  self.matching = self.subject.mutableCopy;
  [self.matching SH_modifyReverse];
  STAssertEqualObjects(self.subject.reverseObjectEnumerator.allObjects, self.matching, nil);
  STAssertTrue(self.matching.count > 0, nil);
}

-(void)testPopObjectAtIndex; {
  self.matching = self.subject.mutableCopy;
  id obj = [self.matching SH_popObjectAtIndex:self.matching.count/2];
  
  STAssertEqualObjects(obj,
                       self.subject[self.subject.count/2], nil);

  STAssertTrue(self.matching.count == self.subject.count-1 , nil);
  
  
  STAssertThrowsSpecific([self.matching SH_popObjectAtIndex:NSNotFound],
                         NSException,
                         nil);
}

-(void)testPopFirstObject; {
  self.matching = self.subject.mutableCopy;
  id obj = [self.matching SH_popFirstObject];

  STAssertNotNil(obj, nil);
  STAssertEqualObjects(obj,
                       self.subject.SH_firstObject, nil);
  
  STAssertTrue(self.matching.count == self.subject.count-1 , nil);
  
  self.matching = @[].mutableCopy;
  
  STAssertNoThrow([self.matching SH_popFirstObject], nil);
  STAssertNil([self.matching SH_popFirstObject], nil);

}

-(void)testPopLastObject; {
  self.matching = self.subject.mutableCopy;
  id obj = [self.matching SH_popLastObject];
  
  STAssertEqualObjects(obj,
                       self.subject.SH_lastObject, nil);
  
  STAssertTrue(self.matching.count == self.subject.count-1 , nil);
  
  self.matching = @[].mutableCopy;
  
  STAssertNoThrow([self.matching SH_lastObject], nil);
  STAssertNil([self.matching SH_lastObject], nil);

  
}



@end
