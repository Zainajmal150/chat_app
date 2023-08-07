import 'package:chat_app/models/chatusermodel.dart';
import 'package:chat_app/utils/services.dart';
import 'package:chat_app/views/mainpage/profile_screen.dart';
import 'package:chat_app/views/widget/chatcard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  List<ChatUser> list = [];
  final List<ChatUser> _searchList = [];
  bool isSearching = false;
  @override
  void initState() {
    super.initState();
    Apis.selfInfo();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: WillPopScope(
        onWillPop: () {
          if (isSearching) {
            setState(() {
              isSearching = !isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.white,
                iconTheme: IconThemeData(color: Colors.black),
                centerTitle: true,
                leading: const Icon(CupertinoIcons.home),
                actions: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          isSearching = !isSearching;
                        });
                      },
                      icon: Icon(isSearching
                          ? CupertinoIcons.clear_circled_solid
                          : CupertinoIcons.search)),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ProfileScreen(
                                      user: Apis.me,
                                    )));
                      },
                      icon: const Icon(CupertinoIcons.ellipsis_vertical)),
                ],
                title: isSearching
                    ? TextFormField(
                        onChanged: (val) {
                          _searchList.clear();

                          for (var i in list) {
                            if (i.name
                                    .toLowerCase()
                                    .contains(val.toLowerCase()) ||
                                i.email
                                    .toLowerCase()
                                    .contains(val.toLowerCase())) {
                              _searchList.add(i);
                            }
                            setState(() {
                              _searchList;
                            });
                          }
                        },
                        style:
                            const TextStyle(fontSize: 17, letterSpacing: 0.5),
                        autofocus: true,
                        decoration: const InputDecoration(
                            hintText: 'Name, Email, ...',
                            border: InputBorder.none),
                      )
                    : const Text(
                        'ChatHut',
                        style: TextStyle(color: Colors.black),
                      )),
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: FloatingActionButton(
                onPressed: () async {
                  await Apis.auth.signOut();
                  await GoogleSignIn().signOut();
                },
                child: const Icon(CupertinoIcons.rectangle_expand_vertical),
              ),
            ),
            body: StreamBuilder(
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    case ConnectionState.active:
                    case ConnectionState.done:
                      final data = snapshot.data?.docs;
                      list = data
                              ?.map((e) => ChatUser.fromJson(e.data()))
                              .toList() ??
                          [];

                      if (list.isNotEmpty) {
                        return ListView.builder(
                          itemCount:
                              isSearching ? _searchList.length : list.length,
                          itemBuilder: (context, index) {
                            return ChatCard(
                                user: isSearching
                                    ? _searchList[index]
                                    : list[index]);
                          },
                        );
                      } else {
                        return const Center(
                          child: Text("No User Found"),
                        );
                      }
                  }
                },
                stream: Apis.getAllUsers())),
      ),
    );
  }
}
