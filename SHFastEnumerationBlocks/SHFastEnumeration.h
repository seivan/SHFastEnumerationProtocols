

typedef void (^SHIteratorBlock)(id obj);
typedef void (^SHIteratorWithIndexBlock)(id obj, NSUInteger index) ;
typedef void (^BKIteratorWithValueBlock)(id key, id value);

typedef id (^SHIteratorReturnIdBlock)(id obj);
typedef id (^SHIteratorReduceBlock)(id memo, id obj);

typedef BOOL (^SHIteratorReturnTruthBlock)(id obj);

@protocol SHFastEnumerationBlocks <NSObject>

-(void)SH_each:(SHIteratorBlock)theBlock;
-(void)SH_eachWithIndex:(SHIteratorWithIndexBlock)theBlock;
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

@protocol SHFastEnumerationExtendedBlocks <NSObject>

-(void)SH_selfMap:(SHIteratorReturnIdBlock)theBlock;
-(void)SH_selfFindAll:(SHIteratorReturnTruthBlock)theBlock;
-(void)SH_selfReject:(SHIteratorReturnTruthBlock)theBlock;

@end
