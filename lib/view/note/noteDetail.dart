// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:revver/component/button.dart';
import 'package:revver/component/header.dart';
import 'package:revver/component/snackbar.dart';
import 'package:revver/component/spacer.dart';
import 'package:revver/controller/note.dart';
import 'package:revver/globals.dart';
import 'package:revver/model/note.dart';

class NoteDetail extends StatefulWidget {
  NoteDetail({Key key, this.id}) : super(key: key);
  String id;

  @override
  State<NoteDetail> createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetail> {
  final RegExp _numeric = RegExp(r'^-?[0-9]+$');
  bool isLoad = true;
  String date = "-";
  String type = "";
  int id;
  List<NoteList> note_list = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final List<TextEditingController> _controllers = [];

  getData(i) async {
    await getNoteDetail(i).then((val) {
      setState(() {
        id = val['data']['id'];
        titleController.text = val['data']['title'];
        descriptionController.text = val['data']['text'];
        date = val['data']['updated_at'];
        type = capitalize(val['data']['type']);
        for (var data in val['data']['note_list'] as List) {
          note_list.add(NoteList.fromJson(jsonEncode(data)));
        }
        isLoad = false;
      });
    });
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  bool isNumeric(String str) {
    return _numeric.hasMatch(str);
  }

  @override
  void initState() {
    if (isNumeric(widget.id)) {
      getData(widget.id);
    } else {
      setState(() {
        type = widget.id;
        isLoad = false;
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: Scaffold(
        appBar: StandartHeader(
          title: type ??= "",
          isPop: true,
          svgName: "trash-can-solid.svg",
          func: () async {
            await deleteNote(id).then((val) {
              if (val['status'] == 200) {
                GoRouter.of(context).pop();
              } else {
                customSnackBar(context, true, val['status']);
              }
            });
          },
        ),
        body: (isLoad)
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Created On: $date",
                          style: CustomFont(CustomColor.oldGreyColor, 9, null)
                              .font,
                        )
                      ],
                    ),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Note Title',
                        hintStyle: CustomFont(
                                CustomColor.oldGreyColor, 18, FontWeight.bold)
                            .font,
                      ),
                      style: CustomFont(
                              CustomColor.blackColor, 18, FontWeight.bold)
                          .font,
                    ),
                    (type.toLowerCase() == "text")
                        ? Expanded(
                            child: TextField(
                              controller: descriptionController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'eg: Catatan Hari Ini',
                                hintStyle: CustomFont(
                                        CustomColor.oldGreyColor, 14, null)
                                    .font,
                              ),
                              style:
                                  CustomFont(CustomColor.blackColor, 14, null)
                                      .font,
                            ),
                          )
                        : (note_list.isNotEmpty)
                            ? Column(
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: note_list.length,
                                    itemBuilder: ((context, index) {
                                      NoteList nl = note_list[index];
                                      _controllers.add(
                                          TextEditingController(text: nl.text));
                                      return Column(
                                        children: [
                                          (index == 0)
                                              ? SpacerHeight(h: 10)
                                              : SizedBox(),
                                          SizedBox(
                                            height: 28,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(
                                                  height: 28,
                                                  width: 28,
                                                  child: Transform.scale(
                                                    scale: 1.2,
                                                    child: Checkbox(
                                                      shape: CircleBorder(),
                                                      value: nl.is_check == 1,
                                                      onChanged: (val) {
                                                        if (val) {
                                                          setState(() {
                                                            nl.is_check = 1;
                                                          });
                                                        } else {
                                                          setState(() {
                                                            nl.is_check = 0;
                                                          });
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                SpacerWidth(w: 5),
                                                Expanded(
                                                  child: TextField(
                                                    onChanged: (val) {
                                                      setState(() {
                                                        nl.text = val;
                                                      });
                                                    },
                                                    controller:
                                                        _controllers[index],
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                    ),
                                                    style: CustomFont(
                                                            CustomColor
                                                                .oldGreyColor,
                                                            14,
                                                            null)
                                                        .font,
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      note_list.removeWhere(
                                                          (item) =>
                                                              item.text ==
                                                              nl.text);
                                                    });
                                                  },
                                                  child: Icon(
                                                    Icons.delete,
                                                    size: 18,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                                  ),
                                  SpacerHeight(h: 10),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            note_list.add(NoteList(
                                              text: "New Item",
                                              is_check: 0,
                                            ));
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            SpacerWidth(w: 33),
                                            Text(
                                              "+ Add Item",
                                              style: CustomFont(
                                                      CustomColor.oldGreyColor,
                                                      14,
                                                      null)
                                                  .font,
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            : Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        note_list.add(NoteList(
                                          text: "New Item",
                                          is_check: 0,
                                        ));
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        SpacerWidth(w: 33),
                                        Text(
                                          "+ Add Item",
                                          style: CustomFont(
                                                  CustomColor.oldGreyColor,
                                                  14,
                                                  null)
                                              .font,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )
                  ],
                ),
              ),
        bottomNavigationBar: Container(
          color: CustomColor.whiteColor,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: CustomButton(
            title: "Save",
            func: () async {
              if (isNumeric(widget.id)) {
                // patch
                await patchNote(
                        id.toString(),
                        titleController.text,
                        type.toLowerCase(),
                        descriptionController.text,
                        note_list)
                    .then((val) {
                  if (val["status"] == 200) {
                    GoRouter.of(context).pop();
                  } else {
                    customSnackBar(context, true, val['status']);
                  }
                });
              } else {
                // add
                if (type == "checkbox" && note_list.isEmpty) {
                  customSnackBar(context, true, "Add Item First!");
                } else {
                  int len = note_list.length;
                  await postNote(
                          titleController.text,
                          type.toLowerCase(),
                          (type == "checkbox")
                              ? "$len Items"
                              : descriptionController.text,
                          note_list)
                      .then((val) {
                    if (val["status"] == 200) {
                      GoRouter.of(context).pop();
                    } else {
                      customSnackBar(context, true, val['status']);
                    }
                  });
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
