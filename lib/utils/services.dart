import 'dart:developer';
import 'dart:io';

import 'package:chat_app/models/chatusermodel.dart';
import 'package:chat_app/models/messagesmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Apis {
// for accessign firestore database

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // for authentication

  static FirebaseAuth auth = FirebaseAuth.instance;
  // for accessing firebase storage
  static FirebaseStorage storage = FirebaseStorage.instance;

  // self info get

  static late ChatUser me;
  static User get user => auth.currentUser!;

  // for checking if user exists or not?
  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

// selfinfo
  static Future<void> selfInfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
      } else {
        await createUser().then((value) {
          selfInfo();
        });
      }
    });
  }

// for create new user

  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    // ignore: unused_local_variable
    final chatUser = ChatUser(
        image: user.photoURL.toString(),
        about: "Hey, I'm using ChatHut",
        name: user.displayName.toString(),
        isOnline: false,
        lastActive: time,
        id: user.uid,
        createAt: time,
        email: user.email.toString(),
        pushToken: '');

    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  // updationmyinfo

  static Future<void> updateUserInfo() async {
    await firestore
        .collection('users')
        .doc(user.uid)
        .update({'name': me.name, 'about': me.about});
  }

  // update profile picture of user
  static Future<void> updateProfilePicture(File file) async {
    //getting image file extension
    final ext = file.path.split('.').last;
    log('Extension: $ext');

    //storage file ref with path
    final ref = storage.ref().child('profile_pictures/${user.uid}.$ext');

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    //updating image in firestore database
    me.image = await ref.getDownloadURL();
    await firestore
        .collection('users')
        .doc(user.uid)
        .update({'image': me.image});
  }

  /// ****** for messages realted apis **********///
  /// ****** for messages realted apis **********///
  /// ****** for messages realted apis **********///

  static Future<void> sendMessage(ChatUser chatUser, String msg) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final Message message = Message(
        msg: msg,
        formid: user.uid,
        toid: chatUser.id,
        read: '',
        type: Type.text,
        sent: time);

    final ref = firestore
        .collection('chats/${getConversationID(chatUser.id)}/messages/');
    await ref.doc(time).set(message.toJson());
  }

  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  // for getting all messages of a specific conversation from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  // read message blue tick update status

  static Future<void> updateMessageReadStatus(Message message) async {
    firestore
        .collection('chats/${getConversationID(message.formid)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  // get last message form specific user

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      ChatUser user)  {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
     .orderBy('sent',descending: true)
        .limit(1)
        .snapshots();
  }
}
