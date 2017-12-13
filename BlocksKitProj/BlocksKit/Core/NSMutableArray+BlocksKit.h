//
//  NSMutableArray+BlocksKit.h
//  BlocksKit
//

#import <Foundation/Foundation.h>

/** Block extensions for NSMutableArray.

 These utilities expound upon the BlocksKit additions to the immutable
 superclass by allowing certain utilities to work on an instance of the mutable
 class, saving memory by not creating an immutable copy of the results.

 Includes code by the following:

 - [Martin Schürrer](https://github.com/MSch)
 - [Zach Waldowski](https://github.com/zwaldowski)

 @see NSArray(BlocksKit)
 */
@interface NSMutableArray (BlocksKit)

/** Filters a mutable array to the objects matching the block.

 @param block A single-argument, BOOL-returning code block.
 @see <NSArray(BlocksKit)>bk_reject:
 */
//删除容器中!!!不符合block条件的对象，即只保留符合block条件的对象
- (void)bk_performSelect:(BOOL (^)(id obj))block;

/** Filters a mutable array to all objects but the ones matching the block,
 the logical inverse to bk_select:.

 @param block A single-argument, BOOL-returning code block.
 @see <NSArray(BlocksKit)>bk_select:
 */
//删除容器中符合block条件的对象
- (void)bk_performReject:(BOOL (^)(id obj))block;

/** Transform the objects in the array to the results of the block.

 This is sometimes referred to as a transform, mutating one of each object:
	[foo bk_performMap:^id(id obj) {
	  return [dateTransformer dateFromString:obj];
	}];

 @param block A single-argument, object-returning code block.
 @see <NSArray(BlocksKit)>bk_map:
 */
//容器中的对象变换为自己的block映射对象
- (void)bk_performMap:(id (^)(id obj))block;

@end
