//
//  NSObject+BKBlockExecution.m
//  BlocksKit
//

#import "NSObject+BKBlockExecution.h"

#define BKTimeDelay(t) dispatch_time(DISPATCH_TIME_NOW, (uint64_t)(NSEC_PER_SEC * t))

@implementation NSObject (BlocksKit)

- (id)bk_performBlock:(void (^)(id obj))block afterDelay:(NSTimeInterval)delay
{
	return [self bk_performBlock:block onQueue:dispatch_get_main_queue() afterDelay:delay];
}

+ (id)bk_performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay
{
	return [NSObject bk_performBlock:block onQueue:dispatch_get_main_queue() afterDelay:delay];
}

- (id)bk_performBlockInBackground:(void (^)(id obj))block afterDelay:(NSTimeInterval)delay
{
	return [self bk_performBlock:block onQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0) afterDelay:delay];
}

+ (id)bk_performBlockInBackground:(void (^)(void))block afterDelay:(NSTimeInterval)delay
{
	return [NSObject bk_performBlock:block onQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0) afterDelay:delay];
}

- (id)bk_performBlock:(void (^)(id obj))block onQueue:(dispatch_queue_t)queue afterDelay:(NSTimeInterval)delay
{
	NSParameterAssert(block != nil);
	
	__block BOOL cancelled = NO;
	
	void (^wrapper)(BOOL) = ^(BOOL cancel) {
		if (cancel) {
			cancelled = YES;
			return;
		}
		if (!cancelled) block(self);
	};
	
	dispatch_after(BKTimeDelay(delay), queue, ^{
		wrapper(NO);
	});
	
	return [wrapper copy];
}

+ (id)bk_performBlock:(void (^)(void))block onQueue:(dispatch_queue_t)queue afterDelay:(NSTimeInterval)delay
{
	NSParameterAssert(block != nil);
	//cancelled是个__block变量，使得该block在加入queue后能够逻辑上取消。注意，仅仅是逻辑上取消，不能把block从queue中剔除。
	__block BOOL cancelled = NO;
    //在外部block之上加一层能够逻辑取消的代码，使其变为一个wrapper block
    //当调用wrapper(YES)的时候就让__block BOOL cancelled = YES,使得以后每次block主体都被跳过。
	void (^wrapper)(BOOL) = ^(BOOL cancel) {
        //cancel参数是为了在外部能够控制cancelled _block变量
		if (cancel) {
			cancelled = YES;
			return;
		}
		if (!cancelled) block();
	};
	//每个投入queue中的block实际上是wraper版的block
	dispatch_after(BKTimeDelay(delay), queue, ^{
        //把cancel设置为NO,block能够逻辑执行
        wrapper(NO);
    });
	//返回wraper block，以便bk_cancelBlock的时候使用
	return [wrapper copy];
}

+ (void)bk_cancelBlock:(id)block
{
	NSParameterAssert(block != nil);
    //把cancel设置为YES,修改block中_block cancelled变量，如果此时block未执行则，block在执行的时候其逻辑主体会被跳过
	void (^wrapper)(BOOL) = block;
	wrapper(YES);
}

@end
