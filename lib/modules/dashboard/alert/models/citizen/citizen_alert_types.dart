enum CitizenAlertType {
  crime,
  traffic,
  sos,
  other,
}

const Map<CitizenAlertType, List<String>> citizenSubTypeMap = {
  CitizenAlertType.crime: [
    "Snatching",
    "Theft",
    "Attempted Burglary",
    "Suspicious Activity",
    "Assault",
    "Arrear",
  ],
  CitizenAlertType.traffic: [
    "Accident",
    "Wrong side driving",
    "No parking",
    "Congestion",
    "Vehicle breakdown",
  ],
  CitizenAlertType.sos: [
    "Medical Emergency",
    "Fire",
    "Accident",
  ],
  CitizenAlertType.other: [
    "Water logging",
    "Garbage",
    "General inquiry",
  ],
};
