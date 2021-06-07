import 'package:beans/provider/accepted_challenge_provider.dart';
import 'package:beans/provider/auth_provider.dart';
import 'package:beans/value/gradient.dart';
import 'package:beans/value/styles.dart';

import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:provider/provider.dart';

class AcceptedChallenge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final challenge =
        Provider.of<AcceptedChallengeProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 16),
        countdown(),
        SizedBox(height: 6),
        acceptedChallengeText(),
        SizedBox(height: 24),
        buttonFinish(() {
          authProvider.updateGreenBean(authProvider.greenCount + 2);
          challenge.finishChallenge();
        }),
      ],
    );
  }

  Widget countdown() => Column(
        children: [
          timeLeftText(),
          SizedBox(height: 4),
          countdownText(),
        ],
      );

  Widget timeLeftText() => Text(
        'Bạn còn',
        style: Styles.bodyGrey,
      );

  Widget countdownText() => Consumer<AcceptedChallengeProvider>(
        builder: (context, challenge, child) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  '${challenge.hourLeft}',
                  style: Styles.textStyleLarge,
                ),
                Text(
                  'GIỜ',
                  style: Styles.textStyleBold,
                )
              ],
            ),
            Column(
              children: [
                Text(
                  challenge.blink ? ' : ' : '   ',
                  style: Styles.textStyleLarge,
                ),
                Text(
                  ' ',
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  '${challenge.minutesLeft}',
                  style: Styles.textStyleLarge,
                ),
                Text(
                  'PHÚT',
                  style: Styles.textStyleBold,
                )
              ],
            )
          ],
        ),
      );

  Widget acceptedChallengeText() => Consumer<AcceptedChallengeProvider>(
        builder: (context, challenge, child) => Text(
          'Để ${challenge.name}',
          style: Styles.bodyGrey,
          textAlign: TextAlign.center,
        ),
      );

  Widget buttonFinish(Function finishChallenge) => GradientButton(
        increaseWidthBy: 120,
        increaseHeightBy: 9.0,
        callback: finishChallenge,
        gradient: GradientApp.gradientButton,
        child: Text('Hoàn thành', style: Styles.buttonText),
      );
}
