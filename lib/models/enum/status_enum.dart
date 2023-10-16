// ignore_for_file: constant_identifier_names

enum Status { ACTIVE, ISOLATED, NONE }

Status getStatusFromString(String? dataStatus) {
  if (dataStatus == null || dataStatus.toUpperCase() == 'NONE') {
    return Status.NONE;
  }
  if (dataStatus.toUpperCase() == 'ACTIVE') {
    return Status.ACTIVE;
  } else {
    return Status.ISOLATED;
  }
}
