//
//  NSArray+SHFastEnumerationBlocks.m
//  Pods
//
//  Created by Seivan Heidari on 7/15/13.
//
//

#import "NSArray+SHFastEnumerationProtocols.h"

@implementation NSArray (SHFastEnumerationProtocols)
@dynamic SH_firstObject;
@dynamic SH_lastObject;

-(void)SH_each:(SHIteratorBlock)theBlock; { NSParameterAssert(theBlock);
	

  for (id obj in self) {
    theBlock(obj);
  }
}

-(void)SH_eachWithIndex:(SHIteratorWithIndexBlock)theBlock; { NSParameterAssert(theBlock);

  [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *_) {
    theBlock(obj,idx);
  }];
}

-(void)SH_concurrentEach:(SHIteratorBlock)theBlock; { NSParameterAssert(theBlock);

  
  [self enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger _, BOOL *__) {
    theBlock(obj);
  }];
}

-(instancetype)SH_map:(SHIteratorReturnIdBlock)theBlock; { NSParameterAssert(theBlock);

  
  NSMutableArray * map = [NSMutableArray arrayWithCapacity:self.count];
  
  for (id obj in self) {
    id value = theBlock(obj);
    if(value)
      [map addObject:value];
  }
  return map.copy;
}

-(instancetype)SH_reduceValue:(id)theValue withBlock:(SHIteratorReduceBlock)theBlock; { NSParameterAssert(theBlock);

  id result = theValue;
	for (id obj in self)result = theBlock(result,obj);
	return result;

}

-(id)SH_find:(SHIteratorReturnTruthBlock)theBlock; { NSParameterAssert(theBlock);

  id value = nil;
	NSUInteger index = [self indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
		return theBlock(obj);
	}];
	
	if (index != NSNotFound) value = self[index];
	
	return value;

}

-(instancetype)SH_findAll:(SHIteratorReturnTruthBlock)theBlock; { NSParameterAssert(theBlock);
  return [self objectsAtIndexes:[self indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger _, BOOL *__) {
		return theBlock(obj);
	}]];
}

-(instancetype)SH_reject:(SHIteratorReturnTruthBlock)theBlock; { NSParameterAssert(theBlock);
  return [self SH_findAll:^BOOL(id obj) {
    return theBlock(obj) == NO;
  }];
}

-(BOOL)SH_all:(SHIteratorReturnTruthBlock)theBlock; { NSParameterAssert(theBlock);
  
  return [self SH_findAll:theBlock].count == self.count;
}

-(BOOL)SH_any:(SHIteratorReturnTruthBlock)theBlock; { NSParameterAssert(theBlock);
  
  return [self SH_find:theBlock] != nil;
}

-(BOOL)SH_none:(SHIteratorReturnTruthBlock)theBlock; { NSParameterAssert(theBlock);
  
  return [self SH_find:theBlock] == nil;
}

-(id)SH_firstObject; {
  id obj = nil;
  if(self.count > 0) obj = [self objectAtIndex:0];
  return obj;
}

-(id)SH_lastObject; {
  return self.lastObject;
}


@end

@implementation NSMutableArray (SHMutableFastEnumerationBlocks)

-(void)SH_modifyMap:(SHIteratorReturnIdBlock)theBlock; { NSParameterAssert(theBlock);
  
	[self setArray: [self SH_map:theBlock]];
}
-(void)SH_modifyFindAll:(SHIteratorReturnTruthBlock)theBlock; { NSParameterAssert(theBlock);
  
  [self setArray:[self SH_findAll:theBlock]];
}
-(void)SH_modifyReject:(SHIteratorReturnTruthBlock)theBlock; { NSParameterAssert(theBlock);
  
  [self setArray:[self SH_reject:theBlock]];
}

-(id)SH_popObjectAtIndex:(NSUInteger)theIndex; {
  id obj = [self objectAtIndex:theIndex];
  [self removeObjectAtIndex:theIndex];
  return obj;
}

-(id)SH_popFirstObject; {
  id obj = nil;
  if(self.count > 0) obj = [self SH_popObjectAtIndex:0];
  return obj;

}

-(id)SH_popLastObject; {
  id obj = nil;
  NSInteger lastIndex = self.count-1;
  if(lastIndex >= 0) obj = [self SH_popObjectAtIndex:lastIndex];
  return obj;
}





@end

