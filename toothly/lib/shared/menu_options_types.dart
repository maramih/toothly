import 'package:flutter/material.dart';
import 'package:toothly/screens/dashboard/menu_option.dart';
import 'package:toothly/shared/environment_variables.dart';

import 'ERoleTypes.dart';


final option_clients = MenuOption(
    iconData: Icons.people_outline,
    optionText: CLIENTS,
    userAccess: [
      ERoleTypes.doctor.index,
      ERoleTypes.admin.index
    ]);

final option_calendar = MenuOption(
  iconData: Icons.calendar_today,
  optionText: CALENDAR,
  userAccess: [
    ERoleTypes.client.index
  ],);

final option_clinic_admin = MenuOption(iconData: Icons.people,
    optionText: ADMIN_CLINIC,
    userAccess: [
      ERoleTypes.admin.index,
    ])
;
final option_clinic = MenuOption(
    iconData: Icons.loupe,
    optionText: CLINIC,
    userAccess: [
      ERoleTypes.doctor.index,
    ]);

final option_admin_employees = MenuOption(
    iconData: Icons.group_add,
    optionText: ADMIN_EMPLOYEES,
    userAccess: [
      ERoleTypes.admin.index,
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
      ERoleTypes.doctor.index,
      ERoleTypes.client.index

    ]);

final option_history_log = MenuOption(
    iconData: Icons.history,
    optionText: HISTORY_LOG,
    userAccess: [
      ERoleTypes.client.index,
    ]);
