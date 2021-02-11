 import 'package:flutter/material.dart';
 import 'package:web_socket_channel/web_socket_channel.dart';
 import 'package:web_socket_channel/io.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  WebSocketChannel channel;
  TextEditingController controller;
  final List<String> list = [];

  @override
  void initState() {
    super.initState();
    channel = IOWebSocketChannel.connect('wss://echo.websocket.org/');
    controller = TextEditingController();
    channel.stream.listen((data) {
      setState(() {
        list.add(data);
      });
    });
  }

  void sendData() {
    if (controller.text.isNotEmpty) {
      channel.sink.add(controller.text);
      controller.text = "";
    }
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebSocket Example'),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Form(
                child: TextFormField(
                  controller: controller, 
                  decoration: InputDecoration(
                    labelText: "Send to WebSocket",
              ),
            )),
            Column(
              children: list.map((d) => Text(d)).toList(),
            )
            // StreamBuilder(
            //     stream: channel.stream,
            //     builder: (BuildContext context, AsyncSnapshot snapshot) {
            //       return Container(
            //         child: Text(snapshot.hasData ? '${snapshot.data}' : ''),
            //       );
            //     }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.send),
        onPressed: () {
          sendData();
        },
      ),
    );
  }
}
