//
//  ReadMe.h
//  BlocksKitProj
//
//  Created by dongchanghao on 2017/12/6.
//  Copyright © 2017年 apple. All rights reserved.
//

#ifndef ReadMe_h
#define ReadMe_h

http://blog.csdn.net/xiaoxiaobukuang/article/details/51752273
http://blog.csdn.net/qq_22142085/article/details/41944965
神奇的 BlocksKit （一）
//http://www.cocoachina.com/ios/20160505/16112.html
神奇的 BlocksKit （二）
//http://www.cocoachina.com/ios/20160505/16113.html?_t_t_t=0.36455772491171956
一、引言
众所周知Block已被广泛用于iOS编程。它们通常被用作可并发执行的逻辑单元的封装，或者作为事件触发的回调。Block比传统回调函数有2点优势：
1.允许在调用点上下文书写执行逻辑，不用分离函数
2.Block可以使用local variables.

基于以上种种优点Cocoa Touch越发支持Block式编程，这点从UIView的各种动画效果可用Block实现就可见一斑。而BlocksKit是对Cocoa Touch Block编程更进一步的支持，它简化了Block编程，发挥Block的相关优势，让更多UIKit类支持Block式编程。BlocksKit是一个block的大杂烩，它给Fundation和UIKit框架里很多的类都做了扩展，可以通过调用相关类的扩展的方法简单的实现一下几个功能：
1.通过block传入事件处理函数
2.创建动态代理，传入block给想要实现的方法。
3.在很多基础的类上增加额外的方法
block可以帮助我们组织独立的代码段,并提高复用性和可读性。而BlocksKit可以很简单的实现block，实现回调，和通信，可以大大减少工作量。

二、下载
1、链接
在浏览器输入https://github.com/zwaldowski/BlocksKit这个连接，进入下面这个页面：
2、下载
点击Clone or download，下载最新的BlocksKit-master；
3、文件结构图
下载下来的文件结构如下图：

4、BlocksKit目录结构
BlocksKit代码存放在4个目录中分别是Core、DynamicDelegate、MessageUI、UIKit。其中：
Core 存放Foundation Kit相关的Block category
UIKit 存放UIKit相关的Block category
MessageUI 存放MessageUI相关的Block category
DynamicDelegate动态代理（一种事件转发机制）相关代码

5、Core相关代码分析
Core文件夹下面的代码可以分为如下几个部分：
1、容器相关（NSArray、NSDictionary、NSSet、NSIndexSet、NSMutableArray、NSMutableDictionary、NSMutableSet、NSMutableIndexSet）
2、关联对象相关
3、逻辑执行相关
4、KVO相关
5、定时器相关

6、DynamicDelegate动态代理关代码分析
动态代理这部分可以说是 BlocksKit 的精华。它使用 block 属性替换 UIKit 中的所有能够通过代理完成的事件，省略了设置代理和实现方法的过程，让对象自己实现代理方法（其实不是对象自己实现的代理方法，只是框架为我们提供的便捷方法，不需要构造其它对象就能完成代理方法的实现，具体我们会在后面详细地解释），而且这个功能的实现是极其动态的。

下面是这部分几个关键的类：
A2BlockInvocation 的主要作用是存储和转发 block
A2DynamicDelegate 用来实现类的代理和数据源，它是 NSProxy 的子类
NSObject+A2DynamicDelegate 负责为返回bk_dynamicDelegate和bk_dynamicDataSource等
    A2DynamicDelegate类型的实例，为 NSObject 提供主要的接口
NSObject+A2BlockDelegate 提供了一系列接口将代理方法映射到 block 上
其他的 UIKit 的分类提供对应的属性，并在对应的 A2DynamicDelegate 子类中实现代理方法

7、导入工程
导入工程有两种方式：
第一种
按照官方文档描述，编译成静态库，添加到自己的文件工程中。
第二种
把文件BlocksKit添加到自己工程文件中，然后修改部分.h文件；
修改规则如下：#import <BlocksKit/BlocksKit.h>——》#import "BlocksKit.h"
即库的引用方式改为文件的引用方式

#endif /* ReadMe_h */
