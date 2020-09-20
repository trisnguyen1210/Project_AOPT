enum AgeRange { from12To17, from18To40, gt40 }

extension ParseToString on AgeRange {
  String toShortString() {
    switch (this) {
      case AgeRange.from12To17:
        return '12 - 17';
      case AgeRange.from18To40:
        return '18 - 40';
      case AgeRange.gt40:
        return 'Trên 40';
      default:
        return '';
    }
  }
}

extension ParseToAgeRange on String {
  AgeRange toAgeRange() {
    if (this == '12 - 17') {
      return AgeRange.from12To17;
    } else if (this == '18 - 40') {
      return AgeRange.from18To40;
    } else if (this == 'Trên 40') {
      return AgeRange.gt40;
    }

    return AgeRange.from12To17;
  }
}

class User {
  final int id;
  int currentChallengeLogId;
  int greenCount = 0;
  int blackCount = 0;
  String name;
  String pin;
  AgeRange ageRange;
  DateTime timeLeftForChallenge;

  User({
    this.id,
    this.currentChallengeLogId,
    this.name,
    this.pin,
    this.ageRange,
    this.timeLeftForChallenge,
    greenCount,
    blackCount,
  });

  factory User.fromMap(Map<String, dynamic> data) {
    var user = User(
      id: data['id'],
      currentChallengeLogId: data['current_challenge_log_id'],
      greenCount: data['green_count'],
      blackCount: data['black_count'],
      name: data['name'],
      pin: data['pin'],
      ageRange: data['from_range']?.toAgeRange() ?? AgeRange.from18To40,
    );

    if (data['time_left_for_challenge'] != null) {
      user.timeLeftForChallenge =
          DateTime.tryParse(data['time_left_for_challenge']);
    }

    return user;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'current_challenge_log_id': this.currentChallengeLogId,
      'green_count': this.greenCount,
      'black_count': this.blackCount,
      'name': this.name,
      'pin': this.pin,
      'age_range': this.ageRange.toShortString(),
      'time_left_for_challenge': this.timeLeftForChallenge?.toIso8601String(),
    };

    if (id != null) map['id'] = id;

    return map;
  }
}
