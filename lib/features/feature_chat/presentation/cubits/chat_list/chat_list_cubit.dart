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

  //===============================================================================
  // load user ID
  Future<void> _loadUserId() async {
    myId = await SecureStorage.readUserId();
  }

  //===============================================================================
  // fetch chats
  Future<void> fetchChats({bool showLoading = true}) async {
    if (showLoading) emit(ChatListLoading());

    final result = await repository.getMyChats();
    result.fold(
      (error) => emit(ChatListError(error)), 
      (chatsList) {
      allChats = chatsList.cast<ChatEntity>().toList();
      emit(ChatListSuccess(List.from(allChats)));
    });

    final List<String> chatIds = allChats.map((e) => e.chatId).toList();
    socketCubit.joinAllChats(chatIds);
  }

  //===============================================================================
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

  //===============================================================================
  // update form last message event
  void updateFromLastMessageEvent(Map<String, dynamic> data) {
  final String incomingChatId = data['chatId']?.toString() ?? "";
  final lastMsg = data['lastMessage'];
  if (incomingChatId.isEmpty || lastMsg == null) return;

  // استخراج الـ senderId بشكل صحيح (سواء كان String أو Map)
  final senderData = lastMsg['senderId'];
  final String senderId = (senderData is Map) 
      ? senderData['_id'].toString() 
      : senderData.toString();

  final index = allChats.indexWhere((c) => c.chatId.toString() == incomingChatId);

  if (index != -1) {
    // تأكد أنك لا تنور الإشعار لنفسك
    bool isMe = senderId == myId;

    final updatedChat = allChats[index].copyWith(
      lastMessage: lastMsg['text'] ?? "Media content",
      lastMessageSenderId: senderId,
      createdAt: lastMsg['createdAt'] != null 
          ? DateTime.parse(lastMsg['createdAt']) 
          : DateTime.now(),
      hasUnreadMessages: !isMe, // هنا تنور الدايرة الزرقاء
    );

    final List<ChatEntity> updatedList = List<ChatEntity>.from(allChats);
    updatedList.removeAt(index);
    updatedList.insert(0, updatedChat);

    allChats = updatedList;

    emit(ChatListSuccess(allChats));
    print("🔔 Notification Status: ${!isMe} for chat: $incomingChatId");
  } else {
    fetchChats(showLoading: false);
    // لو الشات مش موجود، هاته من السيرفر وحوله لـ Entity فوراً
    _fetchAndMarkAsUnread(incomingChatId);
  }
}




Future<void> _fetchAndMarkAsUnread(String chatId) async {
  final result = await repository.getMyChats();
  result.fold(
    (error) => emit(ChatListError(error)),
    (chatsList) {
      // تحويل القائمة لـ Entity عشان تقبل الـ copyWith
      allChats = chatsList.cast<ChatEntity>().toList();
      
      int index = allChats.indexWhere((c) => c.chatId == chatId);
      if (index != -1) {
        allChats[index] = allChats[index].copyWith(hasUnreadMessages: true);
      }
      
      emit(ChatListSuccess(List.from(allChats)));
    },
  );
}
}
