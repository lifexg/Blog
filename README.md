在聊Redux之前，我们先回顾一下之前我们使用过的设计模式MVC，MVVM，MVP，VIPER。
如图所示，由于这些设计模式是基于数据的流转来定义，所以我们也可以把他们统称为数据流框架。
![](https://upload-images.jianshu.io/upload_images/11238923-911c7e6cd030aa14.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
用了这么多年的类MVC设计模式，我们发现了一些缺陷。
- Controller容易臃肿，尤其当业务复杂的时候
- 耦合度高，测试性差。各层互相依赖，一个view依赖多个model，一个model 也会依赖多个view，一旦出现了bug，追踪困难，上下文易丢失。
- 复用差

通过上边问题的描述，我们反过来看怎么解决这个问题，所以我们希望的理想设计模式是什么样的
- 各层依赖单一
- 耦合度低，上下文明确
- 复用强

试想如果我们把类MVC的这种数据的流转模式，变成单向的，是不是就解决了这个问题。
为了解决这个问题，React里出现了一个有名的框架。
# Redux
下面聊聊redux怎么解决这个问题。
![](https://upload-images.jianshu.io/upload_images/11238923-6874c1875e787026.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
###### 构成
- Store 包含三部分
Dispatch: 分发Action的方法
Reducer：去处理Action，更新store
State：状态
- Action：描述了行为的数据结构。使用action描述所有变化带来的好处是可以清晰的知道应用发生了什么，如果应用发生了变化，就知道为什么这么变，action就像发生变化的指示器
- Reducer：跟swift的函数reduce的思想类似，新状态是由前一个状态累加起来。
Action通过reducer触发store的更新。
对于大应用来说，不可能仅仅写一个这样的函数，可以编写多个小函数分别管理state的一部分。
- State: state只读的，唯一改变state的方式就是触发action

点击view触发一个action，通过dispatcher dispatch到reducer中处理，生成一个新的state，触发store的更新，通知到view的更新
###### 三个特性
1. 单数据流模式
所有状态存放在唯一的Store中，View 内部也是尽量没有自己的状态，当Store中状态变化，则View会进行更新，当View有用户的操作，则Store就进行更新。 所有状态清晰明了，当发现问题时候只需要检查状态就可以了。
2. 可以预测性，（通过reducer的含义）
state + action = new state
state发生的任何变化，一定是有action引起的，保证了Redux应用一定是会被追踪的，一旦发现状态发生了问题，一定是能找到对应的action
3. 纯函数更新Store
纯函数的定义：函数的输出结果完全取决于传进来的参数，不依赖任何外部变量，不会产生副作用
特点：容易测试

通过Redux的三个特性，对应了上边提到的解决了mvc架构的痛点
