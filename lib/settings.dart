import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _counter = 0;

  void _decrementCounter() => setState(() => _counter--);

  void _incrementCounter() => setState(() => _counter++);

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;

    return Scaffold(
      appBar: AppBar(
        title: Text(translate('app_bar.settings_title')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(translate('language.selected_message', args: {
              'language': translate(
                  'language.name.${localizationDelegate.currentLocale.languageCode}')
            })),
            Padding(
                padding: EdgeInsets.only(top: 25, bottom: 160),
                child: CupertinoButton.filled(
                  child: Text(translate('button.change_language')),
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 36.0),
                  onPressed: () => _onActionSheetPress(context),
                )),
          ],
        ),
      ),
    );
  }

  void showDemoActionSheet(
      {required BuildContext context, required Widget child}) {
    showCupertinoModalPopup<String>(
        context: context,
        builder: (BuildContext context) => child).then((String? value) {
      if (value != null) changeLocale(context, value);
    });
  }

  void _onActionSheetPress(BuildContext context) {
    showDemoActionSheet(
      context: context,
      child: CupertinoActionSheet(
        title: Text(translate('language.selection.title')),
        message: Text(translate('language.selection.message')),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text(translate('language.name.en')),
            onPressed: () => Navigator.pop(context, 'en_US'),
          ),
          CupertinoActionSheetAction(
            child: Text(translate('language.name.lt')),
            onPressed: () => Navigator.pop(context, 'lt'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text(translate('button.cancel')),
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context, null),
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';

// import 'language.dart';

// class SettingsPage extends StatefulWidget {
//   @override
//   _SettingsPageState createState() => _SettingsPageState();
// }

// class _SettingsPageState extends State<SettingsPage> {
//   String _selectedLanguage = 'English';
//   String _selectedNotificationTiming = '30 minutes';

//   List<String> _languages = ['English', 'Lietuviškai'];
//   List<String> _notificationTimings = ['30 minutes', '1 hour', '2 hours'];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Settings'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Language',
//               style: TextStyle(
//                 fontSize: 16.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 8.0),
//             DropdownButton(
//               value: _selectedLanguage,
//               onChanged: (value) {
//                 setState(() {
//                   _selectedLanguage = value!;
//                   print(value);
//                   if (value == "English") {
//                     setLanguage('en');
//                   } else {
//                     setLanguage('lt');
//                   }
//                 });
//               },
//               items:
//                   _languages.map<DropdownMenuItem<String>>((String language) {
//                 return DropdownMenuItem<String>(
//                   value: language,
//                   child: Text(language),
//                 );
//               }).toList(),
//             ),
//             SizedBox(height: 16.0),
//             Text(
//               'Notification Timing',
//               style: TextStyle(
//                 fontSize: 16.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 8.0),
//             DropdownButton(
//               value: _selectedNotificationTiming,
//               onChanged: (value) {
//                 setState(() {
//                   _selectedNotificationTiming = value!;
//                 });
//               },
//               items: _notificationTimings
//                   .map<DropdownMenuItem<String>>((String timing) {
//                 return DropdownMenuItem<String>(
//                   value: timing,
//                   child: Text(timing),
//                 );
//               }).toList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
