String _toKatakana(String input) {
  final buffer = StringBuffer();
  for (final code in input.runes) {
    if (code >= 0x3041 && code <= 0x3096) {
      buffer.writeCharCode(code + 0x60);
    } else {
      buffer.writeCharCode(code);
    }
  }
  return buffer.toString();
}

String normalizeText(String input) {
  var s = input.toLowerCase();
  s = s.replaceAll(RegExp(r'\s+'), '');
  s = _toKatakana(s);
  return s;
}

int _levenshtein(String s, String t) {
  if (s == t) return 0;
  if (s.isEmpty) return t.length;
  if (t.isEmpty) return s.length;

  final v0 = List<int>.generate(t.length + 1, (i) => i);
  final v1 = List<int>.filled(t.length + 1, 0);

  for (var i = 0; i < s.length; i++) {
    v1[0] = i + 1;
    for (var j = 0; j < t.length; j++) {
      final cost = s[i] == t[j] ? 0 : 1;
      v1[j + 1] = [
        v1[j] + 1,
        v0[j + 1] + 1,
        v0[j] + cost,
      ].reduce((a, b) => a < b ? a : b);
    }
    for (var j = 0; j <= t.length; j++) {
      v0[j] = v1[j];
    }
  }
  return v1[t.length];
}

double stringSimilarity(String a, String b) {
  final na = normalizeText(a);
  final nb = normalizeText(b);
  final dist = _levenshtein(na, nb);
  final maxLen = na.length > nb.length ? na.length : nb.length;
  return maxLen == 0 ? 1.0 : 1.0 - dist / maxLen;
}

bool isSimilar(String a, String b, {double threshold = 0.8}) {
  final na = normalizeText(a);
  final nb = normalizeText(b);
  if (na.contains(nb) || nb.contains(na)) {
    return true;
  }
  return stringSimilarity(na, nb) >= threshold;
}
