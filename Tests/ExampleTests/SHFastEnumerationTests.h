//
//  SHEnumerationTests.h
//  Example
//
//  Created by Seivan Heidari on 7/22/13.
//  Copyright (c) 2013 Seivan Heidari. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>


@protocol SHTestsFastEnumerationBlocks <NSObject>
#pragma mark - <SHTestsFastEnumerationBlocks>
-(void)testEach;
-(void)testMap;
-(void)testReduce;
-(void)testFind;
-(void)testFindAll;
-(void)testReject;
-(void)testAll;
-(void)testAny;
-(void)testNone;
@end

@protocol SHTestsFastEnumerationOrderedBlocks <NSObject>
#pragma mark - <SHTestsFastEnumerationOrderedBlocks>
-(void)testEachWithIndex;
@end

@protocol SHTestsFastEnumerationOrderedProperties <NSObject>
#pragma mark - <SHTestsFastEnumerationOrderedProperties>
-(void)testFirstObject;
-(void)testLastObject;
@end

@protocol SHTestsFastEnumerationOrdered <NSObject>
#pragma mark - <SHTestsFastEnumerationOrdered>
-(void)testReverse;
@end

@protocol SHTestsMutableFastEnumerationBlocks <NSObject>
#pragma mark - <SHTestsMutableFastEnumerationBlocks>
-(void)testModifyMap;
-(void)testModifyFindAll;
-(void)testModifyReject;
@end

@protocol SHTestsMutableFastEnumerationOrdered <NSObject>
#pragma mark - <SHTestsMutableFastEnumerationOrdered>
-(void)testModifyReverse;
-(void)testPopObjectAtIndex;
-(void)testPopFirstObject;
-(void)testPopLastObject;
@end
