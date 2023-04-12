import 'package:flutter/material.dart';
import 'package:progressbar/widgets/custom_text.dart';

class DialogContainer extends StatelessWidget {
  final String? startTitle;
  final String? endTitle;
  final IconData? icon;
  final bool twoButtonActionEnable;
  final bool withButton;
  final Function()? startAction;
  final Function()? endAction;
  final Widget content;

  const DialogContainer({
    super.key,
    this.twoButtonActionEnable = false,
    this.startTitle,
    this.endTitle,
    this.icon = Icons.update,
    this.startAction,
    this.endAction,
    required this.content,
    this.withButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
        return false;
      },
      child: Center(
        child: SingleChildScrollView(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Center(
            child: Stack(
              alignment: Alignment.topCenter,
              clipBehavior: Clip.hardEdge,
              children: <Widget>[
                IntrinsicHeight(
                  child: Container(
                    width: 240,
                    constraints: const BoxConstraints(
                        minHeight: double.minPositive, maxHeight: 600),
                    // Bottom rectangular box
                    margin: const EdgeInsets.only(
                        top: 30), // to push the box half way below circle
                    decoration: BoxDecoration(
                      color: const Color(0xff2C3F64),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const SizedBox(
                          height: 34,
                        ),
                        Expanded(
                          child: Material(
                            color: Colors.transparent,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: content,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        withButton
                            ? twoButtonActionEnable
                                ? SizedBox(
                                    height: 40,
                                    width: double.infinity,
                                    child: Column(
                                      children: [
                                        TwoButton(
                                          endAction: endAction ?? () {},
                                          startAction: startAction ?? () {},
                                          endText: endTitle ?? 'No',
                                          startText: startTitle ?? 'Yes',
                                        ),
                                      ],
                                    ),
                                  )
                                : SizedBox(
                                    height: 40,
                                    child: OneButton(
                                      text: startTitle ?? 'Yes',
                                      action: startAction ?? () {},
                                    ),
                                  )
                            : Container()
                      ],
                    ),
                  ),
                ),
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    backgroundColor: const Color(0xff2C3F64),
                    radius: 26,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(icon ?? Icons.update),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TwoButton extends StatelessWidget {
  const TwoButton({
    Key? key,
    required this.startText,
    required this.endText,
    required this.startAction,
    required this.endAction,
  }) : super(key: key);

  final String startText;
  final String endText;
  final Function() startAction;
  final Function() endAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: const BoxDecoration(
        color: Color(0xff4C5A7D),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12.0),
          bottomRight: Radius.circular(12.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: TextButton(
              onPressed: startAction,
              child: CustomText(text: startText),
            ),
          ),
          Container(
            color: const Color(0xff2C3F64),
            width: 1,
          ),
          Expanded(
            child: TextButton(
              onPressed: endAction,
              child: CustomText(text: endText),
            ),
          ),
        ],
      ),
    );
  }
}

class OneButton extends StatelessWidget {
  const OneButton({
    Key? key,
    required this.text,
    required this.action,
  }) : super(key: key);

  final String text;
  final Function() action;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: const BoxDecoration(
        color: Color(0xff4C5A7D),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12.0),
          bottomRight: Radius.circular(12.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: TextButton(
              onPressed: action,
              child: CustomText(text: text),
            ),
          ),
        ],
      ),
    );
  }
}
