import '../models/weight_status_enum.dart';

String weightStatusToString(Status status) {
  if (status == Status.severlyUnderweight) {
    return "SEVERLYUNDERWEIGHT";
  } else if (status == Status.underweight) {
    return "UNDERWEIGHT";
  } else if (status == Status.normal) {
    return "NORMAL";
  }
  return "OVERWEIGHT";
}
