import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_tracking/features/feature_chat/data/Repository/chat_repository.dart';
import 'package:live_tracking/features/feature_chat/domain/enities/chat_entity.dart';
import 'package:live_tracking/features/feature_chat/presentation/cubit/chat_list_state.dart';

class ChatListCubit extends Cubit<ChatListState> {
  final ChatRepository repository;
  
  List<ChatEntity> allChats = [];
  
  ChatListCubit(this.repository) : super(ChatListInitial());

  Future<void> fetchChats() async {
    emit(ChatListLoading());
    final result = await repository.getMyChats();
    result.fold(
      (error) => emit(ChatListError(error)),
      (chats) {
        allChats = chats; 
        emit(ChatListSuccess(chats));
      },
    );
  }

  void searchChats(String query) {
    if (query.isEmpty) {
      emit(ChatListSuccess(allChats)); 
    } else {
      final filteredList = allChats.where((chat) {
        return chat.otherUserName.toLowerCase().contains(query.toLowerCase());
      }).toList();
      emit(ChatListSuccess(filteredList));
    }
  }
}