double remap(double value, double min, double max, double targetMin, double targetMax) {
  double clampedValue = value.clamp(min, max);
  return targetMin + ((clampedValue - min) / (max - min)) * (targetMax - targetMin);
}