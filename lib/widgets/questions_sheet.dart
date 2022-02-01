import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomSheetWidget extends StatelessWidget{
  final String title;
  final VoidCallback onClickedYes;
  final VoidCallback onClickedNo;

  const BottomSheetWidget({
    required this.title,
    required this.onClickedYes,
    required this.onClickedNo,
    required Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                child: Text('No'),
                onPressed: onClickedNo,
              ),
              const SizedBox(width: 32),
              RaisedButton(
                child: Text('Yes'),
                onPressed: onClickedYes,
              ),
            ],
          ),
        ],
      ),
    );
  }

}