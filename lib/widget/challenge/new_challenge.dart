import 'package:beans/generated/r.dart';
import 'package:beans/provider/new_challenge_provider.dart';
import 'package:beans/value/gradient.dart';
import 'package:beans/value/styles.dart';
import 'package:beans/widget/dialog/popup_dialog.dart';

import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:provider/provider.dart';

class NewChallenge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final challenge = Provider.of<NewChallengeProvider>(context);

    if (challenge.showAlert) {
      Future.delayed(Duration.zero, () => showAlert(context, challenge));
    }

    return Column(
      children: [
        SizedBox(height: 30),
        challengeText(challenge.challengeName),
        SizedBox(height: 16),
        buttonChallenge(challenge.acceptChallenge),
        SizedBox(height: 16),
        anotherChallengeText(challenge.getOtherChallenge),
      ],
    );
  }

  void showAlert(BuildContext context, NewChallengeProvider challenge) async {
    await showDialog(
      context: context,
      child: PopupDialog(
        image: R.ic_expired,
        message:
            'Đã quá 24 giờ, thử thách của ban đã hết hạn. Nhưng không sao, bạn hãy chấp nhận 1 thử thách mới!',
      ),
    ).then((value) => challenge.showAlert = false);
  }

  Widget challengeText(String name) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          '"$name"',
          style: Styles.textStyleRelation,
          textAlign: TextAlign.center,
        ),
      );

  Widget buttonChallenge(Function acceptChallenge) => GradientButton(
        increaseWidthBy: 120,
        increaseHeightBy: 7.0,
        elevation: 0,
        callback: acceptChallenge,
        gradient: GradientApp.gradientButton,
        child: Text("Chấp nhận thử thách", style: Styles.buttonText),
      );

  Widget anotherChallengeText(Function getOtherChallenge) => InkWell(
        onTap: getOtherChallenge,
        child: Text(
          'Tìm thử thách khác',
          style: Styles.bodyBlueUnderline,
          textAlign: TextAlign.center,
        ),
      );
}
