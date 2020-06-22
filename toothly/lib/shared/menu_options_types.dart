import 'package:flutter/material.dart';
import 'package:toothly/screens/dashboard/menu_option.dart';
import 'package:toothly/shared/environment_variables.dart';

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
  optionText: CALENDAR,
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
final option_clinic = MenuOption(
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

final option_admin_calendar = MenuOption(
    iconData: Icons.calendar_view_day,
    optionText: ADMIN_CALENDAR,
    userAccess: [
      ERoleTypes.admin.index,
    ]);

final option_appointments = MenuOption(
    iconData: Icons.calendar_view_day,
    optionText: APPOINTMENTS,
    userAccess: [
      ERoleTypes.admin.index,
      ERoleTypes.doctor.index
    ]);
