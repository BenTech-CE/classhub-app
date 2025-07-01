enum NotificationType {
  new_alert("new_alert"),
  new_material("new_material"),
  event_created("event_created"),
  member_join("member_join"),
  member_left("member_left");

  final String name;

  const NotificationType(this.name);

  static NotificationType? getNotificationTypeFromName(String name) {
    try {
      return NotificationType.values.firstWhere((e) => e.name == name);
    } catch (_) {
      return null;
    }
  }
}
