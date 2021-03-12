import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Conecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Conecting;
  IO.Socket _socket;
  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket => this._socket;
  Function get emit => this._socket.emit;
  SocketService() {
    this._initConfig();
  }
  void _initConfig() {
    this._socket = IO.io('https://flutter-bandnameapp.herokuapp.com/', {
      'transports': ['websocket'],
      'autoConnect': true,
    });
    this._socket.on('connect', (_) {
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });
    this._socket.on('disconnect', (_) {
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
    this._socket.connect();
    // this._socket.on('nuevo-mensaje', (payload) {
    //   print('Nuevo mensaje: $payload');
    //   print('Nombre: ' + payload['nombre']);
    //   print('Mensaje: ' + payload['mensaje']);
    //   print(payload.constrainsKey('mensaje2') ? payload['mensaje2'] : 'No hay');
    //   //this._serverStatus = ServerStatus.Offline;
    //   //notifyListeners();
    // });
  }
}
