class Either<L, R> {
  final L? _left;
  final R? _right;
  final bool _isLeft;

  const Either.left(L value)
      : _left = value,
        _right = null,
        _isLeft = true;

  const Either.right(R value)
      : _left = null,
        _right = value,
        _isLeft = false;

  bool get isLeft => _isLeft;
  bool get isRight => !_isLeft;
  L get left => _left as L;
  R get right => _right as R;

  T fold<T>(T Function(L) onLeft, T Function(R) onRight) {
    if (_isLeft) return onLeft(_left as L);
    return onRight(_right as R);
  }
}
