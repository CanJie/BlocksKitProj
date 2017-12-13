//
//  A2DynamicDelegate.h
//  BlocksKit
//

#import <Foundation/Foundation.h>
#import "NSObject+A2BlockDelegate.h"
#import "NSObject+A2DynamicDelegate.h"

/** A2DynamicDelegate implements a class's delegate, data source, or other
 delegated protocol by associating protocol methods with a block implementation.
代理是objective c里常用的模式，主要用来做逻辑切分，一个类做一类事情，让代码的耦合度减少。但他不方便的地方在于，要创建一个代理，就要定义一个类，声明这个类遵循那些接口，然后实现这些接口对应的函数。动态代理(Dynamic delegate)则让我们能够在code里，on the fly的创建这样一个代理，通过block定义要实现的方法。 
 
	- (IBAction) annoyUser
	{
		// 创建一个alert view
		UIAlertView *alertView = [[UIAlertView alloc]
								  initWithTitle:@"Hello World!"
								  message:@"This alert's delegate is implemented using blocks. That's so cool!"
								  delegate:nil
								  cancelButtonTitle:@"Meh."
								  otherButtonTitles:@"Woo!", nil];

		// 获取该alert view的动态代理对象（什么是动态代理对象稍后会说）
		A2DynamicDelegate *dd = alertView.bk_dynamicDelegate;

		// Implement -alertViewShouldEnableFirstOtherButton:
        // 调用动态代理对象的 - (void)implementMethod:(SEL)selector withBlock:(id)block;方法，使得SEL映射一个block对象(假设叫做block1)
		[dd implementMethod:@selector(alertViewShouldEnableFirstOtherButton:) withBlock:^(UIAlertView *alertView) {
			NSLog(@"Message: %@", alertView.message);
			return YES;
		}];

		// Implement -alertView:willDismissWithButtonIndex:
        // 同上，让映射-alertView:willDismissWithButtonIndex:的SEL到另外一个block对象(假设叫做block2)
		[dd implementMethod:@selector(alertView:willDismissWithButtonIndex:) withBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
			NSLog(@"You pushed button #%d (%@)", buttonIndex, [alertView buttonTitleAtIndex:buttonIndex]);
		}];

		// 把alertView的delegate设置为动态代理
		alertView.delegate = dd;

		[alertView show];
        // 那么，alert view在显示的时候收到alertViewShouldEnableFirstOtherButton:消息调用block1；alert view在消失的时候收到alertView:willDismissWithButtonIndex:消息，调用block2
	}

 A2DynamicDelegate is designed to be 'plug and play'.
 
 从上面的代码我们可以直观地看到：dd（动态代理对象）直接被设置为alert view的delegate对象，那么该alert view的UIAlertViewDelegate消息直接传递向给了dd。然后dd又通过某种方式把对应的SEL调用转为对应的block调用。我们又可以作出如下猜测：
 1、dd内部可能有个dic一样的数据结构，key可能是SEL，value可能是与之对应的block，通过implementMethod:withBlock:这个方法把SEL和block以键值对的形式建立起dic映射
 2、Host对象（本例是alertView）向dd发delegate消息的时候传递了SEL，dd在内部的dic数据结构查找对应的block，找到后，调用该block。
 */
@interface A2DynamicDelegate : NSProxy

/**
 * The designated initializer for the A2DynamicDelegate proxy.
 *
 * An instance of A2DynamicDelegate should generally not be created by the user,
 * but instead by calling a method in NSObject(A2DynamicDelegate). Since
 * delegates are usually weak references on the part of the delegating object, a
 * dynamic delegate would be deallocated immediately after its declaring scope
 * ends. NSObject(A2DynamicDelegate) creates a strong reference.
 *
 * @param protocol A protocol to which the dynamic delegate should conform.
 * @return An initialized delegate proxy.
 */
- (id)initWithProtocol:(Protocol *)protocol;

/** The protocol delegating the dynamic delegate. */
@property (nonatomic, readonly) Protocol *protocol;

/** A dictionary of custom handlers to be used by custom responders
 in a A2Dynamic(Protocol Name) subclass of A2DynamicDelegate, like
 `A2DynamicUIAlertViewDelegate`. */
@property (nonatomic, strong, readonly) NSMutableDictionary *handlers;

/** When replacing the delegate using the A2BlockDelegate extensions, the object
 responding to classical delegate method implementations. */
@property (nonatomic, weak, readonly) id realDelegate;


/** @name Block Instance Method Implementations */
#pragma mark - Block Instance Method Implementations
/** The block that is to be fired when the specified
 selector is called on the reciever.

 @param selector An encoded selector. Must not be NULL.
 @return A code block, or nil if no block is assigned.
 */
- (id)blockImplementationForMethod:(SEL)selector;

/** Assigns the given block to be fired when the specified
 selector is called on the reciever.

	[tableView.dynamicDataSource implementMethod:@selector(numberOfSectionsInTableView:)
									  withBlock:NSInteger^(UITableView *tableView) {
		return 2;
	}];

 @warning Starting with A2DynamicDelegate 2.0, a block will
 not be checked for a matching signature. A block can have
 less parameters than the original selector and will be
 ignored, but cannot have more.

 @param selector An encoded selector. Must not be NULL.
 @param block A code block with the same signature as selector.
 */
- (void)implementMethod:(SEL)selector withBlock:(id)block;

/** Disassociates any block so that nothing will be fired
 when the specified selector is called on the reciever.

 @param selector An encoded selector. Must not be NULL.
 */
- (void)removeBlockImplementationForMethod:(SEL)selector;

/** @name Block Class Method Implementations */
#pragma mark - Block Class Method Implementations
/** The block that is to be fired when the specified
 selector is called on the delegating object's class.

 @param selector An encoded selector. Must not be NULL.
 @return A code block, or nil if no block is assigned.
 */
- (id)blockImplementationForClassMethod:(SEL)selector;

/** Assigns the given block to be fired when the specified
 selector is called on the reciever.

 @warning Starting with A2DynamicDelegate 2.0, a block will
 not be checked for a matching signature. A block can have
 less parameters than the original selector and will be
 ignored, but cannot have more.

 @param selector An encoded selector. Must not be NULL.
 @param block A code block with the same signature as selector.
 */
- (void)implementClassMethod:(SEL)selector withBlock:(id)block;

/** Disassociates any blocks so that nothing will be fired
 when the specified selector is called on the delegating
 object's class.

 @param selector An encoded selector. Must not be NULL.
 */
- (void)removeBlockImplementationForClassMethod:(SEL)selector;

@end
