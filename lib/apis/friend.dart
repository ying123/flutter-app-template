import 'package:flutter_app/apis/apiFetch.dart';
import './../request/Fetch.dart';

class FriendApi {
  static Fetch fetch = apiFetch;

  static createFriendshipRequest (data) {
    return fetch.post('/api/services/client/friendship/CreateFriendshipRequest', data: data);
  }
}