import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/theme_model.dart';

class setTheme extends StatefulWidget {
  Color primaryColor;
  Brightness theme;

  setTheme({this.primaryColor, this.theme});
  @override
  _setThemeState createState() => _setThemeState();
}

class _setThemeState extends State<setTheme> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).padding.top + 5, horizontal: 8),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: [
                IconButton(
                    color: Theme.of(context).primaryColor,
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                Text(
                  'Set Theme',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Consumer<ThemeChanger>(
                builder: (context, ThemeChanger notifier, child) =>
                    SwitchListTile(
                        activeColor: Theme.of(context).primaryColor,
                        title: Text(
                          'Dark Mode:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        value: notifier.darkTheme,
                        onChanged: (value) {
                          notifier.toggleTheme();
                        })),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Colour :',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  Row(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Consumer<ThemeChanger>(
                            builder: (context, ThemeChanger notifier, child) =>
                                CircularCheckBox(
                                    inactiveColor: Colors.red,
                                    disabledColor: Colors.red,
                                    activeColor: Colors.red,
                                    value: notifier.redColor,
                                    onChanged: (value) {
                                      notifier.toggleRed();
                                      notifier.toggleBlue();
                                    }),
                          ),
                          Consumer<ThemeChanger>(
                            builder: (context, ThemeChanger notifier, child) =>
                                CircularCheckBox(
                                    inactiveColor: Colors.blue,
                                    disabledColor: Colors.blue,
                                    activeColor: Colors.blue,
                                    value: notifier.blueColor,
                                    onChanged: (value) {
                                      notifier.toggleBlue();
                                      notifier.toggleRed();
                                    }),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
