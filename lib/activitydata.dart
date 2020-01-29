class Activitydata {
  String activityId;
  String rowgroup;
  String hearRate;
  String power;
  String speed;
  String temperature;
  String leftRightBalance;
  String verticalOscillation;
  String athleteId;
  String createdAt;
  String elapsedTime;
  String latitude;
  String longitude;

  Activitydata(
      {this.activityId,
      this.rowgroup,
      this.hearRate,
      this.power,
      this.speed,
      this.temperature,
      this.leftRightBalance,
      this.verticalOscillation,
      this.athleteId,
      this.createdAt,
      this.elapsedTime,
      this.latitude,
      this.longitude});

  Activitydata.fromJson(Map<String, dynamic> json) {
    activityId = json['activity_id'];
    rowgroup = json['rowgroup'];
    hearRate = json['HearRate'];
    power = json['Power'];
    speed = json['Speed'];
    temperature = json['temperature'];
    leftRightBalance = json['left_right_balance'];
    verticalOscillation = json['vertical_oscillation'];
    athleteId = json['athlete_id'];
    createdAt = json['created_at'];
    elapsedTime = json['elapsed_time'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['activity_id'] = this.activityId;
    data['rowgroup'] = this.rowgroup;
    data['HearRate'] = this.hearRate;
    data['Power'] = this.power;
    data['Speed'] = this.speed;
    data['temperature'] = this.temperature;
    data['left_right_balance'] = this.leftRightBalance;
    data['vertical_oscillation'] = this.verticalOscillation;
    data['athlete_id'] = this.athleteId;
    data['created_at'] = this.createdAt;
    data['elapsed_time'] = this.elapsedTime;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}
