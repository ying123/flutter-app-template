class GetUserChatMessagesInput {
  int tenantId;
  int userId;
  int minMessageId;
  GetUserChatMessagesInput({this.tenantId, this.userId, this.minMessageId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tenantId'] = this.tenantId;
    data['userId'] = this.userId;
    data['minMessageId'] = this.minMessageId;
    return data;
  }
}