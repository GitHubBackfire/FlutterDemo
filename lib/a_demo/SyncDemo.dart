import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DemoRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

class _DemoRouteState extends State<DemoRoute> {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Center(
        child: RaisedButton(
          child: Text('Click me'),
          onPressed: () {
            final myFuture = http.get('https://example.com');
            myFuture.then((response) {
              if (response.statusCode == 200) {
                print('Success!');
              }
            });
          },
        ),
      ),
    );
  }
}
