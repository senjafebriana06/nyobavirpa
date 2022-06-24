import 'package:nyobavirpa/models/gender_enum.dart';
import 'package:nyobavirpa/models/weight_status_enum.dart';

Status weightStatus(
    {required double weight, required int age, required Gender gender}) {
  Status status;
  if (gender == Gender.L) {
    switch (age) {
      case 0:
        if (weight < 2.1) {
          status = Status.severlyUnderweight;
        } else if (weight <= 2.4) {
          status = Status.underweight;
        } else if (weight <= 3.9) {
          status = Status.normal;
        } else {
          status = Status.overweight;
        }
        break;
      case 1:
        if (weight < 2.9) {
          status = Status.severlyUnderweight;
        } else if (weight <= 3.3) {
          status = Status.underweight;
        } else if (weight <= 5.1) {
          status = Status.normal;
        } else {
          status = Status.overweight;
        }
        break;
      case 2:
        if (weight < 3.8) {
          status = Status.severlyUnderweight;
        } else if (weight <= 4.2) {
          status = Status.underweight;
        } else if (weight <= 6.3) {
          status = Status.normal;
        } else {
          status = Status.overweight;
        }
        break;
      case 3:
        if (weight < 4.4) {
          status = Status.severlyUnderweight;
        } else if (weight <= 4.9) {
          status = Status.underweight;
        } else if (weight <= 7.2) {
          status = Status.normal;
        } else {
          status = Status.overweight;
        }
        break;
      case 4:
        if (weight < 4.9) {
          status = Status.severlyUnderweight;
        } else if (weight <= 5.5) {
          status = Status.underweight;
        } else if (weight <= 7.8) {
          status = Status.normal;
        } else {
          status = Status.overweight;
        }
        break;
      case 5:
        if (weight < 5.3) {
          status = Status.severlyUnderweight;
        } else if (weight <= 5.9) {
          status = Status.underweight;
        } else if (weight <= 8.4) {
          status = Status.normal;
        } else {
          status = Status.overweight;
        }
        break;
      case 6:
        if (weight < 5.7) {
          status = Status.severlyUnderweight;
        } else if (weight <= 6.3) {
          status = Status.underweight;
        } else if (weight <= 8.8) {
          status = Status.normal;
        } else {
          status = Status.overweight;
        }
        break;
      case 7:
        if (weight < 5.9) {
          status = Status.severlyUnderweight;
        } else if (weight <= 6.6) {
          status = Status.underweight;
        } else if (weight <= 9.2) {
          status = Status.normal;
        } else {
          status = Status.overweight;
        }
        break;
      case 8:
        if (weight < 6.2) {
          status = Status.severlyUnderweight;
        } else if (weight <= 6.8) {
          status = Status.underweight;
        } else if (weight <= 9.6) {
          status = Status.normal;
        } else {
          status = Status.overweight;
        }
        break;
      case 9:
        if (weight < 6.4) {
          status = Status.severlyUnderweight;
        } else if (weight <= 7.0) {
          status = Status.underweight;
        } else if (weight <= 9.9) {
          status = Status.normal;
        } else {
          status = Status.overweight;
        }
        break;
      case 10:
        if (weight < 6.6) {
          status = Status.severlyUnderweight;
        } else if (weight <= 7.4) {
          status = Status.underweight;
        } else if (weight <= 10.2) {
          status = Status.normal;
        } else {
          status = Status.overweight;
        }
        break;
      case 11:
        if (weight < 6.8) {
          status = Status.severlyUnderweight;
        } else if (weight <= 7.6) {
          status = Status.underweight;
        } else if (weight <= 10.5) {
          status = Status.normal;
        } else {
          status = Status.overweight;
        }
        break;
      case 12:
        if (weight < 6.9) {
          status = Status.severlyUnderweight;
        } else if (weight <= 7.6) {
          status = Status.underweight;
        } else if (weight <= 10.8) {
          status = Status.normal;
        } else {
          status = Status.overweight;
        }
        break;
      case 13:
        if (weight < 7.1) {
          status = Status.severlyUnderweight;
        } else if (weight <= 7.9) {
          status = Status.underweight;
        } else if (weight <= 11.0) {
          status = Status.normal;
        } else {
          status = Status.overweight;
        }
        break;
      case 14:
        if (weight < 7.2) {
          status = Status.severlyUnderweight;
        } else if (weight <= 8.0) {
          status = Status.underweight;
        } else if (weight <= 11.3) {
          status = Status.normal;
        } else {
          status = Status.overweight;
        }
        break;
      case 15:
        if (weight < 7.4) {
          status = Status.severlyUnderweight;
        } else if (weight <= 8.2) {
          status = Status.underweight;
        } else if (weight <= 11.5) {
          status = Status.normal;
        } else {
          status = Status.overweight;
        }
        break;
      case 16:
        if (weight < 7.5) {
          status = Status.severlyUnderweight;
        } else if (weight <= 8.3) {
          status = Status.underweight;
        } else if (weight <= 11.7) {
          status = Status.normal;
        } else {
          status = Status.overweight;
        }
        break;
      case 17:
        if (weight < 7.7) {
          status = Status.severlyUnderweight;
        } else if (weight <= 8.5) {
          status = Status.underweight;
        } else if (weight <= 12.0) {
          status = Status.normal;
        } else {
          status = Status.overweight;
        }
        break;
      case 18:
        if (weight < 7.8) {
          status = Status.severlyUnderweight;
        } else if (weight <= 8.7) {
          status = Status.underweight;
        } else if (weight <= 12.2) {
          status = Status.normal;
        } else {
          status = Status.overweight;
        }
        break;
      case 19:
        if (weight < 8.0) {
          status = Status.severlyUnderweight;
        } else if (weight <= 8.8) {
          status = Status.underweight;
        } else if (weight <= 12.5) {
          status = Status.normal;
        } else {
          status = Status.overweight;
        }
        break;
      case 20:
        if (weight < 8.1) {
          status = Status.severlyUnderweight;
        } else if (weight <= 9.0) {
          status = Status.underweight;
        } else if (weight <= 12.7) {
          status = Status.normal;
        } else {
          status = Status.overweight;
        }
        break;
      default:
        return Status.normal;
    }
  } else {
    switch (age) {
      case 0:
        if (weight < 2.0) {
          status = Status.severlyUnderweight;
        } else if (weight <= 2.3) {
          status = Status.underweight;
        } else if (weight <= 3.7) {
          status = Status.normal;
        } else {
          status = Status.overweight;
        }
        break;
      default:
        return Status.normal;
    }
  }
  return status;
}
