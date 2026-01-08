abstract class MapSocketState {}

class MapSocketInitial extends MapSocketState {}

class MapSocketConnecting extends MapSocketState {}

class MapSocketConnected extends MapSocketState {}

class MapSocketDisconnected extends MapSocketState {}

class MapSocketLocationUpdated extends MapSocketState {
  final dynamic data;
  MapSocketLocationUpdated(this.data);
}

class MapSocketError extends MapSocketState {
  final String message;
  MapSocketError(this.message);
}
