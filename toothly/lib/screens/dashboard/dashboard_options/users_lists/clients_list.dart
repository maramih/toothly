
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toothly/models/profile.dart';
import 'package:toothly/models/user.dart';
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
                    users: DatabaseService().getProfilesByType(widget.type)),
              );
            },
          )
        ],
      ),
      body: StreamBuilder<List<Profile>>(
          stream: DatabaseService().getProfilesByType(widget.type),
          builder: (context, snapshot) {
            if (snapshot.hasData)
              return Scaffold(
                body: Container(
                  child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(snapshot.data[index].firstname +
                            " " +
                            snapshot.data[index].surname),
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

class UserSearch extends SearchDelegate<Profile> {
  final Stream<List<Profile>> users;
  List<Profile> results=[];
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
        results.map((user) =>  ListTile(
          title: Text(user.firstname +
              " " +
              user.surname),
        )).toList()
        ,
      ): Center(child: Text(SEARCH_EMPTY)),
      decoration: gradientBoxDecoration,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder<List<Profile>>(
        stream: users,
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return Text(SEARCH_EMPTY);
          }
          results=snapshot.data
              .where((user) =>
             (user.firstname+" "+user.surname).toLowerCase().contains(query)).toList();
          return Container(
            height: MediaQuery.of(context).size.height,
            child: ListView(
              shrinkWrap: true,
              children:
                results.map((user) =>  ListTile(
                  title: Text(user.firstname +
                      " " +
                      user.surname),
                )).toList()
              ,
            ),
            decoration: gradientBoxDecoration,
            );
        });
  }
}
