class GodWord {
  final int id;
  final String word;

  GodWord({
    this.id,
    this.word,
  });

  factory GodWord.fromMap(Map<String, dynamic> data) => GodWord(
        id: data['id'],
        word: data['word'],
      );

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'word': this.word,
    };

    if (id != null) map['id'] = id;

    return map;
  }
}
