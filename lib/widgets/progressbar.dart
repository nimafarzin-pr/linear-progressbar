import 'dart:async';

import 'package:flutter/material.dart';

typedef OnDone = Function()?;
typedef OnChange = Function(int percent)?;

enum ProgressMode { column, dot, rectangle, line }

class ProgressBar extends StatefulWidget {
  const ProgressBar({
    super.key,
    required this.maxCount,
    this.isProgress = true,
    this.color,
    this.onDone,
    this.onChange,
    this.progressMode,
    this.direction = Axis.horizontal,
  });
  final int maxCount;
  // to know increse or decrease process if set to true then increse and if not decrease
  final bool isProgress;
  final Color? color;
  final OnDone onDone;
  final OnChange onChange;
  final Axis direction;
  // to choose different type of progress
  final ProgressMode? progressMode;

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  StreamSubscription? _sub;
  StreamController<int> computationCount = StreamController.broadcast();
  int maxCount = 0;

  @override
  void initState() {
    maxCount = widget.maxCount;
    // if isProgress is false then use timer decrease logic
    if (widget.isProgress) {
      startProgress();
    } else {
      startTimer();
    }
    super.initState();
  }

  startTimer() {
    _sub?.cancel();
    _sub = Stream.periodic(const Duration(seconds: 1), (x) => maxCount - x - 1)
        .take(maxCount)
        .listen((event) {
      final data = (event / maxCount * 100).round();
      if (event > 0) {
        computationCount.sink.add(data);
      } else {
        computationCount.sink.add(data);
        if (widget.onDone != null) {
          widget.onDone!();
        }
      }
      if (widget.onChange != null) {
        widget.onChange!(data);
      }
    });
  }

  startProgress() {
    _sub?.cancel();
    _sub = Stream.periodic(const Duration(seconds: 1), (x) => x + 1)
        .take(maxCount)
        .listen((event) {
      final data = (event / maxCount * 100).round();
      if (event < maxCount) {
        computationCount.sink.add(data);
      } else {
        computationCount.sink.add(data);
        if (widget.onDone != null) {
          widget.onDone!();
        }
      }
      if (widget.onChange != null) {
        widget.onChange!(data);
      }
    });
  }

  @override
  void dispose() {
    computationCount.close();
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: computationCount.stream,
        builder: (context, snapshot) {
          final duration = snapshot.data ?? (widget.isProgress ? 0 : 100);
          if (widget.direction == Axis.vertical) {
            return MyProgressBarVertical(
              currentTime: duration,
              color: (widget.color ?? const Color(0xff0AFFEF)),
              progressMode: widget.progressMode,
            );
          } else {
            return MyProgressBarHorizontal(
              currentTime: duration,
              color: (widget.color ?? const Color(0xff0AFFEF)),
              progressMode: widget.progressMode,
            );
          }
        });
  }
}

class MyProgressBarHorizontal extends StatelessWidget {
  const MyProgressBarHorizontal(
      {super.key,
      required this.currentTime,
      required this.color,
      this.progressMode});
  final int currentTime;
  final Color color;
  final ProgressMode? progressMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: Colors.grey),
      ),
      height: 20,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 8),
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return SizedBox(
              width: constraints.maxWidth,
              child: IntrinsicWidth(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ProgressViewMode(
                              color: color,
                              constraints: constraints.maxWidth,
                              currentTime: currentTime,
                              index: index,
                              progressMode: progressMode),
                        ),
                      ],
                    );
                  },
                  itemCount: currentTime,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class MyProgressBarVertical extends StatelessWidget {
  const MyProgressBarVertical(
      {super.key,
      required this.currentTime,
      required this.color,
      this.progressMode});
  final int currentTime;
  final Color color;
  final ProgressMode? progressMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: Colors.grey),
      ),
      height: 300,
      width: 20,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 3),
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return SizedBox(
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              child: IntrinsicHeight(
                child: ListView.builder(
                  shrinkWrap: true,
                  reverse: true,
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ProgressViewMode(
                              color: color,
                              constraints: constraints.maxHeight,
                              currentTime: currentTime,
                              index: index,
                              progressMode: progressMode),
                        ),
                      ],
                    );
                  },
                  itemCount: currentTime,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class ProgressViewMode extends StatelessWidget {
  const ProgressViewMode(
      {super.key,
      this.progressMode = ProgressMode.column,
      required this.index,
      required this.color,
      required this.currentTime,
      required this.constraints});
  final int index;
  final Color color;
  final int currentTime;
  final double constraints;
  final ProgressMode? progressMode;

  @override
  Widget build(BuildContext context) {
    if (progressMode == ProgressMode.column) {
      return ProgressColumnMode(
        constraints: constraints,
        currentTime: currentTime,
        index: index,
        color: color,
      );
    } else if (progressMode == ProgressMode.rectangle) {
      return ProgressRectangleMode(
        constraints: constraints,
        currentTime: currentTime,
        index: index,
        color: color,
      );
    } else if (progressMode == ProgressMode.line) {
      return ProgressLineMode(
        constraints: constraints,
        currentTime: currentTime,
        index: index,
        color: color,
      );
    } else {
      return ProgressDotMode(
        constraints: constraints,
        currentTime: currentTime,
        index: index,
        color: color,
      );
    }
  }
}

class ProgressColumnMode extends StatelessWidget {
  const ProgressColumnMode(
      {super.key,
      required this.index,
      required this.color,
      required this.currentTime,
      required this.constraints});
  final int index;
  final Color color;
  final int currentTime;
  final double constraints;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: index.isEven ? color : Colors.transparent,
          boxShadow: [
            BoxShadow(
                blurRadius: 20,
                color: index.isEven ? color : Colors.transparent,
                spreadRadius: 0.2)
          ]),
      // margin: const EdgeInsets.symmetric(horizontal: 1),
      height: constraints / 99,
      width: constraints / 99,
    );
  }
}

class ProgressRectangleMode extends StatelessWidget {
  const ProgressRectangleMode(
      {super.key,
      required this.index,
      this.color,
      required this.currentTime,
      required this.constraints});
  final int index;
  final Color? color;
  final int currentTime;
  final double constraints;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(4),
          shape: BoxShape.rectangle,
          color: (color ?? const Color.fromARGB(255, 255, 108, 10)),
          boxShadow: [
            BoxShadow(
                blurRadius: 20,
                color: (color ?? const Color.fromARGB(255, 255, 108, 10)),
                spreadRadius: 0.2)
          ]),
      // margin: const EdgeInsets.symmetric(horizontal: 1),
      height: constraints / 99,
      width: constraints / 99,
    );
  }
}

class ProgressLineMode extends StatelessWidget {
  const ProgressLineMode(
      {super.key,
      required this.index,
      this.color,
      required this.currentTime,
      required this.constraints});
  final int index;
  final Color? color;
  final int currentTime;
  final double constraints;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(4),
          shape: BoxShape.circle,
          color: (color ?? const Color.fromARGB(255, 255, 108, 10)),
          boxShadow: [
            BoxShadow(
                blurRadius: 20,
                color: (color ?? const Color.fromARGB(255, 255, 108, 10)),
                spreadRadius: 0.2)
          ]),
      // margin: const EdgeInsets.symmetric(horizontal: 1),
      height: constraints / 99,
      width: constraints / 99,
    );
  }
}

class ProgressDotMode extends StatelessWidget {
  const ProgressDotMode(
      {super.key,
      required this.index,
      this.color,
      required this.currentTime,
      required this.constraints});
  final int index;
  final Color? color;
  final int currentTime;
  final double constraints;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          // borderRadius: BorderRadius.circular(4),
          color: index.isEven
              ? (color ?? const Color(0xff0AFFEF))
              : Colors.transparent,
          boxShadow: [
            BoxShadow(
                blurRadius: 20,
                color: index.isEven
                    ? (color ?? const Color(0xff0AFFEF))
                    : Colors.transparent,
                spreadRadius: 0.2)
          ]),
      // margin: const EdgeInsets.symmetric(horizontal: 1),
      height: constraints / 99,
      width: constraints / 99,
    );
  }
}
