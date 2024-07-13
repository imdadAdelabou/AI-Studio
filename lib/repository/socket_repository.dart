import 'package:docs_ai/clients/socket_client.dart';
import 'package:socket_io_client/socket_io_client.dart';

/// Represent the socket client repository service and conatins functions
/// used to connect
class SocketRespository {
  final Socket _socketClient = SocketClient.getInstance()!.socket!;

  /// Contains the instance of the Socket
  Socket get socketClient => _socketClient;

  /// Allow the socket to join a room
  void joinRoom(String documentId) {
    _socketClient.emit('join', documentId);
  }

  /// Used to send the modification on the current document to the server
  void typing(Map<String, dynamic> data) {
    _socketClient.emit('typing', data);
  }

  /// Used for Auto-saving feature
  void save(Map<String, dynamic> data) {
    _socketClient.emit('save', data);
  }

  /// Used to listen for upcomming changes emit by the server
  void changeListener(Function(Map<String, dynamic>) func) {
    _socketClient.on('changes', (dynamic data) => func(data));
  }
}
