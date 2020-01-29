class ActivityListModel {
  int activityId;
  int actTimestamp;
  double totalElapsedTime;
  double totalTimerTime;
  double totalDistance;
  String sport;
  bool selected = false;

  ActivityListModel(
      {this.activityId,
      this.actTimestamp,
      this.totalElapsedTime,
      this.totalTimerTime,
      this.totalDistance,
      this.sport});

  ActivityListModel.fromJson(Map<String, dynamic> json) {
    print('json2');
    print(json);
    activityId = int.parse(json['activity_id'].toString());
    actTimestamp = int.parse(json['act_timestamp'].toString());
    totalElapsedTime = double.parse(json['total_elapsed_time'].toString());
    totalTimerTime = double.parse(json['total_timer_time'].toString());
    totalDistance = double.parse(json['total_distance'].toString());
    sport = json['sport'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['activity_id'] = this.activityId;
    data['act_timestamp'] = this.actTimestamp;
    data['total_elapsed_time'] = this.totalElapsedTime;
    data['total_timer_time'] = this.totalTimerTime;
    data['total_distance'] = this.totalDistance;
    data['sport'] = this.sport;
    return data;
  }
}
