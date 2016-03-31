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
        GCD有两种队列类型：
        ① 串行队列：串行队列中的任务，按照顺序执行，执行完一个任务才会执行下一个任
    务；
        ② 并行队列：并行队列中的任务执行过程中，会开很多线程，多个任务会同时执行。
##4.GCD获取队列的三种方式
        ① The main queue：调用dispatch_get_main_queue()来获得，因为main queue的任
    务会在主线程执行，所以是串行队列；
        ② Global queues：调用dispatch_get_global_queue来获取全局队列，是并发队列，
    队列；可以设定优先级来选择高、中(默认)、低、后台四个优先级队列
            #define DISPATCH_QUEUE_PRIORITY_HIGH        2
            #define DISPATCH_QUEUE_PRIORITY_DEFAULT     0
            #define DISPATCH_QUEUE_PRIORITY_LOW         (-2)
            #define DISPATCH_QUEUE_PRIORITY_BACKGROUND  INT16_MIN
        ③ 用户队列：（用户创建的队列）使用函数dispatch_queue_create创建的队列。根
    据传入的参数选择生成队列的类型；
            DISPATCH_QUEUE_SERIAL       串行队列
            DISPATCH_QUEUE_CONCURRENT   并行队列
##5.GCD队列的使用
        ① dispatch_async：异步执行
        ② dispatch_sync：同步执行
        ③ dispatch_apply：重复执行block，需要注意的是该方法是同步返回，也就是说等
    到所有的block执行完毕才返回。多个block的运行是否并发或串行也以来于queue的是否
    并发或串行；
        ④ dispatch_barrier_async：这个函数可以设置同步执行的block，他会等到在他加
    入队列之前的block执行完毕之后，才开始执行；在他之后加入队列的block，则等到这
    个block执行完毕之后才开始执行；
        ⑤ dispatch_barrier_sync：同上，除了他是同步返回函数；
        ⑥ dispatch_after：延迟执行block；
        ⑦ dispatch_set_target_queue：他会把需要执行的任务对象指定到不同的队列中去
    处理，这个任务对象可以是dispatch队列，也可以是dispatch源。而且这个过程可以是
    动态的，可以实现队列的动态调度管理等等。比如说有两个队列dispatchA和dispatchB，
    这时把dispatchA指派到dispatchB；
        dispatch_set_target_queue(dispatchA, dispatchB);
    那么dispatchA伤还未运行的block就会在dispatchB上运行，这是如果暂停dispatchA；
        dispatch_suspend(dispatchA);
    则只会暂停dispatchA上原来的block的执行，dispatchB的block则不受影响。而如果暂
    停dispatchB的运行，则会暂停dispatchA的运行。
##6.GCD源
