library json_rpc_demo.web_client;

import 'dart:html';

import 'package:json_rpc_2/json_rpc_2.dart' as json_rpc;
import 'package:web_socket_channel/html.dart';

var client;


main() async {
  Uri serverURL = Uri.parse('ws://localhost:4321');
  var socket = new HtmlWebSocketChannel.connect(serverURL);
  client = new json_rpc.Client(socket)
    ..listen();

  querySelector('#get-square').onClick.listen((e) async {
    // Make sure that the user entered a number. If not, show an appropriate message.
    int number;
    try {
      number = int.parse((querySelector('#input-number') as InputElement).value);
    } catch (e) {
      outputAnswer('The input is not a number. Try again.');
      return;
    }
    outputAnswer(await getSquare(number));
  });
}

getSquare(int number) async {
  Map json = await client.sendRequest('get', [number]);
  return json['result'];
}

void outputAnswer(result) {
  querySelector('#result').text = result.toString();
}
