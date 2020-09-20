class DiffDate {
  final int days;
  final int hours;
  final int min;
  final int sec;

  DiffDate({this.days, this.hours, this.min, this.sec});

  factory DiffDate.fromEndTime(DateTime endTime) {
    if (endTime == null) return null;

    int diff = ((endTime.millisecondsSinceEpoch -
                DateTime.now().millisecondsSinceEpoch) /
            1000)
        .floor();
    if (diff < 0) {
      return null;
    }
    int days, hours, min, sec = 0;
    if (diff >= 86400) {
      days = (diff / 86400).floor();
      diff -= days * 86400;
    } else {
      // if days = -1 => Don't show;
      days = -1;
    }
    if (diff >= 3600) {
      hours = (diff / 3600).floor();
      diff -= hours * 3600;
    } else {
//      hours = days == -1 ? -1 : 0;
      hours = 0;
    }
    if (diff >= 60) {
      min = (diff / 60).floor();
      diff -= min * 60;
    } else {
//      min = hours == -1 ? -1 : 0;
      min = 0;
    }
    sec = diff.toInt();
    return DiffDate(days: days, hours: hours, min: min, sec: sec);
  }
}
