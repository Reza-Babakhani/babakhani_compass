import 'package:babakhani_compass/utils/num_extension.dart';

enum CompassDirection { N, NE, E, SE, S, SW, W, NW }

extension CompassDirectionExtension on CompassDirection {
  int get value {
    switch (this) {
      case CompassDirection.N:
        return 0;
      case CompassDirection.NE:
        return 45;
      case CompassDirection.E:
        return 90;
      case CompassDirection.SE:
        return 135;
      case CompassDirection.S:
        return 180;
      case CompassDirection.SW:
        return 225;
      case CompassDirection.W:
        return 270;
      case CompassDirection.NW:
        return 315;
      default:
        return 0;
    }
  }

  String get stringValue {
    switch (this) {
      case CompassDirection.N:
        return "N";
      case CompassDirection.NE:
        return "NE";
      case CompassDirection.E:
        return "E";
      case CompassDirection.SE:
        return "SE";
      case CompassDirection.S:
        return "S";
      case CompassDirection.SW:
        return "SW";
      case CompassDirection.W:
        return "W";
      case CompassDirection.NW:
        return "NW";
      default:
        return "N";
    }
  }
}

class CompassHelper {
  static const double _mid = 22.5;
  static CompassDirection degToCompassDirection(double direction) {
    if (direction.isBetween(
        CompassDirection.NE.value - _mid, CompassDirection.NE.value + _mid)) {
      return CompassDirection.NE;
    } else if (direction.isBetween(
        CompassDirection.E.value - _mid, CompassDirection.E.value + _mid)) {
      return CompassDirection.E;
    } else if (direction.isBetween(
        CompassDirection.SE.value - _mid, CompassDirection.SE.value + _mid)) {
      return CompassDirection.SE;
    } else if (direction.isBetween(
        CompassDirection.S.value - _mid, CompassDirection.S.value + _mid)) {
      return CompassDirection.S;
    } else if (direction.isBetween(
        CompassDirection.SW.value - _mid, CompassDirection.SW.value + _mid)) {
      return CompassDirection.SW;
    } else if (direction.isBetween(
        CompassDirection.W.value - _mid, CompassDirection.W.value + _mid)) {
      return CompassDirection.W;
    } else if (direction.isBetween(
        CompassDirection.NW.value - _mid, CompassDirection.NW.value + _mid)) {
      return CompassDirection.NW;
    } else {
      return CompassDirection.N;
    }
  }

  static String accuracyToString(double accuracy) {
    return accuracy == 15
        ? "low"
        : accuracy == 30
            ? "normal"
            : accuracy == 45
                ? "good"
                : "unknown";
  }
}
