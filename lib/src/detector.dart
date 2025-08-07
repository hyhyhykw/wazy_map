import 'dart:convert';

class StandardScaleGestureDetector {
  double currentSpan;
  double currentSpanX;
  double currentSpanY;

  double previousSpan;
  double previousSpanX;
  double previousSpanY;

  double startSpan;
  double startSpanX;
  double startSpanY;

  StandardScaleGestureDetector({
    required this.currentSpan,
    required this.currentSpanX,
    required this.currentSpanY,
    required this.previousSpan,
    required this.previousSpanX,
    required this.previousSpanY,
    required this.startSpan,
    required this.startSpanX,
    required this.startSpanY,
  });

  factory StandardScaleGestureDetector.fromJson(Map<String, dynamic> json) {
    return StandardScaleGestureDetector(
      currentSpan: json['currentSpan'],
      currentSpanX: json['currentSpanX'],
      currentSpanY: json['currentSpanY'],
      previousSpan: json['previousSpan'],
      previousSpanX: json['previousSpanX'],
      previousSpanY: json['previousSpanY'],
      startSpan: json['startSpan'],
      startSpanX: json['startSpanX'],
      startSpanY: json['startSpanY'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "currentSpan": currentSpan,
      "currentSpanX": currentSpanX,
      "currentSpanY": currentSpanY,
      "previousSpan": previousSpan,
      "previousSpanX": previousSpanX,
      "previousSpanY": previousSpanY,
      "startSpan": startSpan,
      "startSpanX": startSpanX,
      "startSpanY": startSpanY,
    };
  }

  @override
  String toString() {
    return jsonEncode(this);
  }
}
