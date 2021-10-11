import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class SingleChildScrollViewRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class SingleChildScrollViewTestRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String str = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    return Scrollbar(
      // 显示进度条
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            //动态创建一个List<Widget>
            children: str
                .split("")
            //每一个字母都用一个Text显示,字体为原来的两倍
                .map((c) =>
                Text(
                  c,
                  textScaleFactor: 2.0,
                ))
                .toList(),
          ),
        ),
      ),
    );
  }
}

class ListViewDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget divider1 = Divider(color: Colors.black);
    Widget divider2 = Divider(color: Colors.blue);
    return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return ListTile(title: Text("$index"));
        },
        separatorBuilder: (BuildContext context, int index) {
          return index % 2 == 0 ? divider1 : divider2;
        },
        itemCount: 100);
  }
}

class ListViewDemo2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget divider1 = Divider(color: Colors.black);
    Widget divider2 = Divider(color: Colors.blue);
    return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return ListTile(title: Text("$index"));
        },
        separatorBuilder: (BuildContext context, int index) {
          return index % 2 == 0 ? divider1 : divider2;
        },
        itemCount: 10);
  }
}

class FixedExtentList extends StatelessWidget {
  FixedExtentList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      prototypeItem: ListTile(title: Text("1")),
      itemBuilder: (context, index) {
        return ListTile(title: Text("$index"));
      },
    );
  }
}

class HeaderListView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

class _HeaderListView extends State<HeaderListView> {
  @override
  Widget build(BuildContext context) {
    // return Column(
    //   children: <Widget>[
    //     ListTile(title: Text("商品列表")),
    //     SizedBox(
    //       height: 400,
    //       child:
    //           ListView.builder(itemBuilder: (BuildContext context, int index) {
    //         return ListTile(title: Text("$index"));
    //       }),
    //     ),
    //   ],
    // );

    //方式二，优雅些
    return Column(
      children: <Widget>[
        ListTile(title: Text("商品列表")),
        Expanded(
          child:
          ListView.builder(itemBuilder: (BuildContext context, int index) {
            return ListTile(title: Text("$index"));
          }),
        ),
      ],
    );
  }
}

class InfiniteListView extends StatefulWidget {
  @override
  _InfiniteListViewState createState() => _InfiniteListViewState();
}

class _InfiniteListViewState extends State<InfiniteListView> {
  static const loadingTag = "##loading##"; //表尾标记
  var _words = <String>[loadingTag];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: _words.length,
      itemBuilder: (context, index) {
        //如果到了表尾
        if (_words[index] == loadingTag) {
          //不足100条，继续获取数据
          if (_words.length - 1 < 100) {
            //获取数据
            _retrieveData();
            //加载时显示loading
            return Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.center,
              child: SizedBox(
                width: 24.0,
                height: 24.0,
                child: CircularProgressIndicator(strokeWidth: 2.0),
              ),
            );
          } else {
            //已经加载了100条数据，不再获取数据。
            return Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(16.0),
              child: Text(
                "没有更多了",
                style: TextStyle(color: Colors.grey),
              ),
            );
          }
        }
        //显示单词列表项
        return ListTile(title: Text(_words[index]));
      },
      separatorBuilder: (context, index) =>
          Divider(
            height: .0,
          ),
    );
  }

  void _retrieveData() {
    Future.delayed(Duration(seconds: 2)).then((e) {
      setState(() {
        //重新构建列表
        _words.insertAll(
          _words.length - 1,
          //每次生成20个单词
          generateWordPairs().take(20).map((e) => e.asPascalCase).toList(),
        );
      });
    });
  }
}

//滚动监听
class ScrollControllerTestRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ScrollControllerTestRouteState();
  }
}

class ScrollControllerTestRouteState extends State<ScrollControllerTestRoute> {
  ScrollController _controller = ScrollController();
  bool showToTopBtn = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.addListener(() {
      print(_controller.offset);
      if (_controller.offset < 1000 && showToTopBtn) {
        setState(() {
          showToTopBtn = false;
        });
      } else if (_controller.offset >= 1000 && showToTopBtn == false) {
        setState(() {
          showToTopBtn = true;
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("滚动控制"),
      ),
      body: Scrollbar(
        child: ListView.builder(itemBuilder: (context, index) {
          return ListTile(
            title: Text("$index"),
          );
        }),
      ),
      floatingActionButton: !showToTopBtn
          ? null
          : FloatingActionButton(onPressed: () {
        _controller.animateTo(.0,
            duration: Duration(microseconds: 200), curve: Curves.ease);
      }),
    );
  }
}

/**
 * todo
 * 滚动监听及控制
 */
class ScrollNotificationTestRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ScrollNotificationTestRouteState();
  }
}

class _ScrollNotificationTestRouteState
    extends State<ScrollNotificationTestRoute> {
  String _progress = "0%"; //保存进度百分比

  @override
  Widget build(BuildContext context) {
    Scrollbar scrollbar1 = Scrollbar(
      //进度条
      // 监听滚动通知
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          double progress = notification.metrics.pixels /
              notification.metrics.maxScrollExtent;
          //重新构建
          setState(() {
            _progress = "${(progress * 100).toInt()}%";
          });
          print("BottomEdge: ${notification.metrics.extentAfter == 0}");
          return false;
          //return true; //放开此行注释后，进度条将失效
        },
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            ListView.builder(
              itemCount: 100,
              itemExtent: 50.0,
              itemBuilder: (context, index) => ListTile(title: Text("$index")),
            ),
            CircleAvatar(
              //显示进度百分比
              radius: 30.0,
              child: Text(_progress),
              backgroundColor: Colors.black54,
            )
          ],
        ),
      ),
    );

    /**
     * pixels：当前滚动位置。
        maxScrollExtent：最大可滚动长度。
        extentBefore：滑出ViewPort顶部的长度；此示例中相当于顶部滑出屏幕上方的列表长度。
        extentInside：ViewPort内部长度；此示例中屏幕显示的列表部分的长度。
        extentAfter：列表中未滑入ViewPort部分的长度；此示例中列表底部未显示到屏幕范围部分的长度。
        atEdge：是否滑到了可滚动组件的边界（此示例中相当于列表顶或底部）。
     */
    return Scrollbar(
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification notification) {
            double progress =
                notification.metrics.pixels /
                    notification.metrics.maxScrollExtent;
            //重新构建
            setState(() {
              _progress = "${(progress * 100).toInt()}%";
            });
            print("BottomEdge: ${notification.metrics.extentAfter == 0}");
            return false;
          },
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              ListView.builder(
                itemCount: 100,
                itemExtent: 50.0,
                itemBuilder: (context, index) {
                  return ListTile(title: Text("$index"));
                },
              ),
              CircleAvatar(
                radius: 30.0,
                child: Text(_progress),
                backgroundColor: Colors.black54,
              )
            ],
          ),
        ));
  }
}

/**
 * todo
 * AnimatedList
 * 与ListView大体相似，不同的是， AnimatedList 可以在列表中插入或删除节点时执
 */

class AnimatedListRoute extends StatefulWidget {
  const AnimatedListRoute({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

class _AnimatedListRouteState extends State<AnimatedListRoute> {
  var data = <String>[];
  int counter = 5;
  final globalKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    for (var i = 0; i < counter; i++) {
      data.add('${i + 1}');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: [
        AnimatedList(
            key: globalKey,
            initialItemCount: data.length,
            itemBuilder:
                (BuildContext context, int index, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: buildItem(context, index),
              );
            }),
        buildAddBtn(),
      ],
    );
  }

  // 创建一个 “+” 按钮，点击后会向列表中插入一项
  Widget buildAddBtn() {
    return Positioned(
      child: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // 添加一个列表项
          data.add('${++counter}');
          // 告诉列表项有新添加的列表项
          globalKey.currentState!.insertItem(data.length - 1);
          print('添加 $counter');
        },
      ),
      bottom: 30,
      left: 0,
      right: 0,
    );
  }

  // 构建列表项
  Widget buildItem(context, index) {
    String char = data[index];
    return ListTile(
      //数字不会重复，所以作为Key
      key: ValueKey(char),
      title: Text(char),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        // 点击时删除
        onPressed: () => onDelete(context, index),
      ),
    );
  }

  void onDelete(context, index) {
    // 待实现
  }
}

/**
 *  todo
 *  GridView
 */

class GridViewDemo {
  GridView gridView = GridView(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, childAspectRatio: 1.0),
    children: <Widget>[
      Icon(Icons.ac_unit),
      Icon(Icons.airport_shuttle),
      Icon(Icons.all_inclusive),
      Icon(Icons.beach_access),
      Icon(Icons.cake),
      Icon(Icons.free_breakfast)
    ],
  );

  GridView gridView2 = GridView(
    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 120, childAspectRatio: 2.0),
    children: <Widget>[
      Icon(Icons.ac_unit),
      Icon(Icons.airport_shuttle),
      Icon(Icons.all_inclusive),
      Icon(Icons.beach_access),
      Icon(Icons.cake),
      Icon(Icons.free_breakfast),
    ],
  );

  void init() {
    /**
     * GridView.count构造函数内部使用了
     * SliverGridDelegateWithFixedCrossAxisCount
     */
    gridView = GridView.count(
      crossAxisCount: 3,
      childAspectRatio: 1.0,
      children: <Widget>[
        Icon(Icons.ac_unit),
        Icon(Icons.airport_shuttle),
        Icon(Icons.all_inclusive),
        Icon(Icons.beach_access),
        Icon(Icons.cake),
        Icon(Icons.free_breakfast),
      ],
    );

    gridView2 = GridView.extent(
      maxCrossAxisExtent: 120.0,
      childAspectRatio: 2.0,
      children: <Widget>[
        Icon(Icons.ac_unit),
        Icon(Icons.airport_shuttle),
        Icon(Icons.all_inclusive),
        Icon(Icons.beach_access),
        Icon(Icons.cake),
        Icon(Icons.free_breakfast),
      ],
    );
  }
}


/**
 * 模拟我们需要从一个异步数据源（如网络）分批获取一些Icon，然后用GridView来展示：
 */
class InfiniteGridView extends StatefulWidget {
  @override
  _InfiniteGridViewState createState() => _InfiniteGridViewState();
}

class _InfiniteGridViewState extends State<InfiniteGridView> {

  List<IconData> _icons = []; //保存Icon数据

  @override
  void initState() {
    super.initState();
    // 初始化数据
    _retrieveIcons();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.0,
        ),
        itemBuilder: (context, index) {
          if (index == _icons.length - 1 && _icons.length < 200) {
            _retrieveIcons();
          }
          return Icon(_icons[index]);
        }
    );
  }

  //模拟异步获取数据
  void _retrieveIcons() {
    Future.delayed(Duration(milliseconds: 200)).then((e) {
      setState(() {
        _icons.addAll([
          Icons.ac_unit,
          Icons.airport_shuttle,
          Icons.all_inclusive,
          Icons.beach_access,
          Icons.cake,
          Icons.free_breakfast,
        ]);
      });
    });
  }
}

/**
 * todo
 * PageView与页面共存
 * PageView({
    Key? key,
    this.scrollDirection = Axis.horizontal, // 滑动方向
    this.reverse = false,
    PageController? controller,
    this.physics,
    List<Widget> children = const <Widget>[],
    this.onPageChanged,

    //每次滑动是否强制切换整个页面，如果为false，则会根据实际的滑动距离显示页面
    this.pageSnapping = true,
    //主要是配合辅助功能用的，后面解释
    this.allowImplicitScrolling = false,
    //后面解释
    this.padEnds = true,
    })
 */

class Page extends StatefulWidget{

  const Page({
    Key? key,
    required this.text
  }) : super(key: key);

  final String text;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PageState();
  }

}

class _PageState extends State<Page>{
  @override
  Widget build(BuildContext context) {
    print("build ${widget.text}");
    return Center(child: Text("${widget.text}", textScaleFactor: 5));
  }

}

class ViewPageDemo extends StatelessWidget{

  var children = <Widget>[];

  @override
  Widget build(BuildContext context) {

    // 生成 6 个 Tab 页
    for (int i = 0; i < 6; ++i) {
      children.add( Page( text: '$i'));
    }
    return PageView(
      children: children,
    );
  }

}

/**
 * todo
 * 页面缓存
 */





