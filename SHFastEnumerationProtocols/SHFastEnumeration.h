

typedef void (^SHIteratorBlock)(id obj);
typedef void (^SHIteratorWithIndexBlock)(id obj, NSUInteger index) ;
typedef void (^BKIteratorWithValueBlock)(id key, id value);

typedef id (^SHIteratorReturnIdBlock)(id obj);
typedef id (^SHIteratorReduceBlock)(id memo, id obj);

typedef BOOL (^SHIteratorReturnTruthBlock)(id obj);

#pragma mark - <SHFastEnumerationBlocks>
@protocol SHFastEnumerationBlocks <NSObject>
@required
-(void)SH_each:(SHIteratorBlock)theBlock;
-(void)SH_concurrentEach:(SHIteratorBlock)theBlock;
-(instancetype)SH_map:(SHIteratorReturnIdBlock)theBlock; //Collect
-(id)SH_reduceValue:(id)theValue withBlock:(SHIteratorReduceBlock)theBlock; //Inject/FoldLeft
-(id)SH_find:(SHIteratorReturnTruthBlock)theBlock; //Match
-(instancetype)SH_findAll:(SHIteratorReturnTruthBlock)theBlock; //Select
-(instancetype)SH_reject:(SHIteratorReturnTruthBlock)theBlock; //Filter
-(BOOL)SH_all:(SHIteratorReturnTruthBlock)theBlock; //Every
-(BOOL)SH_any:(SHIteratorReturnTruthBlock)theBlock; //Some
-(BOOL)SH_none:(SHIteratorReturnTruthBlock)theBlock; // !Every
@end

#pragma mark - <SHFastEnumerationProperties>
@protocol SHFastEnumerationProperties <NSObject>
@property(nonatomic,readonly) NSArray      * SH_toArray;
@property(nonatomic,readonly) NSSet        * SH_toSet;
@property(nonatomic,readonly) NSOrderedSet * SH_toOrderedSet;
@property(nonatomic,readonly) NSDictionary * SH_toDictionary;

@property(nonatomic,readonly) NSMapTable   * SH_toMapTableWeakToWeak;
@property(nonatomic,readonly) NSMapTable   * SH_toMapTableWeakToStrong;
@property(nonatomic,readonly) NSMapTable   * SH_toMapTableStrongToStrong;
@property(nonatomic,readonly) NSMapTable   * SH_toMapTableStrongToWeak;

@property(nonatomic,readonly) NSHashTable   * SH_toHashTableWeak;
@property(nonatomic,readonly) NSHashTable   * SH_toHashTableStrong;
@end

#pragma mark - <SHFastEnumerationOrderedBlocks>
@protocol SHFastEnumerationOrderedBlocks <NSObject>
@required
-(void)SH_eachWithIndex:(SHIteratorWithIndexBlock)theBlock;
@end

#pragma mark - <SHFastEnumerationOrderedProperties>
@protocol SHFastEnumerationOrderedProperties <NSObject>
@required
@property(nonatomic,readonly) id SH_firstObject;
@property(nonatomic,readonly) id SH_lastObject;
@end


#pragma mark - <SHFastEnumerationOrdered>
@protocol SHFastEnumerationOrdered <NSObject>
@required
-(instancetype)SH_reverse;
@end


#pragma mark - <SHMutableFastEnumerationBlocks>
@protocol SHMutableFastEnumerationBlocks <NSObject>
@required
-(void)SH_modifyMap:(SHIteratorReturnIdBlock)theBlock;
-(void)SH_modifyFindAll:(SHIteratorReturnTruthBlock)theBlock;
-(void)SH_modifyReject:(SHIteratorReturnTruthBlock)theBlock;
@end


#pragma mark - <SHMutableFastEnumerationOrdered>
@protocol SHMutableFastEnumerationOrdered <NSObject>
@required
-(void)SH_modifyReverse;
-(id)SH_popObjectAtIndex:(NSUInteger)theIndex;
-(id)SH_popFirstObject;
-(id)SH_popLastObject;
@end



