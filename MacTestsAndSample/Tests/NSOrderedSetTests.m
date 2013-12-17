//
//  NSOrderedSetTests.m
//  Example
//
//  Created by Seivan Heidari on 7/23/13.
//  Copyright (c) 2013 Seivan Heidari. All rights reserved.
//

#import "SHFastEnumerationTests.h"

#import "NSOrderedSet+SHFastEnumerationProtocols.h"



@interface NSOrderedSetTests : XCTestCase
<SHTestsFastEnumerationBlocks,
SHTestsFastEnumerationProperties,
SHTestsFastEnumerationOrderedBlocks,
SHTestsFastEnumerationOrderedProperties,
SHTestsFastEnumerationOrdered>

@property(nonatomic,strong) NSOrderedSet             * subject;
@property(nonatomic,strong) NSMutableOrderedSet      * matching;

@end

@interface NSOrderedSetTests (Mutable)
<SHTestsMutableFastEnumerationBlocks,
SHTestsMutableFastEnumerationOrdered>
@end

@interface NSOrderedSetTests (Private)
<SHTestsHelpers>
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
  __block NSInteger skipOne = -1;
  self.matching = [self.subject SH_map:^id(id obj) {
    skipOne += 1;
    if(skipOne == 0)
      return nil;
    else
      return obj;
  }].mutableCopy;
  
  NSMutableOrderedSet * modifySubject =  self.subject.mutableCopy;
  [modifySubject removeObjectAtIndex:0];
  self.subject = modifySubject;
  
  XCTAssertEqualObjects(self.subject, self.matching);
  
}

-(void)testReduce;{
  self.matching = [self.subject SH_reduceValue:[NSMutableOrderedSet orderedSet]
                                     withBlock:^id(NSMutableArray * memo, id obj) {
                                       [memo addObject:obj];
                                       return memo;
                                     }];
  
  XCTAssertEqualObjects(self.subject, self.matching);
}

-(void)testFind;{
  NSInteger index = self.subject.count/2;
  
  id value = [self.subject SH_find:^BOOL(id obj) {
    return [self.subject indexOfObject:obj] == index;
  }];
  [self.matching addObject:value];
  
  XCTAssertEqualObjects(self.subject[index], self.matching[0]);
  
}

-(void)testFindAll;{
  self.matching = [self.subject SH_findAll:^BOOL(id obj) {
    return [self.subject indexOfObject:obj] % 2 == 0 ;
  }].mutableCopy;
  
  for (id obj in self.matching) {
    NSInteger index = [self.subject indexOfObject:obj];
    XCTAssertTrue([self.subject containsObject:obj]);
    XCTAssertTrue(index % 2 == 0);
  }
  XCTAssertTrue(self.matching.count > 0);
  
}

-(void)testReject;{
  self.matching = [self.subject SH_reject:^BOOL(id obj) {
    return [self.subject indexOfObject:obj] % 2 == 0 ;
  }].mutableCopy;
  
  for (id obj in self.matching) {
    NSInteger index = [self.subject indexOfObject:obj];
    XCTAssertTrue(index % 2 != 0);
  }
  XCTAssertTrue(self.matching.count < self.subject.count);
  XCTAssertTrue(self.matching.count > 0);
}

-(void)testAll;{
  self.matching = self.subject.mutableCopy;
  BOOL testAllTrue = [self.subject SH_all:^BOOL(id obj) {
    return [self.matching containsObject:obj];
  }];
  
  [self.matching removeObjectAtIndex:self.matching.count-1];
  [self.matching removeObjectAtIndex:self.matching.count-1];
  [self.matching removeObjectAtIndex:self.matching.count-1];
  BOOL testAllNotAllTrue = [self.subject SH_all:^BOOL(id obj) {
    return [self.matching containsObject:obj];
  }];
  
  self.matching = @[].mutableCopy;
  if(testAllTrue) [self.matching addObject:@(1)];
  if(testAllNotAllTrue == NO) [self.matching addObject:@(2)];
  
  NSArray * matching = (NSArray * )self.matching;
  XCTAssertTrue([matching containsObject:@(1)]);
  XCTAssertTrue([matching containsObject:@(2)]);
  
  
  
}

-(void)testAny;{
  self.matching = self.subject.mutableCopy;
  BOOL testAllTrue = [self.subject SH_any:^BOOL(id obj) {
    return [self.matching containsObject:obj];
  }];
  
  [self.matching removeObjectAtIndex:self.matching.count-1];
  [self.matching removeObjectAtIndex:self.matching.count-1];
  [self.matching removeObjectAtIndex:self.matching.count-1];
  
  
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
  
  XCTAssertTrue([matching containsObject:@(1)]);
  
  XCTAssertTrue([matching containsObject:@(2)]);
  
  XCTAssertTrue([matching containsObject:@(3)]);
  
  
  
  
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
-(void)testIsEmtpy; {
  XCTAssertFalse(self.subject.SH_isEmpty);
  XCTAssertTrue(self.matching.SH_isEmpty);
  BOOL isEmpty = self.matching.count == 0;
  XCTAssertEqual(isEmpty, self.matching.SH_isEmpty);
}

-(void)testToArray; {
  NSArray * matching = self.subject.SH_toArray;
  NSArray * subject  = self.subject.array;

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
  
  [self.subject.SH_toOrderedSet enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *_) {
    XCTAssertEqualObjects(obj, self.subject[idx]);
  }];
  
  
}

-(void)testToDictionary; {
  XCTAssertTrue([self.subject.SH_toDictionary isKindOfClass:[NSDictionary class]]);
  XCTAssertTrue(self.subject.SH_toDictionary.count > 0);
  
  [self.subject SH_eachWithIndex:^(id obj, NSInteger index) {
    XCTAssertEqualObjects(self.subject[index], [self.subject.SH_toDictionary objectForKey:@(index)]);
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
  self.matching = [NSMutableOrderedSet orderedSetWithArray:@[@(0),@(1),@(2),@(3),@(4),@(5)]];
  self.subject  = [NSOrderedSet orderedSetWithArray:@[@"0",@"1",@"2",@"3",@"4",@"5"]];
  XCTAssertEqualObjects([self.subject valueForKeyPath:@"@avg.self"],
                       self.matching.SH_collectionAvg);
}

-(void)testSum; {
  self.matching = [NSMutableOrderedSet orderedSetWithArray:@[@(0),@(1),@(2),@(3),@(4),@(5)]];
  self.subject  = [NSOrderedSet orderedSetWithArray:@[@"0",@"1",@"2",@"3",@"4",@"5"]];
  XCTAssertEqualObjects([self.subject valueForKeyPath:@"@sum.self"],
                       self.matching.SH_collectionSum);
  
}


-(void)testMax; {
  self.matching = [NSMutableOrderedSet orderedSetWithArray:@[@(0),@(1),@(2),@(3),@(4),@(5)]];
  self.subject  = [NSOrderedSet orderedSetWithArray:@[@"0",@"1",@"2",@"3",@"4",@"5"]];
  
  XCTAssertEqualObjects([self.subject valueForKeyPath:@"@max.self"], self.subject.SH_collectionMax);
  XCTAssertEqualObjects([self.matching valueForKeyPath:@"@max.self"], self.matching.SH_collectionMax);
  
}

-(void)testMin; {
  self.matching = [NSMutableOrderedSet orderedSetWithArray:@[@(0),@(1),@(2),@(3),@(4),@(5)]];
  self.subject  = [NSOrderedSet orderedSetWithArray:@[@"0",@"1",@"2",@"3",@"4",@"5"]];
  
  XCTAssertEqualObjects([self.subject valueForKeyPath:@"@min.self"], self.subject.SH_collectionMin);
  XCTAssertEqualObjects([self.matching valueForKeyPath:@"@min.self"], self.matching.SH_collectionMin);
}

#pragma mark - <SHTestsFastEnumerationOrderedBlocks>
-(void)testEachWithIndex;{
  
  [self.subject SH_eachWithIndex:^(id obj, NSInteger index) {
    [self.matching addObject:@(index)];
  }];
  
  XCTAssertTrue(self.matching.count > 0);
  for (NSNumber * obj in self.matching)
    XCTAssertNotNil(self.subject[obj.unsignedIntegerValue]);
  
  
  
  
}


#pragma mark - <SHTestsFastEnumerationOrderedProperties>
-(void)testFirstObject; {
  self.matching = self.subject.mutableCopy;
  
  XCTAssertEqualObjects(self.matching.SH_firstObject,
                       self.subject[0]);
  
  self.matching = @[].mutableCopy;
  
  XCTAssertNoThrow([self.matching SH_firstObject]);
  XCTAssertNil(self.matching.SH_firstObject);
  
}

-(void)testLastObject; {
  self.matching = self.subject.mutableCopy;
  
  XCTAssertEqualObjects(self.matching.SH_lastObject,
                       self.subject.lastObject);
  
  self.matching = @[].mutableCopy;
  
  XCTAssertNoThrow([self.matching SH_lastObject]);
  XCTAssertNil(self.matching.SH_lastObject);
  
  
}

#pragma mark - <SHTestsFastEnumerationOrdered>
-(void)testReverse; {
  
  self.matching = [self.subject SH_reverse].mutableCopy;
  
  XCTAssertEqualObjects(self.subject.reversedOrderedSet,
                       self.matching);
  XCTAssertTrue(self.matching.count > 0);
  
  
}

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

  XCTAssertEqualObjects(self.matching[0], self.subject[0]);
  
  
}

-(void)testModifyFindAll; {
  self.matching = self.subject.mutableCopy;
  
  [self.matching SH_modifyFindAll:^BOOL(id obj) {
    return [self.subject indexOfObject:obj] % 2 == 0 ;
  }];


  XCTAssertTrue(self.matching.count < self.subject.count);
  XCTAssertTrue(self.matching.count > 0);
  for (id obj in self.matching) {
    NSInteger index = [self.subject indexOfObject:obj];
    XCTAssertTrue(index % 2 == 0);
  }
  
}

-(void)testModifyReject; {
  
  self.matching = self.subject.mutableCopy;
  
  [self.matching SH_modifyReject:^BOOL(id obj) {
    return [self.subject indexOfObject:obj] % 2 == 0 ;
  }];
  
  
  for (id obj in self.matching) {
    NSInteger index = [self.subject indexOfObject:obj];
    XCTAssertTrue(index % 2 != 0);
  }
  XCTAssertTrue(self.matching.count < self.subject.count);
  XCTAssertTrue(self.matching.count > 0);
}

#pragma mark - <SHTestsMutableFastEnumerationOrdered>

-(void)testModifyReverse; {
  self.matching = self.subject.mutableCopy;
  [self.matching SH_modifyReverse];
  XCTAssertEqualObjects(self.subject.reversedOrderedSet,
                       self.matching);
  XCTAssertTrue(self.matching.count > 0);
}

-(void)testPopObjectAtIndex; {
  self.matching = self.subject.mutableCopy;
  id obj = [self.matching SH_popObjectAtIndex:self.matching.count/2];
  
  XCTAssertEqualObjects(obj,
                       self.subject[self.subject.count/2]);
  
  XCTAssertTrue(self.matching.count == self.subject.count-1 );


//  XCTAssertThrowsSpecific([self.matching SH_popObjectAtIndex:NSNotFound],
//                         NSException,
//                         nil);
}

-(void)testPopFirstObject; {
  self.matching = self.subject.mutableCopy;
  id obj = [self.matching SH_popFirstObject];
  
  XCTAssertNotNil(obj);
  XCTAssertEqualObjects(obj,
                       self.subject.SH_firstObject);
  
  XCTAssertTrue(self.matching.count == self.subject.count-1 );
  
  self.matching = @[].mutableCopy;
  
  XCTAssertNoThrow([self.matching SH_popFirstObject]);
  XCTAssertNil([self.matching SH_popFirstObject]);
  
}

-(void)testPopLastObject; {
  self.matching = self.subject.mutableCopy;
  id obj = [self.matching SH_popLastObject];
  
  XCTAssertEqualObjects(obj,
                       self.subject.SH_lastObject);
  
  XCTAssertTrue(self.matching.count == self.subject.count-1 );
  
  self.matching = @[].mutableCopy;
  
  XCTAssertNoThrow([self.matching SH_lastObject]);
  XCTAssertNil([self.matching SH_lastObject]);
  
  
}

@end


@implementation NSOrderedSetTests (Private)
-(void)assertMapTableWithMapTable:(NSMapTable *)theMapTable; {
  
  XCTAssertTrue([theMapTable isKindOfClass:[NSMapTable class]]);
  XCTAssertTrue(theMapTable.count > 0);
  
  [self.subject SH_eachWithIndex:^(id obj, NSInteger index) {
    XCTAssertEqualObjects(self.subject[index], [theMapTable objectForKey:@(index)]);
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