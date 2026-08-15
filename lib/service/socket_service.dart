import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketApi {
  static IO.Socket? socket;
  static bool _isInitialized = false;

  static void init(String baseUrl, String userId, {String? token}) {
    if (_isInitialized) {
      debugPrint('⚠️ Socket already initialized');
      if (socket != null && !socket!.connected) {
        socket!.connect();
      }
      return;
    }

    try {
      debugPrint('🟡 Connecting to: $baseUrl with user: $userId');

      socket = IO.io(
        baseUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .setQuery({'id': userId})
            .setAuth({'token': token})
            .disableAutoConnect()
            .enableReconnection()
            .setReconnectionAttempts(999)
            .setReconnectionDelay(1000)
            .setReconnectionDelayMax(5000)
            .build(),
      );

      _setupCoreListeners(userId);
      socket!.connect();

      _isInitialized = true;
    } catch (e) {
      debugPrint("⚠️ Socket init failed: $e");
    }
  }

  static void _setupCoreListeners(String userId) {
    if (socket == null) return;

    socket!.onConnect((_) {
      debugPrint('✅ Socket connected - UserID: $userId');
    });

    socket!.onConnectError((err) {
      debugPrint("❌ Connect Error: $err");
    });

    socket!.on('socket-error', (data) {
      debugPrint("❌ Socket Error Event: $data");
    });
  }

  static void on(String event, Function(dynamic) callback) {
    socket?.on(event, callback);
  }

  static void off(String event) {
    socket?.off(event);
  }

  static void emit(String event, dynamic data) {
    if (socket == null) {
      debugPrint("❌ Cannot emit - socket not initialized");
      return;
    }
    if (!socket!.connected) {
      debugPrint("⚠️ Socket not connected yet. Event [$event] will be buffered.");
    } else {
      debugPrint("📤 Emit [$event]: $data");
    }
    socket!.emit(event, data);
  }

  static bool get isConnected => socket?.connected ?? false;

  static void dispose() {
    socket?.dispose();
    socket = null;
    _isInitialized = false;
  }
}
