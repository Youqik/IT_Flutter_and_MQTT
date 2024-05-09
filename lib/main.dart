import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

const url = '127.0.0.1';
const port = 1883;
const clientID = 'Client01';
const username = 'Client01';
const password = 'password';

final client = MqttServerClient(url, clientID);

void main() {
  runApp(MyApp());
  connect();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController txf1 = new TextEditingController();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MQTT example"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            TextField(
              controller: txf1,
              decoration: InputDecoration(hintText: 'Input...'),
            ),
            // RaisedButton(
            //   child: Text('Print'),
            //   onPressed: btnEvent,
            // )
          ],
        ),
      ),
    );
  }

  void btnEvent() {
    print(txf1.text);
    const pubTopic = 'testpub';
    final builder = MqttClientPayloadBuilder();
    builder.addString(txf1.text);
    client.publishMessage(pubTopic, MqttQos.atLeastOnce, builder.payload);
  }
}

Future<MqttServerClient> connect() async {
  client.port = port;
  client.setProtocolV311();
  client.logging(on: true);
  await client.connect(username, password);
  if (client.connectionStatus.state == MqttConnectionState.connected) {
    print('client connected');
  } else {
    print(
        'client connection failed - disconnecting, state is ${client.connectionStatus.state}');
    client.disconnect();
  }
  client.subscribe("Test", MqttQos.atLeastOnce);
  client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
    final MqttPublishMessage message = c[0].payload;
    final payload =
        MqttPublishPayload.bytesToStringAsString(message.payload.message);
    print('${c[0].topic}:${payload}');
  });
}
