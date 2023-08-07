import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/models/messagesmodel.dart';
import 'package:chat_app/views/widget/message_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/chatusermodel.dart';
import '../../utils/services.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;

  const ChatScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
    List<Message> list = [];
    TextEditingController _msgControoler = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        flexibleSpace: _appBar(),
      ),
      body: Column(children: [
        Expanded(
            child: StreamBuilder(
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.none:
              return const Center(
                child: SizedBox(),
              );
              case ConnectionState.active:
              case ConnectionState.done:
                final data = snapshot.data?.docs;
                list =  data?.map((e) 
                 =>   Message.fromJson(e.data())).toList() ?? [];
                //
              
                if (list.isNotEmpty) {
                  return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return MessageCard(message: list[index]);
                    },
                  );
                } else {
                  return const Center(
                    child: Text(
                      "Say Hii! 👋",
                      style: TextStyle(fontSize: 20),
                    ),
                  );
                }
            }
          },
          stream: Apis.getAllMessages(widget.user),
        )),
        _chatInput()
      ]),
    );
  }

// app bar
  Widget _appBar() {
    Size mq = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(children: [
        IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black54,
            )),
        // user profile picture

        ClipRRect(
          borderRadius: BorderRadius.circular(mq.height * .03),
          child: CachedNetworkImage(
            width: mq.height * .05,
            height: mq.height * .05,
            imageUrl: widget.user.image,
            errorWidget: (context, url, error) {
              return const CircleAvatar(
                child: Icon(CupertinoIcons.person),
              );
            },
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.user.name,
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 2,
            ),
            const Text(
              'Last seen not available',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500),
            )
          ],
        )
      ]),
    );
  }

  // chat input
  Widget _chatInput() {
    Size mq = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: mq.width * .03, vertical: mq.height * .01),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.emoji_emotions,
                        color: Colors.blueAccent,
                      )),
                   Expanded(
                      child: TextField(
                        controller: _msgControoler,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                        hintText: 'Type Something...',
                        hintStyle: TextStyle(color: Colors.blueAccent),
                        border: InputBorder.none),
                  )),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.image,
                        color: Colors.blueAccent,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.blueAccent,
                      )),
                ],
              ),
            ),
          ),
          MaterialButton(
            minWidth: 0,
            padding:
                const EdgeInsets.only(top: 8, bottom: 8, left: 15, right: 10),
            shape: const CircleBorder(),
            color: Colors.green,
            child: const Icon(
              Icons.send,
              color: Colors.white,
            ),
            onPressed: () {

if(_msgControoler.text.isNotEmpty){
  Apis.sendMessage(widget.user, _msgControoler.text);
  _msgControoler.text = '';
}

            },
          )
        ],
      ),
    );
  }
}
