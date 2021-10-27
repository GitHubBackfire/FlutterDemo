import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(const MyApp());
}

/**
 * demo 无状态demo
 */
class DEMOWidget extends StatelessWidget {
  final String text;

  DEMOWidget(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      //? 表示如果text为空，就返回尾号后的内容。
      child: Text(text?? "无状态DEMO"),
    );
  }
}

/**
 * demo 有状态demo
 *
 */
class DemoStateWidget extends StatefulWidget {
  final String text;

  ////通过构造方法传值
  DemoStateWidget(this.text);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

class _DemoStateWidgetState extends State<DemoStateWidget> {
  String text;

  _DemoStateWidgetState(this.text);

  ///主要是负责创建state
  @override
  void initState() {
    // TODO 初始化，这个函数在生命周期中只调用一次
    super.initState();
    new Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        text = "这就变了数值";
      });
    });
  }

  @override
  void dispose() {
    ///销毁
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    //在initState之后调 Called when a dependency of this [State] object changes.
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    Container cardContainer = new Container(
      child: new Card(
        child: new FlatButton(
          onPressed: () {
            print("点击了哦");
          },
          child: new Padding(
            padding: new EdgeInsets.only(
                left: 0.0, top: 10.0, right: 10.0, bottom: 10.0),
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Container(
                  child: new Text(
                    "这是描述",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 14.0,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  margin: new EdgeInsets.only(top: 6.0, bottom: 2.0),
                  alignment: Alignment.topLeft,
                ),
                new Padding(padding: EdgeInsets.all(10.0)),
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _getBottomItem(Icons.star, "11"),
                    _getBottomItem(Icons.star, "22"),
                    _getBottomItem(Icons.star, "33"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Container container = new Container(

        ///四周10大小的maring
        margin: EdgeInsets.all(10.0),
        height: 120.0,
        width: 500.0,

        ///透明黑色遮罩
        decoration: new BoxDecoration(

            ///弧度为4.0
            borderRadius: BorderRadius.all(Radius.circular(4.0)),

            ///设置了decoration的color，就不能设置Container的color。
            color: Colors.black,

            ///边框
            border: new Border.all(width: 0.3)),
        child: new Text("有状态的DEMO"));

    return container;
  }

  _getBottomItem(IconData icon, String text) {
    return new Expanded(
        flex: 1,
        child: new Center(
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Icon(
                icon,
                size: 16.0,
                color: Colors.grey,
              ),
              new Padding(padding: new EdgeInsets.only(left: 5.0)),
              new Text(
                text,
                style: new TextStyle(color: Colors.grey, fontSize: 14.0),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
     return null;
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
