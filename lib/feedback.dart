import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/account.dart';
import 'models/feedback.dart';
import 'theme.dart';

class FeedbackScreen extends StatefulWidget {
  final AppFeedback feedback;

  const FeedbackScreen({Key key, @required this.feedback}) : super(key: key);

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _uploadResults(Account account) async {
    final response = await account.submitFeedback(feedback: widget.feedback);

    if (!response) {
      showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
                title: Text('Error'),
                content: Text(
                    'We were not able to submit the feedback successfully, please try again later'),
                actions: [
                  CupertinoDialogAction(
                    child: Text('Ok'),
                    isDefaultAction: true,
                    onPressed: Navigator.of(context, rootNavigator: true).pop,
                  )
                ],
              ));
    }
    // Pop twice to get rid of the dialog box as well.
    Navigator.of(context, rootNavigator: true).pop();
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final account = Provider.of<Account>(context);
    log('${account.name}');
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.feedback.type == AppFeedbackType.problem
                ? "Something isn't working"
                : "General Feedback",
            style: Theme.of(context).textTheme.headline3),
        leading: TextButton(
            child: Text('Close',
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(color: Colors.blueAccent)),
            onPressed: Navigator.of(context, rootNavigator: true).pop),
        actions: [
          TextButton(
            child: Text('Send',
                style: Theme.of(context).textTheme.headline5.copyWith(
                    color: _controller.text?.isNotEmpty ?? false
                        ? Colors.blueAccent
                        : Colors.grey)),
            onPressed: () async => _controller.text.isNotEmpty ?? false
                ? _uploadResults(account)
                : () {},
          )
        ],
      ),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: TextField(
              controller: _controller,
              // textInputAction: TextInputAction.done,
              autofocus: true,
              maxLines: 10,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(color: Culi.black),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  helperMaxLines: 2,
                  hintText:
                      'Briefly explain what happened. How do you reproduce the issue?'),
              onChanged: (text) {
                setState(() {});
                widget.feedback.description = text;
              },
            ),
          ),
        ),
        Image.file(
          widget.feedback.imageFile,
          height: size.height * 0.15,
          width: size.width * 0.15,
          alignment: Alignment.centerLeft,
          fit: BoxFit.fitHeight,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            return Padding(
              padding: EdgeInsets.all(8.0),
              child: child,
            );
          },
        ),
      ]),
    );
  }
}
