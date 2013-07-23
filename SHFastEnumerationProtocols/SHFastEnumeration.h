

typedef void (^SHIteratorBlock)(id obj);
typedef void (^SHIteratorWithIndexBlock)(id obj, NSUInteger index) ;
typedef void (^BKIteratorWithValueBlock)(id key, id value);

typedef id (^SHIteratorReturnIdBlock)(id obj);
typedef id (^SHIteratorReduceBlock)(id memo, id obj);

typedef BOOL (^SHIteratorReturnTruthBlock)(id obj);

@protocol SHFastEnumerationBlocks <NSObject>

-(void)SH_each:(SHIteratorBlock)theBlock;

-(void)SH_concurrentEach:(SHIteratorBlock)theBlock;


-(instancetype)SH_map:(SHIteratorReturnIdBlock)theBlock; //Collect
-(instancetype)SH_reduceValue:(id)theValue withBlock:(SHIteratorReduceBlock)theBlock; //Inject/FoldLeft


-(id)SH_find:(SHIteratorReturnTruthBlock)theBlock; //Match
-(instancetype)SH_findAll:(SHIteratorReturnTruthBlock)theBlock; //Select
-(instancetype)SH_reject:(SHIteratorReturnTruthBlock)theBlock; //Filter


-(BOOL)SH_all:(SHIteratorReturnTruthBlock)theBlock; //Every
-(BOOL)SH_any:(SHIteratorReturnTruthBlock)theBlock; //Some
-(BOOL)SH_none:(SHIteratorReturnTruthBlock)theBlock;

@end

@protocol SHFastEnumerationOrderedBlocks <NSObject>
-(void)SH_eachWithIndex:(SHIteratorWithIndexBlock)theBlock;
@end


@protocol SHFastEnumerationOrderedProperties <NSObject>
@property(nonatomic,readonly) id SH_firstObject;
@property(nonatomic,readonly) id SH_lastObject;
@end


@protocol SHMutableFastEnumerationBlocks <NSObject>

-(void)SH_modifyMap:(SHIteratorReturnIdBlock)theBlock;
-(void)SH_modifyFindAll:(SHIteratorReturnTruthBlock)theBlock;
-(void)SH_modifyReject:(SHIteratorReturnTruthBlock)theBlock;

-(id)SH_popObjectAtIndex:(NSUInteger)theIndex;
-(id)SH_popFirstObject;
-(id)SH_popLastObject;

@end
@protocol SHMutableFastEnumerationOrderedBlocks <NSObject>

-(id)SH_popObjectAtIndex:(NSUInteger)theIndex;
-(id)SH_popFirstObject;
-(id)SH_popLastObject;

@end




