library json_rpc_demo.cmdline_client;

import 'dart:io' as io;

import 'package:json_rpc_2/json_rpc_2.dart' as json_rpc;
import 'package:web_socket_channel/io.dart';

var client;

// Server that squares a number and returns it through RPC.
main() async {
  Uri serverURL = Uri.parse('ws://localhost:4321');
  var socket = new IOWebSocketChannel.connect(serverURL);
  client = new json_rpc.Client(socket)
    ..listen();


  io.stdout.writeln('Type a number to be squared. When you\'re done, type \'exit\'.');
  while (true) {
    // Check for the 'exit' command.
     String input = io.stdin.readLineSync();
    if (input == 'exit') {
      io.stdout.writeln('Bye!');
      client.close();
      return;
    }

    // Make sure that the user entered a number. If not, show an appropriate message.
    int number;
    try {
      number = int.parse(input);
    } catch (e) {
      io.stdout.writeln('The input is not a number. Try again.');
    }
    // Send command to the server to compute the square and display the result.
    io.stdout.writeln(await getSquare(number));
  }
}

getSquare(int number) async {
  Map json = await client.sendRequest('get', [number]);
  return json['result'];
}
