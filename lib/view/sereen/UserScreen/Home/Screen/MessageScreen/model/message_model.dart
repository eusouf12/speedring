import 'chat_model.dart';

class MessageModel {
  String? id;
  ChatUser? sender;
  String? chat;
  String? content;
  String? imageUrl;
  String? videoUrl;
  String? audioUrl;
  String? createdAt;

  MessageModel({
    this.id,
    this.sender,
    this.chat,
    this.content,
    this.imageUrl,
    this.videoUrl,
    this.audioUrl,
    this.createdAt,
  });

  MessageModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    sender = json['sender'] != null
        ? (json['sender'] is String 
            ? ChatUser(id: json['sender']) 
            : ChatUser.fromJson(json['sender']))
        : null;
    chat = json['chat'] is String ? json['chat'] : json['chat']?['_id'];
    content = json['content'];
    imageUrl = json['imageUrl'];
    videoUrl = json['videoUrl'];
    audioUrl = json['audioUrl'];
    createdAt = json['createdAt'];
  }
}
