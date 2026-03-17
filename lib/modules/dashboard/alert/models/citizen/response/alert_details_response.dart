class AlertDetailsResponse {
  final bool? success;
  final AlertDetailsData? data;

  AlertDetailsResponse({
    this.success,
    this.data,
  });

  factory AlertDetailsResponse.fromJson(Map<String, dynamic> json) {
    return AlertDetailsResponse(
      success: json["success"],
      data: json["data"] != null
          ? AlertDetailsData.fromJson(json["data"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "data": data?.toJson(),
    };
  }
}

class AlertDetailsData {
  final AlertDetails? alert;
  final List<String>? allowedNextStatuses;
  final List<String>? availableBasisTypes;

  AlertDetailsData({
    this.alert,
    this.allowedNextStatuses,
    this.availableBasisTypes,
  });

  factory AlertDetailsData.fromJson(Map<String, dynamic> json) {
    return AlertDetailsData(
      alert: json["alert"] != null
          ? AlertDetails.fromJson(json["alert"])
          : null,
      allowedNextStatuses: json["allowedNextStatuses"] != null
          ? List<String>.from(json["allowedNextStatuses"])
          : [],
      availableBasisTypes: json["availableBasisTypes"] != null
          ? List<String>.from(json["availableBasisTypes"])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "alert": alert?.toJson(),
      "allowedNextStatuses": allowedNextStatuses,
      "availableBasisTypes": availableBasisTypes,
    };
  }
}

class AlertDetails {
  final String? id;
  final String? title;
  final String? message;
  final String? priority;
  final String? type;
  final String? clientId;
  final String? createdBy;
  final String? userId;
  final String? assignedPartnerId;
  final AlertMetadata? metadata;
  final String? status;
  final bool? isActive;
  final AlertLocation? location;
  final String? areaId;
  final String? routedPartnerId;
  final List<AlertTimeline>? timeline;
  final String? createdAt;
  final String? updatedAt;
  final List<String>? mediaUrls;
  final int? version;

  AlertDetails({
    this.id,
    this.title,
    this.message,
    this.priority,
    this.type,
    this.clientId,
    this.createdBy,
    this.userId,
    this.assignedPartnerId,
    this.metadata,
    this.status,
    this.isActive,
    this.location,
    this.areaId,
    this.routedPartnerId,
    this.timeline,
    this.createdAt,
    this.updatedAt,
    this.mediaUrls,
    this.version,
  });

  factory AlertDetails.fromJson(Map<String, dynamic> json) {
    return AlertDetails(
      id: json["_id"],
      title: json["title"],
      message: json["message"],
      priority: json["priority"],
      type: json["type"],
      clientId: json["clientId"],
      createdBy: json["createdBy"],
      userId: json["userId"],
      assignedPartnerId: json["assignedPartnerId"],
      metadata: json["metadata"] != null
          ? AlertMetadata.fromJson(json["metadata"])
          : null,
      status: json["status"],
      isActive: json["isActive"],
      location: json["location"] != null
          ? AlertLocation.fromJson(json["location"])
          : null,
      areaId: json["areaId"],
      routedPartnerId: json["routedPartnerId"],
      timeline: json["timeline"] != null
          ? List<AlertTimeline>.from(
              json["timeline"].map((x) => AlertTimeline.fromJson(x)))
          : [],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
      mediaUrls: json["mediaUrls"] != null
          ? List<String>.from(json["mediaUrls"])
          : [],
      version: json["__v"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "title": title,
      "message": message,
      "priority": priority,
      "type": type,
      "clientId": clientId,
      "createdBy": createdBy,
      "userId": userId,
      "assignedPartnerId": assignedPartnerId,
      "metadata": metadata?.toJson(),
      "status": status,
      "isActive": isActive,
      "location": location?.toJson(),
      "areaId": areaId,
      "routedPartnerId": routedPartnerId,
      "timeline": timeline?.map((e) => e.toJson()).toList(),
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "mediaUrls": mediaUrls,
      "__v": version,
    };
  }
}

class AlertMetadata {
  final Map<String, dynamic>? data;

  AlertMetadata({this.data});

  factory AlertMetadata.fromJson(Map<String, dynamic> json) {
    return AlertMetadata(data: json);
  }

  Map<String, dynamic> toJson() {
    return data ?? {};
  }
}

class AlertLocation {
  final String? type;
  final List<double>? coordinates;

  AlertLocation({
    this.type,
    this.coordinates,
  });

  factory AlertLocation.fromJson(Map<String, dynamic> json) {
    return AlertLocation(
      type: json["type"],
      coordinates: json["coordinates"] != null
          ? List<double>.from(
              json["coordinates"].map((x) => x.toDouble()),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "coordinates": coordinates,
    };
  }
}

class AlertTimeline {
  final String? status;
  final String? basisType;
  final String? timestamp;
  final String? note;
  final String? updatedBy;
  final String? updatedByName;
  final String? id;

  AlertTimeline({
    this.status,
    this.basisType,
    this.timestamp,
    this.note,
    this.updatedBy,
    this.updatedByName,
    this.id,
  });

  factory AlertTimeline.fromJson(Map<String, dynamic> json) {
    return AlertTimeline(
      status: json["status"],
      basisType: json["basisType"],
      timestamp: json["timestamp"],
      note: json["note"],
      updatedBy: json["updatedBy"],
      updatedByName: json["updatedByName"],
      id: json["_id"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "basisType": basisType,
      "timestamp": timestamp,
      "note": note,
      "updatedBy": updatedBy,
      "updatedByName": updatedByName,
      "_id": id,
    };
  }
}