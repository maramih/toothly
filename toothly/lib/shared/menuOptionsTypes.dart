import 'package:flutter/material.dart';
import 'package:toothly/screens/dashboard/menu_option.dart';
import 'package:toothly/shared/strings.dart';

import 'ERoleTypes.dart';


final option1 = MenuOption(
    iconData: Icons.people_outline,
    optionText: CLIENTS,
    userAccess: [
      ERoleTypes.asistenta.index,
      ERoleTypes.doctor.index,
      ERoleTypes.admin.index
    ]);

final option2 = MenuOption(
  iconData: Icons.calendar_today,
  optionText: APPOINTMENTS,
  userAccess: [
    ERoleTypes.asistenta.index,
    ERoleTypes.doctor.index,
    ERoleTypes.admin.index,
    ERoleTypes.client.index
  ],);
final option3 = MenuOption(iconData: Icons.people,
    optionText: CLINIC,
    userAccess: [
      ERoleTypes.admin.index,
      ERoleTypes.asistenta.index,
      ERoleTypes.client.index,
      ERoleTypes.doctor.index
    ])
;
final option4 = MenuOption(
    iconData: Icons.loupe,
    optionText: CLINIC,
    userAccess: [
      ERoleTypes.asistenta.index,
      ERoleTypes.doctor.index,
      ERoleTypes.admin.index
    ]);

final option5 = MenuOption(
    iconData: Icons.group_add,
    optionText: ADMIN_EMPLOYEES,
    userAccess: [
      ERoleTypes.admin.index,
      ERoleTypes.doctor.index
    ]);

final option6 = MenuOption(
    iconData: Icons.calendar_view_day,
    optionText: ADMIN_CALENDAR,
    userAccess: [
      ERoleTypes.admin.index,
      ERoleTypes.doctor.index
    ]);
