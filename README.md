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
##5.各种队列的执行效果
            |全局并发队列|手动创建串行队列|主队列
        ----|------------|----------------|------
        同步|没有开启分线程（串行）|没有开启分线程（串行）|没有开启分线程（串行）
        异步|开启分线程（并发）|开启分线程（串行）|没有开启分线程（串行）
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
##6.GCD源（dispatch source）
        dispatch源和runLoop源概念上有些类似的地方，而且使用起来更加简单，dispatch
    源可以看成一种特别的生产消费模式。dispatch源好比生产的数据，当有新数据时，会自
    动在dispatch指定的队列（即消费队列）上运行相应的block，生产和消费同步是dispatch
    源自动管理的。
##7.GCD源的使用步骤
        ① dispatch_source_create：创建dispatch源，这里使用加法来合并dispatch源数
    据，同事指定dispatch队列；
        ② dispatch_source_set_event_handle：设置响应dispatch源事件的block，在
    dispatch源指定的队列上运行；
        ③ dispatch_resume：dispatch源创建后处于suspend状态，所以要启动dispatch预案；
        ④ dispatch_source_merge_data：合并dispatch源数据，在dispatch源的block中，可
    以通过dispatch_source_get_data就会得到数据；
        比如网络请求的模式，就可以这样来写：
        dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_DA
            TA_ADD, 0, dispatch_get_global_queue(0, 0));
        dispatch_source_set_event_handle(source, ^{
            dispatch_sync(dispatch_get_main_queue(), ^{
                //更新UI
            );
        });
        dispatch_resume(source);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            //网络请求
            dispatch_source_merge_data(source, 1); //通知队列
        });
##8.dispatch源还支持其他的一些系统源
        包括定时器、监控文件的读写、监控文件系统、监控信号或进程等，基本上调用的方
    式原理和上面相同，只是有可能是系统自动触发时间。
        例如dispatch定时器：
        dispatch_source_t source timer = dispatch_source_create(DISPATCH_SOURCE_T
    YPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 10*NSEC_PER_
    SEC, 1*NSEC_PER_SEC); //每10秒触发timer，误差1秒
        dispatch_source_set_event_handle(timer, ^{
            //定时处理
        });
        dispatch_resume(timer);
##9.dispatch源的其他函数
        ① dispatch_source_get_handle：得到dispatch源创建，即调用dispatch_source_c
    reate的第二个参数；
        ② dispatch_source_get_mask：得到dispatch源创建，即调用dispatch_source_cre
    ate的第三个参数；
        ③ dispatch_source_cancel：取消dispatch源的时间处理，即不在调用block。
        ④ dispatch_source_testcancel：检测是否dispatch源被取消，如果返回非0值则表
    明dispatch源已经被取消；
        ⑤ dispatch_source_set_cancel_handle：dispatch源取消时调用的block，一般用
    于关闭文件或socket等，释放相关资源；
        ⑥ dispatch_source_set_registration_handle：可用于设置dispatch源启动时调用
    block，调用完即释放这个block，也可在block源运行当中随时调用这个函数。
##10.dispatch同步
        GCD提供两种方式支持dispatch队列同步，即dispatch组合信号量：
        ① dispatch组（dispatch group）
        //创建dispatch组
        dispatch_group_t group = dispatch_group_create(); 
        //启动dispatch队列中的block，关联到group中
        dispatch_group_async(group, queue, ^{
            //。。
        });
        //等待group关联的block执行完毕，也可设置超时参数
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
        //为group设置通知一个block，当group关联的block执行完毕后，就调用这个block
    类似dispatch_barrier_async
        dispatch_group_notify(group, queue, ^{
            // 。。。        
        });
        //手动管理group关联的block的运行状态（或计数），进入和退出group次数必须匹
    配
        dispatch_group_enter(group);
        dispatch_group_leave(group);
        ② dispatch信号量（dispatch semaphore）
        //创建信号量，可以设置信号量的资源数，0表示没有资源
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        //等待信号，可以设置超时参数，该函数返回0表示得到通知，非0表示超时
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        //通知信号，如果等待线程被唤醒，则返回非0，否则返回0
        dispatch_semaphore_signal(semaphore);
##11.单次初始化
        GCD还提供单次初始化支持，这个与pthread中的函数pthread_once很相似，GCD提供
    的方式的优点在于他使用block而非函数指针；
        这个特性的主要用途是蓝星单例的初始化或者其他的线程安全数据共享；
        使用函数dispatch_once_t;
