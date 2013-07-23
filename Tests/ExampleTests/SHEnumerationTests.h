//
//  SHEnumerationTests.h
//  Example
//
//  Created by Seivan Heidari on 7/22/13.
//  Copyright (c) 2013 Seivan Heidari. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@protocol SHEnumerationTests <NSObject>
@required
-(void)testEach;
-(void)testEachWithIndex;
-(void)testMap;
-(void)testReduce;
-(void)testFind;
-(void)testFindAll;
-(void)testReject;
-(void)testAll;
-(void)testAny;
-(void)testNone;

-(void)testModifyMap;
-(void)testModifyFindAll;
-(void)testModifyReject;

-(void)testPopObjectAtIndex;
-(void)testPopFirstObject;
-(void)testPopLastObject;

-(void)testFirstObject;
-(void)testLastObject;




@end

