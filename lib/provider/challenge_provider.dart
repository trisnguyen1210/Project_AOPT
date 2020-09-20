import 'package:beans/dao/challenge_log_dao.dart';
import 'package:beans/dao/user_dao.dart';
import 'package:beans/model/user.dart';
import 'package:flutter/material.dart';

enum ChallengeState {
  loading,
  newChallenge,
  acceptedChallenge,
  finishedChallenge
}

class ChallengeProvider with ChangeNotifier {
  // State: The challenge view state
  var _state = ChallengeState.loading;

  ChallengeState get state => _state;

  set state(ChallengeState value) {
    _state = value;
    notifyListeners();
  }

  User _user;

  final _userDao = UserDao();
  final _challengeLogDao = ChallengeLogDao();

  ChallengeProvider() {
    _fetchChallengeState();
  }

  _fetchChallengeState() async {
    _user = await _userDao.getOrCreate();

    // Don't accept challenge yet
    if (_user.currentChallengeLogId == null) {
      state = ChallengeState.newChallenge;
      return;
    }

    // Did finish challenge, and be waiting for new challenge
    if (_user.timeLeftForChallenge != null &&
        _user.timeLeftForChallenge.isAfter(DateTime.now())) {
      state = ChallengeState.finishedChallenge;
      return;
    }

    // Did finish challenge, and ready for new challenge
    if (_user.timeLeftForChallenge != null &&
        _user.timeLeftForChallenge.isBefore(DateTime.now())) {
      _user.currentChallengeLogId = null;
      await _userDao.update(_user);

      state = ChallengeState.newChallenge;
      return;
    }

    var currentChallengeLog =
        await _challengeLogDao.get(_user.currentChallengeLogId);

    // Doing challenge, start countdown
    if (_user.currentChallengeLogId != null &&
        !currentChallengeLog.isDone &&
        currentChallengeLog.dueAt.isAfter(DateTime.now())) {
      state = ChallengeState.acceptedChallenge;
      return;
    }

    // Did failed challenge, show popup
    if (_user.currentChallengeLogId != null &&
        !currentChallengeLog.isDone &&
        currentChallengeLog.dueAt.isBefore(DateTime.now())) {
      state = ChallengeState.newChallenge;
    }
  }
}
