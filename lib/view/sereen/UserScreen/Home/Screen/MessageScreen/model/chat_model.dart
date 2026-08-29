class ChatModel {
  String? id;
  String? chatName;
  bool? isGroupChat;
  List<ChatUser>? users;
  LatestMessage? latestMessage;
  String? groupAdmin;
  String? createdAt;

  ChatModel({
    this.id,
    this.chatName,
    this.isGroupChat,
    this.users,
    this.latestMessage,
    this.groupAdmin,
    this.createdAt,
  });

  ChatModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    chatName = json['chatName'];
    isGroupChat = json['isGroupChat'];
    if (json['users'] != null) {
      users = <ChatUser>[];
      json['users'].forEach((v) {
        users!.add(ChatUser.fromJson(v));
      });
    }
    latestMessage = json['latestMessage'] != null
        ? LatestMessage.fromJson(json['latestMessage'])
        : null;
    groupAdmin = json['groupAdmin'] is String 
        ? json['groupAdmin'] 
        : json['groupAdmin']?['_id'];
    createdAt = json['createdAt'];
  }
}

class ChatUser {
  String? id;
  String? name;
  String? userName;
  String? profileImage;
  String? role;
  String? status;
  bool? isOnline;

  ChatUser({this.id, this.name, this.userName, this.profileImage, this.role, this.status, this.isOnline});

  ChatUser.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    userName = json['userName'];
    profileImage = json['profileImage'];
    role = json['role'];
    status = json['status'];
    isOnline = json['isOnline'];
  }
}

class LatestMessage {
  String? id;
  String? content;
  String? imageUrl;
  String? videoUrl;
  String? audioUrl;
  String? sender;
  String? senderName;
  String? createdAt;

  LatestMessage({this.id, this.content, this.imageUrl, this.videoUrl, this.audioUrl, this.sender, this.senderName, this.createdAt});

  LatestMessage.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    content = json['content'];
    imageUrl = json['imageUrl'];
    videoUrl = json['videoUrl'];
    audioUrl = json['audioUrl'];
    sender = json['sender'] is String ? json['sender'] : json['sender']?['_id'];
    senderName = json['sender'] is Map ? json['sender']['name'] : null;
    createdAt = json['createdAt'];
  }
}
