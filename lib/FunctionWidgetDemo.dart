import 'dart:collection';
import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShareDataWidget extends InheritedWidget {
  final int data; //需要在子树中共享的数据，保存点击次数

  ShareDataWidget({Key? key, required this.data, required Widget child})
      : super(key: key, child: child);

  //该回调决定当data发生变化时，是否通知子树中依赖data的Widget
  @override
  bool updateShouldNotify(ShareDataWidget old) {
    return old.data != data;
  }

  //定义一个便捷方法，方便子树中的widget获取共享数据
  static ShareDataWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ShareDataWidget>();
    //return context.getElementForInheritedWidgetOfExactType<ShareDataWidget>().widget;
  }
}

class _ReceiveWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ReceiveWidgetState();
}

class _ReceiveWidgetState extends State<_ReceiveWidget> {
  @override
  Widget build(BuildContext context) {
    return Text(ShareDataWidget.of(context)!.data.toString());
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    //父或祖先widget中的InheritedWidget改变(updateShouldNotify返回true)时会被调用。
    //如果build中没有依赖InheritedWidget，则此回调不会被调用。
    print("Dependencies change");
  }
}

class InheritedWidgetTestRoute extends StatefulWidget {
  @override
  _InheritedWidgetTestRouteState createState() =>
      _InheritedWidgetTestRouteState();
}

class _InheritedWidgetTestRouteState extends State<InheritedWidgetTestRoute> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ShareDataWidget(
        //使用ShareDataWidget
        data: count,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: _ReceiveWidget(), //子widget中依赖ShareDataWidget
            ),
            FloatingActionButton(
              child: Text("Increment"),
              //每点击一次，将count自增，然后重新build,ShareDataWidget的data将被更新
              onPressed: () => setState(() => ++count),
            )
          ],
        ),
      ),
    );
  }
}

/**
 * TODO 跨组件共享 Provider
 */

//todo 一个通用的InteriteWidget，最小化实现Provider

class InheritedProvider<T> extends InheritedWidget {
  final T data;

  InheritedProvider({required this.data, required Widget child})
      : super(child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
}

class ChangeNotifierProvider<T extends ChangeNotifier> extends StatefulWidget {
  ChangeNotifierProvider({
    Key? key,
    required this.data,
    required this.child,
  });

  final Widget child;
  final T data;

  //定义一个便捷方法，方便子树中的widget获取共享数据
  // static T of<T>(BuildContext context) {
  //   final provider =
  //       context.dependOnInheritedWidgetOfExactType<InheritedProvider<T>>();
  //   return provider!.data;
  // }

  //添加一个listen参数，表示是否建立依赖关系
  static T of<T>(BuildContext context, {bool listen = true}) {
    final provider = listen
        ? context.dependOnInheritedWidgetOfExactType<InheritedProvider<T>>()
        : context.getElementForInheritedWidgetOfExactType<InheritedProvider<T>>()?.widget
    as InheritedProvider<T>;
    return provider!.data;
  }
  @override
  _ChangeNotifierProviderState<T> createState() =>
      _ChangeNotifierProviderState<T>();
}

class _ChangeNotifierProviderState<T extends ChangeNotifier>
    extends State<ChangeNotifierProvider<T>> {
  void update() {
    //如果数据发生变化（model类调用了notifyListeners），重新构建InheritedProvider
    setState(() => {});
  }

  @override
  void didUpdateWidget(ChangeNotifierProvider<T> oldWidget) {
    //当Provider更新时，如果新旧数据不"=="，则解绑旧数据监听，同时添加新数据监听
    if (widget.data != oldWidget.data) {
      oldWidget.data.removeListener(update);
      widget.data.addListener(update);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    // 给model添加监听器
    widget.data.addListener(update);
    super.initState();
  }

  @override
  void dispose() {
    // 移除model的监听器
    widget.data.removeListener(update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InheritedProvider<T>(
      data: widget.data,
      child: widget.child,
    );
  }
}

// 这是一个便捷类，会获得当前context和指定数据类型的Provider
class Consumer<T> extends StatelessWidget {
  Consumer({
    Key? key,
    required this.builder,
  }) : super(key: key);

  final Widget Function(BuildContext context, T? value) builder;

  @override
  Widget build(BuildContext context) {
    return builder(
      context,
      ChangeNotifierProvider.of<T>(context),
    );
  }
}

class Item {
  Item(this.price, this.count);

  double price; //商品单价
  int count; // 商品份数
//... 省略其它属性
}

class CartModel extends ChangeNotifier {
  final List<Item> _items = [];

  // 禁止改变购物车里的商品信息
  UnmodifiableListView<Item> get items => UnmodifiableListView(_items);

  double get totalPrice {
    return _items.fold(0, (value, item) {
      return value + item.count * item.price;
    });
  }

  // 将 [item] 添加到购物车。这是唯一一种能从外部改变购物车的方法。
  void add(Item item) {
    _items.add(item);
    // 通知监听器（订阅者），重新构建InheritedProvider， 更新状态。
    notifyListeners();
  }
}

class ProviderRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProviderRouteState();
  }
}

class _ProviderRouteState extends State<ProviderRoute> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ChangeNotifierProvider<CartModel>(
        data: CartModel(),
        child: Builder(builder: (context) {
          return Column(
            children: [
              //优化代码，使消费者的语义更清晰
              Consumer<CartModel>(
                  builder: (context, cart)=> Text("总价: ${cart!.totalPrice}")
              ),
              // Builder(builder: (context) {
              //   var cart = ChangeNotifierProvider.of<CartModel>(context);
              //   return Text("总价：${cart.totalPrice}");
              // }),
              Builder(builder: (context) {
                print("RaisedButton build"); //在后面优化部分会用到
                return RaisedButton(
                  child: Text("添加商品"),
                  onPressed: () {
                    // listen 设为false，不建立依赖关系
                    ChangeNotifierProvider.of<CartModel>(context,listen: false)
                        .add(Item(50, 2));
                  },
                );
              }),
            ],
          );
        }),
      ),
    );
  }
}

/**
 * todo color and theme
 *
 */


/**
 * todo ValueListenableBuilder
 * 数据源发生变化，则会重新执行其 builder
 * const ValueListenableBuilder({
    Key? key,
    required this.valueListenable, // 数据源，类型为ValueListenable<T>
    required this.builder, // builder
    this.child,
    }
 */



