# iOS-GCD
        GCD全称Grand Central Dispatch，是一套底层的API，提供了一种新的方法来进行
    并发程序的编写。从基本功能上看，有点像NSOperationQueue，他们都允许程序将任务
    分为多个单一任务，然后提交至工作队列来并发或串行地执行。
        GCD比NSOperationQueue更底层，更搞笑，并且他不是Cocoa框架的一部分。
##1.GCD的优势
        ① 易用：GCD比NSThread更简单易用。GCD可以控制诸如等待任务结束、监视文件描
    述符、周期执行代码以及工作挂起等任务。并且基于block语法，导致他能极为简单的
    在不同代码作用域之间传递上下文；
        ② 效率：GCD被实现的如此轻量和优雅；使他在很多地方比专门创建消耗资源的线
    程更实用且快速；
        ③ 性能：GCD自动根据系统负载来增减线程数量，这就减少了上下文切换以及增加了
    计算效率。
##2.GCD对象（Dispatch Objects）
        Dispatch object像Cocoa对象一样，使用引用计数来管理内存；使用dispatch_retain
    和dispatch_release来操作引用计数；但是dispatch object需要手动来管理内存。
##3.GCD队列（Dispatch Queues）
        GCD有三种队列类型：
        ① The main queue：与主线程功能相同。实际上，提交至main queue的任务会在主
    线程中执行。main queue可以调用dispatch_get_main_queue()来获得，因为main queue
    与主线程相关，所以是串行队列；
        ② Global queues：全局队列是并发队列，并由整个进程共享。进程中存在三个全局
    队列；高、中(默认)、低、后台四个优先级队列。可以调用dispatch_get_global_queue
    函数传入优先级来访问队列。优先级有：
            #define DISPATCH_QUEUE_PRIORITY_HIGH        2
            #define DISPATCH_QUEUE_PRIORITY_DEFAULT     0
            #define DISPATCH_QUEUE_PRIORITY_LOW         (-2)
            #define DISPATCH_QUEUE_PRIORITY_BACKGROUND  INT16_MIN
        ③ 用户队列：（用户创建的队列）使用函数dispatch_queue_create创建的队列。这
    些队列是串行的，正因为如此，他们可以用来完成同步机制。
