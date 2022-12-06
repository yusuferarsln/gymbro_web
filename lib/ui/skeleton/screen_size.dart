enum ScreenSize {
  small,
  medium,
  large;

  int get width {
    switch (this) {
      case ScreenSize.small:
        return 360;
      case ScreenSize.medium:
        return 720;
      case ScreenSize.large:
        return 1080;
    }
  }
}
