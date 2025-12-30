import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_tracking/core/socketService/socket_service.dart';
import 'package:live_tracking/features/feature_google-map/presentation/socket_cubit/map_socket_state.dart';

class MapSocketCubit extends Cubit<MapSocketState> {
  final SocketService _socketService;

  MapSocketCubit(this._socketService) : super(MapSocketInitial());

  void listenToLocation() {
    _socketService.socket.on('device:live', (data) {
      if (!isClosed) {
        emit(MapSocketLocationUpdated(data));
      }
    });
  }
}
