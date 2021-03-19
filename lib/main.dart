import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/theme_model.dart';
import 'package:todo_app/screens/tasks_screen.dart';

void main() {
  //SharedPreferences.setMockInitialValues({});
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  ThemeData basic =
      ThemeData(primaryColor: Colors.red, brightness: Brightness.light);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeChanger(),
      child: Consumer<ThemeChanger>(
          builder: (context, ThemeChanger notifier, child) {
        ThemeData current;
        if ((notifier.darkTheme) & (notifier.redColor)) {
          current = dark_r;
        } else if ((notifier.darkTheme) & (notifier.blueColor)) {
          current = dark_b;
        } else if ((!notifier.darkTheme) & (notifier.blueColor)) {
          current = basic_b;
        } else {
          current = basic_r;
        }
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: current,
            title: 'Flutter Demo',
            home: TasksScreen());
      }),
    );
  }
}
