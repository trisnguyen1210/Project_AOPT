import 'package:beans/dao/challenge_dao.dart';
import 'package:beans/dao/challenge_log_dao.dart';
import 'package:beans/dao/user_dao.dart';
import 'package:beans/model/challenge.dart';
import 'package:beans/model/challenge_log.dart';
import 'package:beans/provider/challenge_provider.dart';
import 'package:flutter/material.dart';

class NewChallengeProvider with ChangeNotifier {
  final ChallengeProvider challengeProvider;

  String get challengeName => _currentChallenge?.name ?? '';

  Challenge _currentChallenge;

  var showAlert = false;

  final _userDao = UserDao();
  final _challengeDao = ChallengeDao();
  final _challengeLogDao = ChallengeLogDao();

  NewChallengeProvider(this.challengeProvider) {
    _fetchChallenge();
  }

  acceptChallenge() async {
    final challengeLog = ChallengeLog(
      challengeId: _currentChallenge.id,
      isDone: false,
      createdAt: DateTime.now(),
    );

    final createdChallengeLogID = await _challengeLogDao.create(challengeLog);

    final user = await _userDao.getOrCreate();

    user.currentChallengeLogId = createdChallengeLogID;
    await _userDao.update(user);

    challengeProvider.state = ChallengeState.acceptedChallenge;
  }

  getOtherChallenge() async {
    _currentChallenge = await _challengeDao.getRandom();
    notifyListeners();
  }

  _fetchChallenge() async {
    final user = await _userDao.getOrCreate();

    if (user.currentChallengeLogId != null) {
      final currentChallengeLog =
          await _challengeLogDao.get(user.currentChallengeLogId);
      if (!currentChallengeLog.isDone) {
        showAlert = true;
        user.currentChallengeLogId = null;
        _userDao.update(user);
      }
    }

    _currentChallenge = await _challengeDao.getRandom();

    notifyListeners();
  }
}
