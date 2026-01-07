import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_tracking/core/utils/secure_storage.dart';
import 'package:live_tracking/features/feature_chat/data/Repository/chat_repository.dart';
import 'package:live_tracking/features/feature_chat/domain/enities/chat_entity.dart';
import 'package:live_tracking/features/feature_chat/presentation/cubits/chat_list/chat_list_state.dart';
import 'package:live_tracking/features/feature_chat/presentation/cubits/chat_socket/chat_socket_cubit.dart';
import 'dart:async';

class ChatListCubit extends Cubit<ChatListState> {
  final ChatRepository repository;
  final ChatSocketCubit socketCubit;

  Timer? _debounce;

  String? myId;
  List<ChatEntity> allChats = [];

  ChatListCubit(this.repository, this.socketCubit) : super(ChatListInitial()) {
    _loadUserId();
  }

  // load user ID
  Future<void> _loadUserId() async {
    myId = await SecureStorage.readUserId();
  }

  Future<void> fetchChats({bool showLoading = true}) async {
    if (showLoading) emit(ChatListLoading());

    final result = await repository.getMyChats();
    result.fold(
      (error) => emit(ChatListError(error)), 
      (chatsList) {
      allChats = chatsList;
      emit(ChatListSuccess(List.from(allChats)));
    });

    final List<String> chatIds = allChats.map((e) => e.chatId).toList();
    socketCubit.joinAllChats(chatIds);
  }

  // search chats
  // void searchChats(String query) {
  //   final searchTerm = query.toLowerCase().trim();

  //   for (var chat in allChats) {
  //     print("Chat: ${chat.otherUserName} | Email: '${chat.email}'");
  //   }

  //   if (searchTerm.isEmpty) {
  //     emit(ChatListSuccess(allChats));
  //   } else {
  //     final filteredList = allChats.where((chat) {
  //       return chat.email.toLowerCase().contains(searchTerm) || 
  //             chat.otherUserName.toLowerCase().contains(searchTerm);
  //     }).toList();

  //     print("Search query: $searchTerm | Results found: ${filteredList.length}");
  //     emit(ChatListSuccess(filteredList));
  //   }
  // }

  // search remote
  Future<void> searchChatsRemote(String query) async {
    final searchTerm = query.toLowerCase().trim();

    if (searchTerm.isEmpty) {
      emit(ChatListSuccess(List.from(allChats)));
      return;
    }

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      
      // emit(ChatListSearchLoading()); 

      final result = await repository.searchChats(searchTerm);

      result.fold(
        (error) => emit(ChatListError(error)),
        (searchResults) {
          emit(ChatListSuccess(searchResults));
        },
      );
    });
  }

  // update form last message event
  void updateFromLastMessageEvent(Map<String, dynamic> data) {
    print("🛠️ Attempting to update list with: $data");

    if (state is ChatListSuccess) {
      final String incomingChatId = data['chatId']?.toString() ?? "";
      final lastMsg = data['lastMessage'];

      if (incomingChatId.isEmpty || lastMsg == null) {
        print("⚠️ Missing data in socket payload");
        return;
      }

      final index = allChats.indexWhere((c) => c.chatId.toString() == incomingChatId);

      if (index != -1) {
        print("🎯 Match found at index $index. Updating...");
        
        final updatedChat = allChats[index].copyWith(
          lastMessage: lastMsg['text'] ?? "Media content",
          lastMessageSenderId: lastMsg['senderId']?.toString(),
          createdAt: lastMsg['createdAt'] != null 
              ? DateTime.parse(lastMsg['createdAt']) 
              : DateTime.now(),
          hasUnreadMessages: true,
        );

        allChats.removeAt(index);
        allChats.insert(0, updatedChat);

        emit(ChatListSuccess(List.from(allChats)));
        print("✅ UI Updated for chatId: $incomingChatId");
      } else {
        print("❓ ChatId $incomingChatId not in list. Fetching from server...");
        fetchChats(showLoading: false);
      }
    }
  }
}
