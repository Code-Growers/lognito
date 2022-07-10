import 'package:flutter/material.dart';
import 'package:lognito/src/buffer/filtered_buffer.dart';
import 'package:lognito/src/filter/development_filter.dart';
import 'package:lognito/src/formatter/pretty_formatter.dart';
import 'package:lognito/src/lognito.dart';
import 'package:lognito/src/output/console_output.dart';

void main() {
  runApp(Main());
}

// Init the Lognito
final Lognito lognito = Lognito.init(
    buffer: FilteredBuffer([ConsoleOutput(formatter: PrettyFormatter())],
        filter: DevelopmentFilter(Level.info)));

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (BuildContext context, _) => Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    lognito.e('Oh no, something happend');
                  },
                  child: Text('Error log'),
                ),
                TextButton(
                  onPressed: () {
                    lognito.w('I warn you, Lognito is addictive');
                  },
                  child: Text('Warning log'),
                ),
                TextButton(
                  onPressed: () {
                    lognito.i('I am happy to inform Lognito is working');
                  },
                  child: Text('Info log'),
                ),
                TextButton(
                  onPressed: () {
                    lognito.d('This debug will never see light of the console');
                  },
                  child: Text('Debug log, will not be logged'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
