import 'package:beans/generated/r.dart';
import 'package:beans/provider/accepted_challenge_provider.dart';
import 'package:beans/provider/challenge_provider.dart';
import 'package:beans/provider/finished_challenge_provider.dart';
import 'package:beans/provider/new_challenge_provider.dart';
import 'package:beans/value/styles.dart';
import 'package:beans/widget/challenge/accepted_challenge.dart';
import 'package:beans/widget/challenge/finished_challenge.dart';
import 'package:beans/widget/challenge/new_challenge.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChallengeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ChallengeProvider>(builder: (context, challenge, child) {
      Widget currentChallengeView;

      switch (challenge.state) {
        case ChallengeState.loading:
          currentChallengeView = Container(
            margin: EdgeInsets.only(top: 8),
            padding: EdgeInsets.all(8),
            child: CircularProgressIndicator(),
          );
          break;
        case ChallengeState.newChallenge:
          currentChallengeView = ChangeNotifierProvider<NewChallengeProvider>(
            create: (_) => NewChallengeProvider(challenge),
            child: NewChallenge(),
          );
          break;
        case ChallengeState.acceptedChallenge:
          currentChallengeView =
              ChangeNotifierProvider<AcceptedChallengeProvider>(
            create: (_) => AcceptedChallengeProvider(challenge),
            child: AcceptedChallenge(),
          );
          break;
        case ChallengeState.finishedChallenge:
          currentChallengeView =
              ChangeNotifierProvider<FinishedChallengeProvider>(
            create: (_) => FinishedChallengeProvider(challenge),
            child: FinishedChallenge(),
          );

          break;
      }

      return Column(
        children: [
          SizedBox(height: 30),
          titleChallenge(),
          currentChallengeView,
        ],
      );
    });
  }

  Widget titleChallenge() => RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: Styles.headingPurple,
          children: [
            TextSpan(text: 'Thử thách 24 giờ  '),
            WidgetSpan(
              child: Image(
                image: AssetImage(R.tooltip),
                height: 28,
                width: 28,
              ),
            ),
          ],
        ),
      );
}
