import 'dart:async';

import 'package:beans/dao/challenge_dao.dart';
import 'package:beans/dao/challenge_log_dao.dart';
import 'package:beans/dao/user_dao.dart';
import 'package:beans/model/challenge.dart';
import 'package:beans/model/user.dart';
import 'package:beans/provider/challenge_provider.dart';
import 'package:beans/utils/diff_date.dart';
import 'package:beans/utils/utils.dart';
import 'package:flutter/material.dart';

class FinishedChallengeProvider with ChangeNotifier {
  final ChallengeProvider challengeProvider;

  int _secondsLeft = 00;
  String get secondsLeft => Utils.getNumberAddZero(_secondsLeft);


  int _minutesLeft = 00;
  String get minutesLeft => Utils.getNumberAddZero(_minutesLeft);

  int _hoursLeft = 00;
  String get hoursLeft => Utils.getNumberAddZero(_hoursLeft);
  String get name => _currentChallenge?.name ?? '';

  Challenge _currentChallenge;
  Timer _diffTimer;
  User _user;

  final _userDao = UserDao();
  final _challengeDao = ChallengeDao();
  final _challengeLogDao = ChallengeLogDao();

  FinishedChallengeProvider(this.challengeProvider) {
    _fetchChallenge();
  }

  void dispose() {
    super.dispose();
    _disposeDiffTimer();
  }

  _fetchChallenge() async {
    _user = await _userDao.getOrCreate();
    final currentChallengeLog = await _challengeLogDao.getLatest();
    _currentChallenge =
        await _challengeDao.get(currentChallengeLog.challengeId);

    _countdown(_user.timeLeftForChallenge);
  }

  _updateCountDownTime(DiffDate time) {
    _hoursLeft   = time.hours;
    _minutesLeft = time.min;
    _secondsLeft = time.sec;
    notifyListeners();
  }

  _countdown(DateTime endTime) {
    final data = DiffDate.fromEndTime(endTime);
    if (data != null) {
      _updateCountDownTime(data);
    } else {
      return null;
    }

    _disposeDiffTimer();

    const period = const Duration(seconds: 1);
    _diffTimer = Timer.periodic(period, (timer) {
      final data = DiffDate.fromEndTime(endTime);
      if (data != null) {
        _updateCountDownTime(data);
        _checkDateEnd(data);
      } else {
        _disposeDiffTimer();
      }
    });
  }

  _disposeDiffTimer() {
    _diffTimer?.cancel();
    _diffTimer = null;
  }

  _checkDateEnd(DiffDate data) async {
    if (data.days == -1 && data.hours == 00 && data.min == 00 && data.sec == 00) {
      _disposeDiffTimer();

      final user = await _userDao.getOrCreate();

      user.currentChallengeLogId = null;

      await _userDao.update(user);

      challengeProvider.state = ChallengeState.newChallenge;
    }
  }
}
