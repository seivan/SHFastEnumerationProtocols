//
//  NSSetTests.m
//  Example
//
//  Created by Seivan Heidari on 7/25/13.
//  Copyright (c) 2013 Seivan Heidari. All rights reserved.
//

#import "SHFastEnumerationTests.h"

#import "NSSet+SHFastEnumerationProtocols.h"


@interface NSSetTests : XCTestCase
<SHTestsFastEnumerationBlocks,
SHTestsFastEnumerationProperties>
@property(nonatomic,strong) NSSet           * subject;
@property(nonatomic,strong) NSMutableSet    * matching;

@end


@interface NSSetTests (Private)
<SHTestsHelpers>
@end

@interface NSSetTests (Mutable)
<SHTestsMutableFastEnumerationBlocks>
@end

@implementation NSSetTests


-(void)setUp; {
  [super setUp];
  
  
  self.subject =  [NSSet setWithArray:@[@"one", @"1", @"two",@"2", @"three", @"3", @"one", @"1"]];
  
  self.matching = [NSMutableSet set];
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
  
  XCTAssertEqualObjects(self.subject, self.matching);
  
}

-(void)testConcurrentEach; {
  __block BOOL didAssert = NO;
  NSMutableArray * content = @[].mutableCopy;
  [self SH_performAsyncTestsWithinBlock:^(BOOL *didFinish) {
    [self.subject SH_concurrentEach:^(id obj) {
      [content addObject:obj];
    } onComplete:^(id obj) {
      XCTAssertEqualObjects(obj, self.subject);
      didAssert = YES;
      *didFinish = YES;
    }];
  } withTimeout:5];
  
  XCTAssertTrue(didAssert);
  XCTAssertEqual(content.count, self.subject.count);
}


-(void)testMap;{
  __block NSInteger skipOne = 0;
  self.matching = [self.subject SH_map:^id(id obj) {
    skipOne += 1;
    if(skipOne == 1)
      return nil;
    else
      return obj;
  }].mutableCopy;
  
  self.subject = [self.subject SH_map:^id(id obj) {
    return obj;
  }];
  
  
  XCTAssertTrue(self.matching.count < self.subject.count);
  XCTAssertTrue(self.matching.SH_hasObjects);
  
  for (id obj in self.matching)
    XCTAssertTrue([self.subject containsObject:obj]);
  
}

-(void)testReduce;{
  NSMutableString * expected = @"".mutableCopy;
  for (id obj in self.subject) [expected appendFormat:@"%@", obj];
  
  NSMutableString  * matched = [self.subject SH_reduceValue:@"".mutableCopy withBlock:^id(NSMutableString * memo, id obj) {
    [memo appendFormat:@"%@", obj];
    return memo;
  }];
  
  XCTAssertEqualObjects(expected, matched);
}

-(void)testFind;{
  __block NSInteger counter = 0;
  
  id value = [self.subject SH_find:^BOOL(id obj) {
    counter +=1;
    return (counter == self.subject.count);
  }];
  
  
  XCTAssertEqual(self.subject.count, (NSUInteger)counter);
  XCTAssertTrue([self.subject containsObject:value]);
  
}

-(void)testFindAll;{
  __block NSInteger counter = 0;
  
  self.matching = [self.subject SH_findAll:^BOOL(id obj) {
    counter +=1;
    return (counter < self.subject.count-1);
  }].mutableCopy;
  
  for (id obj in self.matching) {
    XCTAssertTrue([self.subject containsObject:obj]);
  }
  XCTAssertTrue(self.matching.count > 0);
  XCTAssertTrue(self.matching.count < self.subject.count-1);
  
}

-(void)testReject;{
  __block NSInteger counter = 0;
  
  self.matching = [self.subject SH_reject:^BOOL(id obj) {
    counter +=1;
    return (counter < self.subject.count-1);
  }].mutableCopy;
  
  for (id obj in self.matching) {
    XCTAssertTrue([self.subject containsObject:obj]);
  }
  XCTAssertTrue(self.matching.count > 0);
  XCTAssertTrue(self.matching.count < self.subject.count-1);
}

-(void)testAll;{
  
  self.matching = self.subject.mutableCopy;
  BOOL testAllTrue = [self.subject SH_all:^BOOL(id obj) {
    return [self.matching containsObject:obj];
  }];
  
  NSMutableSet * subject = self.subject.mutableCopy;
  [subject addObject:@"---"];
  self.subject = subject.copy;
  
  BOOL testAllNotAllTrue = [self.subject SH_all:^BOOL(id obj) {
    return [self.matching containsObject:obj];
  }];
  
  XCTAssertTrue(testAllTrue);
  XCTAssertFalse(testAllNotAllTrue);
  
  
}

-(void)testAny;{
  self.matching = self.subject.mutableCopy;
  
  BOOL testAllTrue = [self.subject SH_any:^BOOL(id obj) {
    return [self.matching containsObject:obj];
  }];
  
  
  NSMutableArray * matching = self.matching.SH_toArray.mutableCopy;
  [matching removeLastObject];
  [matching removeLastObject];
  BOOL testAllNotAllTrue = [self.subject SH_any:^BOOL(id obj) {
    return [matching containsObject:obj];
  }];
  
  XCTAssertTrue(testAllTrue);
  XCTAssertTrue(testAllNotAllTrue);
  
  
  
  
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
  XCTAssertTrue([matching containsObject:@(1)]);
  XCTAssertTrue([matching containsObject:@(2)]);
  
  
}

#pragma mark - <SHTestsFastEnumerationProperties>
-(void)testHasObjects; {
  XCTAssertTrue(self.subject.SH_hasObjects);
  XCTAssertFalse(self.matching.SH_hasObjects);
  BOOL isEmpty = self.matching.count == 0;
  XCTAssertNotEqual(isEmpty, self.matching.SH_hasObjects);
}

-(void)testToArray; {
  NSArray     * matching = self.subject.SH_toArray;
  NSArray     * subject  = self.subject.allObjects;
  
  XCTAssertTrue([matching isKindOfClass:[NSArray class]]);
  XCTAssertEqualObjects(subject, matching);
}

-(void)testToSet; {
  XCTAssertTrue([self.subject.SH_toSet isKindOfClass:[NSSet class]]);
  XCTAssertTrue(self.subject.SH_toSet.count > 0);
  
  for (id obj in self.subject.SH_toSet)
    XCTAssertTrue([self.subject containsObject:obj]);
  
}

-(void)testToOrderedSet; {
  XCTAssertTrue([self.subject.SH_toOrderedSet  isKindOfClass:[NSOrderedSet class]]);
  XCTAssertTrue(self.subject.SH_toOrderedSet.count > 0);
  
  [self.subject.SH_toOrderedSet enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL __unused *stop) {
    XCTAssertTrue([self.subject containsObject:obj]);
  }];
  
  
}

-(void)testToDictionary; {
  XCTAssertTrue([self.subject.SH_toDictionary isKindOfClass:[NSDictionary class]]);
  XCTAssertTrue(self.subject.SH_toDictionary.count > 0);
  
  [self.subject.SH_toDictionary enumerateKeysAndObjectsUsingBlock:^(NSNumber * key, id obj, BOOL *stop) {
    [self.subject containsObject:obj];
    XCTAssertTrue([self.subject containsObject:obj]);
    XCTAssertNotNil(self.subject.objectEnumerator.allObjects[key.integerValue]);
  }];
  
}

-(void)testToMapTableWeakToWeak; {
  [self assertMapTableWithMapTable:self.subject.SH_toMapTableWeakToWeak];
  
}

-(void)testToMapTableWeakToStrong; {
  [self assertMapTableWithMapTable:self.subject.SH_toMapTableWeakToStrong];
}

-(void)testToMapTableStrongToStrong; {
  [self assertMapTableWithMapTable:self.subject.SH_toMapTableStrongToStrong];
}

-(void)testToMapTableStrongToWeak; {
  [self assertMapTableWithMapTable:self.subject.SH_toMapTableStrongToWeak];
}

-(void)testToHashTableWeak; {
  [self assertHashTableWithMapTable:self.subject.SH_toHashTableWeak];
}

-(void)testToHashTableStrong; {
  [self assertHashTableWithMapTable:self.subject.SH_toHashTableStrong];
}

-(void)testAvg; {
  self.matching = [NSMutableSet setWithArray:@[@(0),@(1),@(2),@(3),@(4),@(5)]];
  self.subject  = [NSSet setWithArray:@[@"0",@"1",@"2",@"3",@"4",@"5"]];
  XCTAssertEqualObjects([self.subject valueForKeyPath:@"@avg.self"],
                       self.matching.SH_collectionAvg);
}

-(void)testSum; {
  self.matching = [NSMutableSet setWithArray:@[@(0),@(1),@(2),@(3),@(4),@(5)]];
  self.subject  = [NSSet setWithArray:@[@"0",@"1",@"2",@"3",@"4",@"5"]];
  XCTAssertEqualObjects([self.subject valueForKeyPath:@"@sum.self"],
                       self.matching.SH_collectionSum);
  
}

-(void)testMax; {
  self.matching = [NSMutableSet setWithArray:@[@(0),@(1),@(2),@(3),@(4),@(5)]];
  self.subject  = [NSSet setWithArray:@[@"0",@"1",@"2",@"3",@"4",@"5"]];
  
  XCTAssertEqualObjects([self.subject valueForKeyPath:@"@max.self"], self.subject.SH_collectionMax);
  XCTAssertEqualObjects([self.matching valueForKeyPath:@"@max.self"], self.matching.SH_collectionMax);
  
}

-(void)testMin; {
  self.matching = [NSMutableSet setWithArray:@[@(0),@(1),@(2),@(3),@(4),@(5)]];
  self.subject  = [NSSet setWithArray:@[@"0",@"1",@"2",@"3",@"4",@"5"]];
  
  XCTAssertEqualObjects([self.subject valueForKeyPath:@"@min.self"], self.subject.SH_collectionMin);
  XCTAssertEqualObjects([self.matching valueForKeyPath:@"@min.self"], self.matching.SH_collectionMin);
}


@end

@implementation NSSetTests (Mutable)

#pragma mark - <SHTestsMutableFastEnumerationBlocks>
-(void)testModifyMap; {
  __block NSInteger counter = 0;
  self.matching = self.subject.mutableCopy;
  [self.matching SH_modifyMap:^id(id obj) {
    counter +=1;
    if(counter == 1)
      return obj;
    else
      return nil;
  }];
  
  
  NSInteger expectedCount = 1;
  XCTAssertTrue(self.matching.count < self.subject.count);
  XCTAssertEqual(self.matching.count, (NSUInteger)expectedCount);
  
  for (id obj in self.matching) {
    XCTAssertTrue([self.subject containsObject:obj]);
  }
  
  
  
}

-(void)testModifyFindAll; {
  __block NSInteger counter = 0;
  self.matching = self.subject.mutableCopy;
  [self.matching SH_modifyFindAll:^BOOL(id obj) {
    counter +=1;
    if(counter == 1)
      return YES;
    else
      return NO;
  }];
  
  
  NSInteger expectedCount = 1;
  XCTAssertTrue(self.matching.count < self.subject.count);
  XCTAssertEqual(self.matching.count, (NSUInteger)expectedCount);
  
  for (id obj in self.matching) {
    XCTAssertTrue([self.subject containsObject:obj]);
  }
  
  
  
}

-(void)testModifyReject; {
  
  __block NSInteger counter = 0;
  self.matching = self.subject.mutableCopy;
  [self.matching SH_modifyReject:^BOOL(id obj) {
    counter +=1;
    if(counter == 1)
      return YES;
    else
      return NO;
  }];
  
  
  NSInteger expectedCount = 1;
  XCTAssertTrue(self.matching.count < self.subject.count);
  XCTAssertEqual(self.matching.count, self.subject.count-expectedCount);
  
  for (id obj in self.matching) {
    XCTAssertTrue([self.subject containsObject:obj]);
  }
}


@end


@implementation NSSetTests (Private)
-(void)assertMapTableWithMapTable:(NSMapTable *)theMapTable; {
  
  XCTAssertTrue([theMapTable isKindOfClass:[NSMapTable class]]);
  XCTAssertTrue(theMapTable.count > 0);
  XCTAssertTrue(self.subject.count > 0);
  [self.subject SH_each:^(id obj) {
    [theMapTable.objectEnumerator.allObjects containsObject:obj];
  }];
  
}


-(void)assertHashTableWithMapTable:(NSHashTable *)theHashTable; {
  XCTAssertTrue([theHashTable isKindOfClass:[NSHashTable class]]);
  XCTAssertTrue(theHashTable.count > 0);
  XCTAssertTrue(self.subject.count > 0);
  [self.subject SH_each:^(id obj) {
    XCTAssertTrue([theHashTable containsObject:obj]);
  }];
  
}


@end