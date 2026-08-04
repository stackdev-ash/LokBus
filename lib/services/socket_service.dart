// lib/services/socket_service.dart
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

/// Simple wrapper around socket_io_client
class SocketService {
  io.Socket? socket;

  void connect({required String url}) {
    socket = io.io(url, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'reconnection': true, // 👈 auto-reconnect
      'reconnectionDelay': 2000, // 👈 wait before reconnect
    });

    socket!.onConnect((_) {
      if (kDebugMode) debugPrint('✅ Socket connected');
    });

    socket!.onDisconnect((_) {
      if (kDebugMode) debugPrint('⚠️ Socket disconnected');
    });

    socket!.onError((e) {
      if (kDebugMode) debugPrint('❌ Socket error: $e');
    });

    socket!.onReconnect((_) {
      if (kDebugMode) debugPrint('🔄 Socket reconnected');
    });
  }

  void emit(String event, dynamic data) {
    if (socket != null && socket!.connected) {
      socket!.emit(event, data);
      if (kDebugMode) debugPrint("📤 Emitted $event with $data");
    } else {
      if (kDebugMode) {
        debugPrint("⚠️ Tried to emit $event but socket not connected");
      }
    }
  }

  void on(String event, void Function(dynamic) cb) {
    socket?.on(event, cb);
    if (kDebugMode) debugPrint("👂 Listening to $event");
  }

  void disconnect() {
    socket?.disconnect();
    if (kDebugMode) debugPrint("🔌 Socket disconnected manually");
  }
}
