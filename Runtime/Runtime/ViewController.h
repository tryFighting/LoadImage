//
//  ViewController.h
//  Runtime
//
//  Created by csmd on 2017/6/22.
//  Copyright © 2017年 jackLee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
//拦截调用
//当你调用一个不存在的类时，会调用这个方法，默认返回NO，你可以加上自己的处理后返回YES
+ (BOOL)resolveClassMethod:(SEL)sel;//类方法
//实例方法调用
+ (BOOL)resolveInstanceMethod:(SEL)sel;//实例方法
//后两个方法需要转发到其他的类处理
//将你调用的不存在的方法重新定向到一个其他声明了这个方法的类，只需要你返回一个有这个方法的target
- (id)forwardingTargetForSelector:(SEL)aSelector;
//第四个将你调用不存在的方法打包成NSInvocation传给你。做好你自己的处理后，调用invokeWithTarget方法让某个target触发这个方法
- (void)forwardInvocation:(NSInvocation *)anInvocation;
@end

