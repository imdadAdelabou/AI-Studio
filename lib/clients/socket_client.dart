import 'package:docs_ai/utils/constant.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

/// Represent a client that listen to the server via the socket
class SocketClient {
  SocketClient._internal() {
    socket = io.io(apiHostWs, <String, dynamic>{
      'transports': <String>['websocket'],
      'autoConnect': false,
    });
    socket!.connect();
  }

  /// Verify if current instance is null then return the current instance
  /// Otherwise execute the _internal constructor
  static SocketClient? getInstance() {
    _instance ??= SocketClient._internal();

    return _instance;
  }

  /// Represent the connected instance
  static SocketClient? get instance => _instance;

  /// An instance of socket that can be nullable
  io.Socket? socket;
  static SocketClient? _instance;
}
