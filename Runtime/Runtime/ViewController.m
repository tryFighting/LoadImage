//
//  ViewController.m
//  Runtime
//
//  Created by csmd on 2017/6/22.
//  Copyright © 2017年 jackLee. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
@interface ViewController ()

@end

@implementation ViewController
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //创建监听者
    /*
     第一个参数 CFAllocatorRef allocator：分配存储空间 CFAllocatorGetDefault()默认分配
     第二个参数 CFOptionFlags activities：要监听的状态 kCFRunLoopAllActivities 监听所有状态
     第三个参数 Boolean repeats：YES:持续监听 NO:不持续
     第四个参数 CFIndex order：优先级，一般填0即可
     第五个参数 ：回调 两个参数observer:监听者 activity:监听的事件
     */
    /*
     所有事件
     typedef CF_OPTIONS(CFOptionFlags, CFRunLoopActivity) {
     kCFRunLoopEntry = (1UL << 0),   //   即将进入RunLoop
     kCFRunLoopBeforeTimers = (1UL << 1), // 即将处理Timer
     kCFRunLoopBeforeSources = (1UL << 2), // 即将处理Source
     kCFRunLoopBeforeWaiting = (1UL << 5), //即将进入休眠
     kCFRunLoopAfterWaiting = (1UL << 6),// 刚从休眠中唤醒
     kCFRunLoopExit = (1UL << 7),// 即将退出RunLoop
     kCFRunLoopAllActivities = 0x0FFFFFFFU
     };
     */
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        switch (activity) {
            case kCFRunLoopEntry:
                NSLog(@"RunLoop进入");
                break;
            case kCFRunLoopBeforeTimers:
                NSLog(@"RunLoop要处理Timers了");
                break;
            case kCFRunLoopBeforeSources:
                NSLog(@"RunLoop要处理Sources了");
                break;
            case kCFRunLoopBeforeWaiting:
                NSLog(@"RunLoop要休息了");
                break;
            case kCFRunLoopAfterWaiting:
                NSLog(@"RunLoop醒来了");
                break;
            case kCFRunLoopExit:
                NSLog(@"RunLoop退出了");
                break;
                
            default:
                break;
        }
    });
    
    // 给RunLoop添加监听者
    /*
     第一个参数 CFRunLoopRef rl：要监听哪个RunLoop,这里监听的是主线程的RunLoop
     第二个参数 CFRunLoopObserverRef observer 监听者
     第三个参数 CFStringRef mode 要监听RunLoop在哪种运行模式下的状态
     */
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
    /*
     CF的内存管理（Core Foundation）
     凡是带有Create、Copy、Retain等字眼的函数，创建出来的对象，都需要在最后做一次release
     GCD本来在iOS6.0之前也是需要我们释放的，6.0之后GCD已经纳入到了ARC中，所以我们不需要管了
     */
    CFRelease(observer);
}
- (void)show{
    
    NSLog(@"------------");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    // 需求：给imageNamed方法提供功能，每次加载图片就判断下图片是否加载成功。
    // 步骤一：先搞个分类，定义一个能加载图片并且能打印的方法+ (instancetype)imageWithName:(NSString *)name;
    // 步骤二：交换imageNamed和imageWithName的实现，就能调用imageWithName，间接调用imageWithName的实现。
    //加载一张空图片 防止报错
    UIImage *image = [UIImage imageNamed:@"123"];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    imageView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    imageView.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:imageView];
}
- (void)runloop{
    
}
- (void)runtime{
    unsigned int count;
    //获取属性列表
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    for (unsigned int i=0; i<count; i++) {
        const char *propertyname =" property_getName(propertyList[i]);";
        NSLog(@"property----="">%@", [NSString stringWithUTF8String:propertyname]);
    }
    //获取方法列表
    Method *methodList = class_copyMethodList([self class], &count);
    for (unsigned int i; i<count; i++) {
        Method method =" methodList[i];";
        NSLog(@"method----="">%@", NSStringFromSelector(method_getName(method)));
    }
    //获取成员变量列表
    Ivar *ivarList = class_copyIvarList([self class], &count);
    for (unsigned int i; i<count; i++) {
        Ivar myivar =" ivarList[i];";         const char *ivarname =" ivar_getName(myIvar);";
        NSLog(@"ivar----="">%@", [NSString stringWithUTF8String:ivarname]);
    }
    //获取协议列表
    __unsafe_unretained Protocol **protocolList = class_copyProtocolList([self class], &count);
    for (unsigned int i; i<count; i++) {
        //        Protocol *myprotocal ="protocolList[i];";
        //        const char *protocolname =" protocol_getName(myProtocal);";
        //        NSLog(@"protocol----="">%@", [NSString stringWithUTF8String:protocol_getName]);
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
