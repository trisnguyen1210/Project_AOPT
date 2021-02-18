import 'dart:async';

import 'package:beans/dao/challenge_dao.dart';
import 'package:beans/dao/challenge_log_dao.dart';
import 'package:beans/dao/user_dao.dart';
import 'package:beans/model/challenge.dart';
import 'package:beans/model/user.dart';
import 'package:beans/utils/diff_date.dart';
import 'package:beans/utils/utils.dart';
import 'package:flutter/material.dart';

import 'challenge_provider.dart';

class AcceptedChallengeProvider with ChangeNotifier {
  final ChallengeProvider challengeProvider;

  // Blink: blink the ':' every second
  var blink = false;

  int _hoursLeft = 0;
  String get hourLeft => Utils.getNumberAddZero(_hoursLeft);

  int _minutesLeft = 0;
  String get minutesLeft => Utils.getNumberAddZero(_minutesLeft);

  String get name => _currentChallenge?.name ?? '';

  Challenge _currentChallenge;
  Timer _diffTimer;
  User _user;

  final _userDao = UserDao();
  final _challengeDao = ChallengeDao();
  final _challengeLogDao = ChallengeLogDao();

  AcceptedChallengeProvider(this.challengeProvider) {
    _fetchChallenge();
  }

  void dispose() {
    super.dispose();
    _disposeDiffTimer();
  }

  _fetchChallenge() async {
    _user = await _userDao.getOrCreate();
    final currentChallengeLog =
        await _challengeLogDao.get(_user.currentChallengeLogId);
    _currentChallenge =
        await _challengeDao.get(currentChallengeLog.challengeId);

    _countdown(currentChallengeLog.dueAt);
  }

  finishChallenge() async {
    _disposeDiffTimer();

    if (_user == null) {
      _user = await _userDao.getOrCreate();
    }

    var challengeLog = await _challengeLogDao.get(_user.currentChallengeLogId);
    challengeLog.isDone = true;

    await _challengeLogDao.update(challengeLog);

    // Start countdown for accepting new challenge
    _user.timeLeftForChallenge = DateTime.now().add(Duration(hours: 24));

    // Increase the green beans
    _user.greenCount += 2;

    _userDao.update(_user);

    challengeProvider.state = ChallengeState.finishedChallenge;
  }

  _updateCountDownTime(DiffDate time) {
    _hoursLeft = time.hours;
    _minutesLeft = time.min;
    blink = !blink;
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
    if (data.days == -1 && data.hours == 0 && data.min == 0 && data.sec == 0) {
      _disposeDiffTimer();

      _user.currentChallengeLogId = null;

      await _userDao.update(_user);

      challengeProvider.state = ChallengeState.newChallenge;
    }
  }
}
