import 'package:flutter/material.dart';
import 'package:progressbar/widgets/custom_text.dart';
import 'package:progressbar/widgets/dialog_container.dart';
import 'package:progressbar/widgets/progressbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Home());
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final int maxCount = 10;
  int progress = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade800,
      appBar: AppBar(
        backgroundColor: Colors.deepOrange.shade400,
        title: const Text('My ProgressBar'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CustomText(
                  fontSize: 16,
                  text: 'Tap on floatingActionButton to see progress'),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ProgressBar(
                  color: Colors.yellow,
                  maxCount: maxCount,
                  progressMode: ProgressMode.column,
                  onChange: (percent) {
                    print(percent);
                  },
                ),
                ProgressBar(
                  color: Colors.blue,
                  maxCount: maxCount,
                  progressMode: ProgressMode.rectangle,
                ),
                ProgressBar(
                  color: Colors.red,
                  maxCount: maxCount,
                  progressMode: ProgressMode.dot,
                ),
                ProgressBar(
                  color: Colors.green,
                  maxCount: maxCount,
                  progressMode: ProgressMode.line,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ProgressBar(
                  color: Colors.white,
                  maxCount: maxCount,
                  direction: Axis.vertical,
                  progressMode: ProgressMode.column,
                ),
                ProgressBar(
                  color: Colors.orange,
                  maxCount: maxCount,
                  direction: Axis.vertical,
                  progressMode: ProgressMode.rectangle,
                ),
                ProgressBar(
                  color: Colors.purple,
                  maxCount: maxCount,
                  direction: Axis.vertical,
                  progressMode: ProgressMode.dot,
                ),
                ProgressBar(
                  color: Colors.pink,
                  maxCount: maxCount,
                  direction: Axis.vertical,
                  progressMode: ProgressMode.line,
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange.shade400,
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return StatefulBuilder(builder: (context, setState) {
                  return DialogContainer(
                    content: Column(
                      children: [
                        ProgressBar(
                          progressMode: ProgressMode.column,
                          maxCount: maxCount,
                          onChange: (percent) {
                            setState(() {
                              progress = percent;
                            });
                          },
                          isProgress: false,
                          onDone: () {
                            Navigator.pop(context);
                          },
                        ),
                        CustomText(text: progress.toString())
                      ],
                    ),
                    startAction: () {
                      setState(() {
                        progress = 0;
                      });
                      Navigator.pop(context);
                    },
                    startTitle: 'Cancel',
                  );
                });
              });
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
