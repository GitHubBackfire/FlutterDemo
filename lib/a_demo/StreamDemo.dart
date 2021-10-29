/**
 * 有一个事件源叫 Stream，为了方便控制 Stream ，官方提供了使用 StreamController 作为管理；
 * 同时它对外提供了 StreamSink 对象作为事件输入口，可通过 sink 属性访问;
 * 又提供 stream 属性提供 Stream 对象的监听和变换，
 * 最后得到的 StreamSubscription 可以管理事件的订阅。
 */
import 'dart:async';

class DataBloc{
  ///定义一个Controller
  StreamController<List<String>> _dataController = StreamController();
  ///获取 StreamSink 做 add 入口
  StreamSink<List<String>> get _dataSink => _dataController.sink;
  //获取 Stream 用于监听
  Stream<List<String>> get _dataStream => _dataController.stream;
  StreamSubscription? _dataSubscription;
  
  init(){
    _dataSubscription = _dataStream.listen((event) {
      ///每次数据发生变化，此方法会执行
    });
    ///改变事件
    _dataSink.add(["first", "second", "three", "more"]);
  }

  close() {
    ///关闭
    _dataSubscription?.cancel();
    _dataController.close();
  }



}