String shortenNumber(int value) {
  if (value > 999) {
    String valueWithPrecision = (value / 1000).toStringAsPrecision(2);

    return valueWithPrecision.contains('e')
        ? '${valueWithPrecision.replaceRange(valueWithPrecision.indexOf('e'), null, '')}K'
        : '${valueWithPrecision}K';
  }

  if (value > 999999) {
    String valueWithPrecision = (value / 1000000).toStringAsPrecision(2);

    return valueWithPrecision.contains('e')
        ? '${valueWithPrecision.replaceRange(valueWithPrecision.indexOf('e'), null, '')}M'
        : '${valueWithPrecision}M';
  }

  if (value > 999999999) {
    String valueWithPrecision = (value / 1000000000).toStringAsPrecision(2);

    return valueWithPrecision.contains('e')
        ? '${valueWithPrecision.replaceRange(valueWithPrecision.indexOf('e'), null, '')}B'
        : '${valueWithPrecision}B';
  }

  return value.toString();
}
