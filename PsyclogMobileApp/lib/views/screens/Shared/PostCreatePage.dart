import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:psyclog_app/service/ForumService.dart';
import 'package:psyclog_app/src/models/Topic.dart';
import 'package:psyclog_app/views/util/ViewConstants.dart';

class PostCreatePage extends StatefulWidget {
  final Topic _currentTopic;

  const PostCreatePage(
    this._currentTopic, {
    Key key,
  }) : super(key: key);

  @override
  _PostCreatePageState createState() => _PostCreatePageState();
}

class _PostCreatePageState extends State<PostCreatePage> {
  final UnfocusDisposition disposition = UnfocusDisposition.scope;

  ForumService _forumService;

  FilePickerResult images;

  final _contentController = TextEditingController();

  String _contentErrorText;

  bool _contentValidate;

  bool isAuthorAnonymous;

  bool isWaiting;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    isWaiting = false;
    isAuthorAnonymous = false;

    _contentErrorText = "";
    _contentValidate = false;
  }

  Future<bool> initializeService() async {
    _forumService = await ForumService.getForumService();
    return _forumService != null ? true : false;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ViewConstants.myWhite,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft, end: Alignment(10, 10), colors: [ViewConstants.myWhite, ViewConstants.myBlue]),
        ),
        child: FutureBuilder(
          future: initializeService(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.data == true) {
              return ListView(
                physics: ClampingScrollPhysics(),
                children: [
                  AppBar(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    centerTitle: true,
                    title: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: AutoSizeText(
                        "New Post",
                        style: GoogleFonts.lato(color: ViewConstants.myBlack, fontWeight: FontWeight.bold),
                      ),
                    ),
                    iconTheme: IconThemeData(color: ViewConstants.myBlack),
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                      child: AutoSizeText(
                        "Associated Topic",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.lato(color: ViewConstants.myBlack, fontWeight: FontWeight.bold),
                      )),
                  Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: ViewConstants.myBlue.withOpacity(0.5)),
                        ),
                        child: AutoSizeText(
                          widget._currentTopic.getTitle,
                          textAlign: TextAlign.left,
                          style: GoogleFonts.lato(color: ViewConstants.myBlack, fontWeight: FontWeight.bold),
                        ),
                      )),
                  Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                      child: AutoSizeText(
                        "Post Content",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.lato(color: ViewConstants.myBlack, fontWeight: FontWeight.bold),
                      )),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      controller: _contentController,
                      maxLines: 8,
                      maxLength: 250,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.description,
                          color: ViewConstants.myBlue,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ViewConstants.myBlue.withOpacity(0.25)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ViewConstants.myBlue),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ViewConstants.myPink),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ViewConstants.myPink),
                        ),
                        errorText: _contentValidate ? _contentErrorText : null,
                        errorStyle: TextStyle(fontSize: 15, color: ViewConstants.myPink, fontWeight: FontWeight.w400),
                        hintText: 'Type a post content',
                        hintStyle: TextStyle(
                            fontSize: 15, color: ViewConstants.myBlue.withOpacity(0.5), fontWeight: FontWeight.w400),
                      ),
                      style: TextStyle(color: ViewConstants.myBlack, fontWeight: FontWeight.w500, fontSize: 15),
                      cursorColor: ViewConstants.myBlue,
                      cursorWidth: 1.5,
                      onEditingComplete: () {
                        primaryFocus.unfocus(disposition: disposition);
                        setState(() {
                          _contentController.text.isEmpty ? _contentValidate = true : _contentValidate = false;
                          _contentValidate ? _contentErrorText = "Content cannot be empty" : _contentErrorText = null;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: FlatButton(
                      color: ViewConstants.myBlue,
                      onPressed: () async {
                        images = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['jpg', 'png'],
                          allowMultiple: true,
                        );
                        if (images != null) {
                          setState(() {
                            print(images.count);
                            print(images.paths);
                          });
                        }
                      },
                      child: Text(
                        "Pick Images",
                        style: TextStyle(fontSize: 15, color: ViewConstants.myWhite, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  images != null
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height / 4,
                          child: Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: Center(
                              child: ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  itemCount: images.count,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (BuildContext context, int index) {
                                    File file = File(images.files[index].path);

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                      child: Image.file(file),
                                    );
                                  }),
                            ),
                          ),
                        )
                      : Container(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: isAuthorAnonymous ? ViewConstants.myBlue : ViewConstants.myGrey, width: 2),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AutoSizeText(
                            "Post as Anonymous",
                            textAlign: TextAlign.left,
                            style: GoogleFonts.lato(
                                color: isAuthorAnonymous ? ViewConstants.myBlue : ViewConstants.myGrey,
                                fontWeight: FontWeight.bold),
                          ),
                          FlatButton(
                            color: isAuthorAnonymous ? ViewConstants.myBlue : ViewConstants.myGrey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            onPressed: () {
                              setState(() {
                                isAuthorAnonymous = !isAuthorAnonymous;
                                print(isAuthorAnonymous);
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: isAuthorAnonymous
                                  ? Container(
                                      child: Text("Enabled"),
                                    )
                                  : Container(
                                      child: Text("Disabled"),
                                    ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Builder(
                    builder: (BuildContext builderContext) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                        child: FlatButton(
                          color: ViewConstants.myBlack,
                          disabledColor: ViewConstants.myBlue,
                          onPressed: !isWaiting
                              ? () async {
                                  if (_contentController.text.isNotEmpty) {
                                    setState(() {
                                      isWaiting = true;
                                    });

                                    bool isCreated;

                                    if (images != null) {
                                      isCreated = await _forumService.createPost(
                                          widget._currentTopic.getID, _contentController.text, isAuthorAnonymous,
                                          imagePaths: images.paths);
                                    } else {
                                      isCreated = await _forumService.createPost(
                                          widget._currentTopic.getID, _contentController.text, isAuthorAnonymous);
                                    }

                                    if (isCreated)
                                      Navigator.pop(context, isCreated);
                                    else {
                                      setState(() {
                                        isWaiting = false;
                                      });

                                      final snackBar = SnackBar(
                                          content: Text('Post could not be created. Try again.',
                                              style: GoogleFonts.lato(color: ViewConstants.myGrey)));

                                      Scaffold.of(builderContext).showSnackBar(snackBar);
                                    }
                                  } else {
                                    final snackBar = SnackBar(
                                        content: Text('Please fill all the areas.',
                                            style: GoogleFonts.lato(color: ViewConstants.myGrey)));

                                    Scaffold.of(builderContext).showSnackBar(snackBar);
                                  }
                                }
                              : null,
                          child: Text(
                            !isWaiting ? "Create" : "Loading",
                            style: TextStyle(fontSize: 15, color: ViewConstants.myWhite, fontWeight: FontWeight.w500),
                          ),
                        ),
                      );
                    },
                  )
                ],
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
