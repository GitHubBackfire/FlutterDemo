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
                .map((c) => Text(
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
      separatorBuilder: (context, index) => Divider(
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
