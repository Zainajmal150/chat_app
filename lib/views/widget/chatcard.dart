import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/helper/mydateutil.dart';
import 'package:chat_app/models/chatusermodel.dart';
import 'package:chat_app/models/messagesmodel.dart';
import 'package:chat_app/utils/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../mainpage/chat_screen.dart';

class ChatCard extends StatefulWidget {
  final ChatUser user;
  const ChatCard({super.key, required this.user});

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  Message? _message;

  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
    return Card(
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * .04, vertical: 4),
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ChatScreen(
                          user: widget.user,
                        )));
          },
          child: StreamBuilder(
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;

              final lst =
                  data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
              if (lst.isNotEmpty) {
                _message = lst[0];
              }
              return ListTile(
                // user profile image
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * .2),
                  child: CachedNetworkImage(
                    width: mq.height * .055,
                    height: mq.height * .055,
                    imageUrl: widget.user.image,
                    errorWidget: (context, url, error) {
                      return const CircleAvatar(
                        child: Icon(
                          CupertinoIcons.person,
                        ),
                      );
                    },
                  ),
                ),

                // user name
                title: Text(widget.user.name),
                // user last meesage
                subtitle: Text(
                  _message != null ? _message!.msg : widget.user.about,
                  maxLines: 1,
                ),
                //  last message time
                trailing: _message == null
                    ? null
                    : _message!.read.isEmpty &&
                            _message!.formid != Apis.user.uid
                        ? Container(
                            height: 12,
                            width: 12,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green.shade400),
                          )
                        : Text(
                            MyDateUtils.getLastMessageTime(
                                context: context, time: _message! .sent),
                            style: TextStyle(color: Colors.black),
                          ),
              );
            },
            stream: Apis.getLastMessage(widget.user),
          )),
    );
  }
}
