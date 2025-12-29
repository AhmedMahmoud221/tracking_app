import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_tracking/features/feature_chat/data/Repository/chat_repository.dart';
import 'package:live_tracking/features/feature_chat/presentation/cubit/chat_cubit_state.dart';

class ChatListCubit extends Cubit<ChatListState> {
  final ChatRepository repository;
  ChatListCubit(this.repository) : super(ChatListInitial());

  Future<void> fetchChats() async {
    emit(ChatListLoading());

    final result = await repository.getMyChats();
    
    result.fold(
      (error) => emit(ChatListError(error)),
      (chats) => emit(ChatListSuccess(chats)),
    );
  }
}