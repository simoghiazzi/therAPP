import 'package:flutter/material.dart';
import 'package:therAPP/Router/app_router_delegate.dart';
import 'package:therAPP/views/AllPatients/all_patients_screen.dart';
import 'package:therAPP/views/Home/components/dash_card.dart';
import 'package:provider/provider.dart';
import 'package:therAPP/views/NewPatient/new_patient_screen.dart';

/// Grid of the [BaseUserHomePageScreen].
///
/// It contains the [DashCard]s that compose the grid.
class HomePageGrid extends StatelessWidget {
  /// Grid of the [BaseUserHomePageScreen].
  ///
  /// It contains the [DashCard]s that compose the grid.
  const HomePageGrid({super.key});

  @override
  Widget build(BuildContext context) {
    // Router Delegate
    AppRouterDelegate routerDelegate =
        Provider.of<AppRouterDelegate>(context, listen: false);

    return Center(
      child: Container(
          constraints: const BoxConstraints(maxWidth: 750),
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: SingleChildScrollView(
            child: Table(
              children: [
                TableRow(children: <Widget>[
                  // Expert Chats
                  DashCard(
                    row: 1,
                    imagePath: "assets/icons/add_patient.png",
                    text: "Nuovo\npaziente",
                    onTap: () =>
                        routerDelegate.pushPage(name: NewPatientScreen.route),
                  ),
                  // Anonymous Chats
                  DashCard(
                    row: 1,
                    imagePath: "assets/icons/list.png",
                    text: "Lista\npazienti",
                    onTap: () =>
                        routerDelegate.pushPage(name: AllPatientsScreen.route),
                  ),
                ]),
              ],
            ),
          )),
    );
  }
}
