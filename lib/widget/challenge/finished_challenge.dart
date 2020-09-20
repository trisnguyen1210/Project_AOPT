import 'package:beans/generated/r.dart';
import 'package:beans/provider/finished_challenge_provider.dart';
import 'package:beans/value/styles.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class FinishedChallenge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        congratText(),
        congratImage(),
        finishedChallengeText(),
        waitText(),
      ],
    );
  }

  Widget congratImage() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: SvgPicture.asset(
        R.ic_congratulation,
        width: 60,
        height: 60,
      ),
    );
  }

  Widget congratText() {
    return Padding(
      padding: const EdgeInsets.only(left: 84, right: 84, top: 16),
      child: Text(
        'Chúc mừng bạn đã hoàn thành thử thách',
        style: Styles.textStyleGreyMedium,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget finishedChallengeText() => Consumer<FinishedChallengeProvider>(
        builder: (context, challenge, child) => Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: Text(
            challenge.name,
            style: Styles.textStyleStrike,
            textAlign: TextAlign.center,
          ),
        ),
      );

  Widget waitText() => Consumer<FinishedChallengeProvider>(
        builder: (context, challenge, child) => Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: Text(
            'Chờ ${challenge.minutesLeft}:${challenge.secondsLeft} nữa để tìm thử thách mới',
            style: Styles.bodyGrey,
            textAlign: TextAlign.center,
          ),
        ),
      );
}
