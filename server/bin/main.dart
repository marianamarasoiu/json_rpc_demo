library json_rpc_demo.server;

import 'dart:io' as io;

import 'package:json_rpc_2/json_rpc_2.dart' as json_rpc;
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';

var server;

// Server that squares a number and returns it through RPC.
main() async {
  shelf_io.serve(webSocketHandler((webSocketChannel) {
    server = new json_rpc.Server(webSocketChannel)
      ..registerMethod('get', (json_rpc.Parameters params) async {
        try {
          var numberToSquare = params[0].asInt;
          return {'result': numberToSquare * numberToSquare};
        } catch (e) {
          return 'Error computing the square. Try again.';
        }
      })
      ..listen();
  }), io.InternetAddress.LOOPBACK_IP_V4, 4321 );
}
