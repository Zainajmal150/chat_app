import 'dart:developer';

import 'package:chat_app/helper/mydateutil.dart';
import 'package:chat_app/models/messagesmodel.dart';
import 'package:chat_app/utils/services.dart';
import 'package:flutter/material.dart';

class MessageCard extends StatefulWidget {
  final Message message;
  const MessageCard({super.key, required this.message});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return Apis.user.uid == widget.message.formid
        ? _greenMessage()
        : _blueMessage();
  }

  Widget _blueMessage() {
    Size mq = MediaQuery.of(context).size;

    if (widget.message.read.isEmpty) {
      Apis.updateMessageReadStatus(widget.message);
      log('message read updated');
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
            child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: mq.width * .04, vertical: mq.height * .01),
          padding: EdgeInsets.all(mq.width * .04),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              color: const Color.fromARGB(255, 221, 245, 255),
              border: Border.all(color: Colors.lightBlue)),
          child: Text(
            widget.message.msg,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
        )),
        Padding(
          padding: EdgeInsets.only(right: mq.width * .04),
          child: Text(
            MyDateUtils.getFormatedTime(
                context: context, time: widget.message.sent),
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
        )
      ],
    );
  }

  Widget _greenMessage() {
    Size mq = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: mq.width * .04,
            ),
            if (widget.message.read.isNotEmpty)
              const Icon(
                Icons.done_all_rounded,
                color: Colors.blue,
                size: 20,
              ),
            const SizedBox(width: 2),
            Text(
              MyDateUtils.getFormatedTime(
                  context: context, time: widget.message.sent),
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
        Flexible(
            child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: mq.width * .04, vertical: mq.height * .01),
          padding: EdgeInsets.all(mq.width * .04),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
              color: const Color.fromARGB(215, 218, 255, 176),
              border: Border.all(color: Colors.lightGreen)),
          child: Text(
            widget.message.msg,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
        )),
      ],
    );
  }
}
