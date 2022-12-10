enum ScreenSize {
  medium,
  large;

  int get width {
    switch (this) {
      case ScreenSize.medium:
        return 720;
      case ScreenSize.large:
        return 1080;
    }
  }
}
