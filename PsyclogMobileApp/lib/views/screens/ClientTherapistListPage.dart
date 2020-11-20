import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:psyclog_app/src/models/Therapist.dart';
import 'package:psyclog_app/view_models/client/SearchTherapistListViewModel.dart';
import 'package:psyclog_app/views/controllers/RouteArguments.dart';
import 'package:psyclog_app/views/util/ViewConstants.dart';
import 'package:psyclog_app/views/widgets/InactiveTherapistCard.dart';
import 'package:psyclog_app/views/widgets/LoadingIndicator.dart';
import 'package:psyclog_app/views/widgets/AwareListItem.dart';
import 'package:psyclog_app/views/util/CapExtension.dart';
import 'package:wave/config.dart';

class ClientTherapistsListPage extends StatefulWidget {
  final String pageName;

  const ClientTherapistsListPage({Key key, this.pageName}) : super(key: key);

  @override
  _ClientTherapistsListPageState createState() => _ClientTherapistsListPageState();
}

class _ClientTherapistsListPageState extends State<ClientTherapistsListPage> {
  SearchTherapistListViewModel _therapistListViewModel;

  Color pageColor;
  String pageTitle;
  Color pageTitleColor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _therapistListViewModel = SearchTherapistListViewModel();

    switch (widget.pageName) {
      case ViewConstants.allTherapists:
        pageColor = ViewConstants.myLightBlue;
        pageTitle = ViewConstants.allTherapists + " Therapists";
        pageTitleColor = ViewConstants.myBlack;
        break;
      case ViewConstants.preferredTherapists:
        pageColor = ViewConstants.myPink;
        pageTitle = ViewConstants.preferredTherapists + " Therapists";
        pageTitleColor = ViewConstants.myBlack;
        break;
      case ViewConstants.latestTherapists:
        pageColor = ViewConstants.myYellow;
        pageTitle = ViewConstants.latestTherapists + " Therapists";
        pageTitleColor = ViewConstants.myBlack;
        break;
      case ViewConstants.seniorTherapists:
        pageColor = ViewConstants.myGreyBlue;
        pageTitle = ViewConstants.seniorTherapists;
        pageTitleColor = ViewConstants.myBlack;
        break;
      default:
        pageColor = Colors.transparent;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Theme(
              data: ThemeData(
                accentColor: pageColor, // Over Scroll Color
              ),
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    expandedHeight: MediaQuery.of(context).size.height * 0.40,
                    pinned: true,
                    stretch: true,
                    backgroundColor: ViewConstants.myWhite,
                    iconTheme: IconThemeData(
                      color: ViewConstants.myBlack,
                    ),
                    flexibleSpace: SafeArea(
                      child: FlexibleSpaceBar(
                        title: Center(
                          child: Text(pageTitle,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: pageTitleColor,
                                  fontWeight: FontWeight.bold)),
                        ),
                        centerTitle: true,
                        background: LoadingIndicator(
                          config: CustomConfig(
                            colors: [
                              pageColor.withOpacity(0.25),
                              pageColor.withOpacity(0.50),
                              pageColor.withOpacity(0.75),
                              pageColor,
                            ],
                            durations: [
                              50000,
                              46000,
                              42000,
                              38000,
                            ],
                            heightPercentages: [0.40, 0.48, 0.56, 0.64],
                          ),
                        ),
                        collapseMode: CollapseMode.parallax,
                      ),
                    ),
                  ),
                  ChangeNotifierProvider<SearchTherapistListViewModel>(
                    create: (context) => _therapistListViewModel,
                    child: Consumer<SearchTherapistListViewModel>(
                      builder: (context, model, child) => SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            bool currentUserApplied;

                            Therapist _currentIndexedTherapist =
                                model.getTherapistByElement(index);

                            if (_currentIndexedTherapist != null)
                              currentUserApplied = model.checkPendingStatus(
                                  _currentIndexedTherapist.userID);

                            return AwareListItem(
                              itemCreated: () {
                                print("List Item:" + index.toString() + " Applied: " + currentUserApplied.toString());
                                SchedulerBinding.instance
                                    .addPostFrameCallback((duration) {
                                  model.handleItemCreated(index);
                                });
                              },
                              child: Builder(
                                builder: (BuildContext context) {
                                  if (_currentIndexedTherapist == null) {
                                    return Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Center(
                                          child: CircularProgressIndicator()),
                                    );
                                  } else if (_currentIndexedTherapist.isActive) {
                                    double containerHeight =
                                        MediaQuery.of(context).size.height / 8 + 20;

                                    return Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      margin: EdgeInsets.all(10),
                                      elevation: 2,
                                      child: Container(
                                        height: containerHeight,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: ViewConstants.myWhite,
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color:
                                                    pageColor.withOpacity(0.25),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                                  8,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  8,
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              "Dr. " +
                                                                  _currentIndexedTherapist
                                                                      .userFirstName
                                                                      .toString()
                                                                      .inCaps +
                                                                  " " +
                                                                  _currentIndexedTherapist
                                                                      .userSurname
                                                                      .toString()
                                                                      .inCaps,
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  color: ViewConstants
                                                                      .darkGreyBlue,
                                                                  fontFamily:
                                                                      "OpenSans",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(top: 3),
                                                            child: Text(
                                                              "Family and Marriage Therapist",
                                                              style: TextStyle(
                                                                  fontSize: 10,
                                                                  color:
                                                                      ViewConstants
                                                                          .myBlue,
                                                                  fontFamily:
                                                                      "OpenSans",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(top: 3),
                                                            child: Text(
                                                              Random()
                                                                      .nextInt(20)
                                                                      .toString() +
                                                                  " years experience",
                                                              style: TextStyle(
                                                                  fontSize: 10,
                                                                  color: ViewConstants
                                                                      .myPink
                                                                      .withOpacity(
                                                                          0.75),
                                                                  fontFamily:
                                                                      "OpenSans",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(top: 3),
                                                            child: Text(
                                                              _currentIndexedTherapist
                                                                      .appointmentPrice
                                                                      .toString() +
                                                                  "\$ per Hour",
                                                              style: TextStyle(
                                                                  fontSize: 10,
                                                                  color: ViewConstants
                                                                      .darkGreyBlue,
                                                                  fontFamily:
                                                                      "OpenSans",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: containerHeight,
                                              color: pageColor ==
                                                      ViewConstants.myWhite
                                                  ? ViewConstants.myLightGrey
                                                  : pageColor.withOpacity(0.25),
                                              child: IconButton(
                                                icon: Icon(Icons.arrow_forward),
                                                color: pageColor ==
                                                        ViewConstants.myWhite
                                                    ? ViewConstants.myBlack
                                                    : pageColor,
                                                onPressed: () async {

                                                  // Waiting for Client to complete its interaction with the request
                                                  await Navigator.pushNamed(
                                                      context,
                                                      ViewConstants
                                                          .therapistRequestRoute,
                                                      arguments:
                                                          TherapistRequestScreenArguments(
                                                              _currentIndexedTherapist,
                                                              currentUserApplied));

                                                  // Refresh pending therapist list after Therapist Request Page to keep thew list fresh
                                                  model.refreshPendingList();
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                        alignment: Alignment.center,
                                      ),
                                    );
                                  } else if (!_currentIndexedTherapist.isActive) {
                                    return InactiveTherapistCard(
                                        therapist: _currentIndexedTherapist,
                                        pageColor: pageColor);
                                  } else {
                                    return CircularProgressIndicator();
                                  }
                                },
                              ),
                            );
                          },
                          childCount:
                              model.getCurrentListLength(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}