class ActivityListModel {
  int activityId;
  int actTimestamp;
  double totalElapsedTime;
  double totalTimerTime;
  double totalDistance;
  String sport;
  int avgHeartRate;
  int maxHeartRate;
  double avgSpeed;
  double maxSpeed;
  int avgPower;
  int maxPower;
  int avgCadence;
  int maxCadence;
  int avgTemperature;
  int maxTemperature;
  int avgAltitude;
  int maxAltitude;

  bool selected = false;

  ActivityListModel(
      {this.activityId,
      this.actTimestamp,
      this.totalElapsedTime,
      this.totalTimerTime,
      this.totalDistance,
      this.sport,
      this.avgHeartRate,
      this.maxHeartRate,
      this.avgSpeed,
      this.maxSpeed,
      this.avgPower,
      this.maxPower,
      this.avgCadence,
      this.maxCadence,
      this.avgTemperature,
      this.maxTemperature,
      this.avgAltitude,
      this.maxAltitude});

  ActivityListModel.fromJson(Map<String, dynamic> json) {
    print('json2');
    print(json);
    activityId = int.parse(json['activity_id'].toString());
    actTimestamp = int.parse(json['act_timestamp'].toString());
    totalElapsedTime = double.parse(json['total_elapsed_time'].toString());
    totalTimerTime = double.parse(json['total_timer_time'].toString());
    totalDistance = double.parse(json['total_distance'].toString());
    sport = json['sport'].toString();
    avgHeartRate = (json['avg_heart_rate'] != null)
        ? int.parse(json['avg_heart_rate'].toString())
        : null;
    maxHeartRate = (json['max_heart_rate'] != null)
        ? int.parse(json['max_heart_rate'].toString())
        : null;
    avgSpeed = (json['avg_speed'] != null)
        ? double.parse(json['avg_speed'].toString())
        : null;
    maxSpeed = (json['max_speed'] != null)
        ? double.parse(json['max_speed'].toString())
        : null;
    avgPower = (json['avg_power'] != null)
        ? int.parse(json['avg_power'].toString())
        : null;
    maxPower = (json['max_power'] != null)
        ? int.parse(json['max_power'].toString())
        : null;
    avgCadence = (json['avg_cadence'] != null)
        ? int.parse(json['avg_cadence'].toString())
        : null;
    maxCadence = (json['max_cadence'] != null)
        ? int.parse(json['max_cadence'].toString())
        : null;
    avgTemperature = (json['avg_temperature'] != null)
        ? int.parse(json['avg_temperature'].toString())
        : null;
    maxTemperature = ((json['max_temperature'] != null))
        ? int.parse(json['max_temperature'].toString())
        : null;
    avgAltitude = (json['avg_altitude'] != null)
        ? int.parse(json['avg_altitude'].toString())
        : null;
    maxAltitude = (json['max_altitude'] != null)
        ? int.parse(json['max_altitude'].toString())
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['activity_id'] = this.activityId;
    data['act_timestamp'] = this.actTimestamp;
    data['total_elapsed_time'] = this.totalElapsedTime;
    data['total_timer_time'] = this.totalTimerTime;
    data['total_distance'] = this.totalDistance;
    data['sport'] = this.sport;
    data['avg_heart_rate'] = this.avgHeartRate;
    data['max_heart_rate'] = this.maxHeartRate;
    data['avg_speed'] = this.avgSpeed;
    data['max_speed'] = this.maxSpeed;
    data['avg_power'] = this.avgPower;
    data['max_power'] = this.maxPower;
    data['avg_cadence'] = this.avgCadence;
    data['max_cadence'] = this.maxCadence;
    data['avg_temperature'] = this.avgTemperature;
    data['max_temperature'] = this.maxTemperature;
    data['avg_altitude'] = this.avgAltitude;
    data['max_altitude'] = this.maxAltitude;
    return data;
  }
}
