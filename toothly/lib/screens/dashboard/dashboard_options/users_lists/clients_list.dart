
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toothly/models/profile.dart';
import 'package:toothly/models/user.dart';
import 'package:toothly/screens/dashboard/dashboard_options/history_log.dart';
import 'package:toothly/screens/profile/my_profile.dart';
import 'package:toothly/services/database.dart';
import 'package:toothly/shared/ERoleTypes.dart';
import 'package:toothly/shared/colors.dart';
import 'package:toothly/shared/constants.dart';
import 'package:toothly/shared/loading.dart';
import 'package:toothly/shared/environment_variables.dart';

class ClientList extends StatefulWidget {
  final ERoleTypes type;

  ClientList(this.type);

  @override
  _ClientListState createState() => _ClientListState();
}

class _ClientListState extends State<ClientList> {
  @override
  Widget build(BuildContext context) {
    final user=Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Pacienți"),
        backgroundColor: Swatches.green2.withOpacity(1),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: UserSearch(
                    users: DatabaseService().getPatients(user, ERoleTypes.client)),
              );
            },
          )
        ],
      ),
      body: StreamBuilder<List<UserData>>(
          stream: DatabaseService().getPatients(user, ERoleTypes.client),
          builder: (context, snapshot) {
            if (snapshot.hasData)
              return Scaffold(
                body: Container(
                  child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0)),
                            color: Colors.white),
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: Text(snapshot.data[index].firstname +
                                  " " +
                                  snapshot.data[index].surname),
                            ),
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                FlatButton.icon(
                                  icon: Icon(Icons.remove_red_eye),
                                  label: Text('Profil'),
                                  onPressed: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => MyProfile(snapshot.data[index].uid)),
                                    );
                                  },
                                ),
                                FlatButton.icon(
                                  icon: Icon(Icons.archive),
                                  label: Text('Consultații'),
                                  onPressed: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => HistoryLog(snapshot.data[index].uid)));
                                  },
                                ),
                              ],
                            ),

                          ],
                        ),
                      );
                    },
                  ),
                  decoration: gradientBoxDecoration,
                ),
              );
            else
              return Loading();
          }),
      bottomNavigationBar: bottomBar,
    );
  }
}

class UserSearch extends SearchDelegate<UserData> {
  final Stream<List<UserData>> users;
  List<UserData> results=[];
  UserSearch({this.users});

  @override
  String get searchFieldLabel => SEARCH;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query="";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: results.length!=0 ?
      ListView(
        shrinkWrap: true,
        children:
        results.map((user) =>  Container(
          margin: const EdgeInsets.symmetric(
              horizontal: 8.0, vertical: 4.0),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                  const Radius.circular(10.0)),
              color: Colors.white),
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(user.firstname +
                    " " +
                    user.surname),
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  FlatButton.icon(
                    icon: Icon(Icons.remove_red_eye),
                    label: Text('Profil'),
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyProfile(user.uid)),
                      );
                    },
                  ),
                  FlatButton.icon(
                    icon: Icon(Icons.archive),
                    label: Text('Consultații'),
                    onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HistoryLog(user.uid)));
                    },
                  ),
                ],
              ),

            ],
          ),
        )).toList()
        ,
      ): Center(child: Text(SEARCH_EMPTY)),
      decoration: gradientBoxDecoration,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder<List<UserData>>(
        stream: users,
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return loadingIndicator;
          }
          results=snapshot.data
              .where((user) =>
             (user.firstname+" "+user.surname).toLowerCase().contains(query)).toList();
          return Container(
            height: MediaQuery.of(context).size.height,
            child: ListView(
              shrinkWrap: true,
              children:
                results.map((user) => Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                          const Radius.circular(10.0)),
                      color: Colors.white),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(user.firstname +
                            " " +
                            user.surname),
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          FlatButton.icon(
                            icon: Icon(Icons.remove_red_eye),
                            label: Text('Profil'),
                            onPressed: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => MyProfile(user.uid)),
                              );
                            },
                          ),
                          FlatButton.icon(
                            icon: Icon(Icons.archive),
                            label: Text('Consultații'),
                            onPressed: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => HistoryLog(user.uid)));
                            },
                          ),
                        ],
                      ),

                    ],
                  ),
                )).toList()
              ,
            ),
            decoration: gradientBoxDecoration,
            );
        });
  }
}
