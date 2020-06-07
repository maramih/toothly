import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toothly/models/profile.dart';
import './profile_tile.dart';

class ProfileList extends StatefulWidget {
  @override
  _ProfileList createState() => _ProfileList();
}

class _ProfileList extends State<ProfileList> {
  @override
  Widget build(BuildContext context) {
    final profiles = Provider.of<List<Profile>>(context)??[];
    return ListView.builder(
      itemCount: profiles.length,
      itemBuilder: (context, index){
        return ProfileTile(profile: profiles[index]);
      },
    );
  }
}
