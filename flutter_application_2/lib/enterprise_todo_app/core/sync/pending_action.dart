enum ActionType { create, update, toggle, delete }

class PendingAction {
  final String id;
  final ActionType type;
  final int todoId;
  final Map<String, dynamic>? payload;
  final DateTime createdAt;
  final int retryCount;

  const PendingAction({
    required this.id,
    required this.type,
    required this.todoId,
    this.payload,
    required this.createdAt,
    this.retryCount = 0,
  });

  factory PendingAction.create({
    required ActionType type,
    required int todoId,
    Map<String, dynamic>? payload,
  }) {
    return PendingAction(
      id: DateTime.now().toIso8601String(),
      type: type,
      todoId: todoId,
      payload: payload,
      createdAt: DateTime.now(),
    );
  }

  PendingAction incrementRetry() {
    return PendingAction(
      id: id,
      type: type,
      todoId: todoId,
      payload: payload,
      createdAt: createdAt,
      retryCount: retryCount + 1,
    );
  }

  Map<String, dynamic> toHive() {
    return {
      'id': id,
      'type': type.name,
      'todoId': todoId,
      'payload': payload,
      'createdAt': createdAt.toIso8601String(),
      'retryCount': retryCount,
    };
  }

  factory PendingAction.fromHive(Map map) {
    return PendingAction(
      id: map['id'] as String,
      type: ActionType.values.firstWhere(
        (e) => e.name == map['type'] as String,
      ),
      todoId: map['todoId'] as int,
      payload: map['payload'] != null
          ? Map<String, dynamic>.from(map['payload'] as Map)
          : null,
      createdAt: DateTime.parse(map['createdAt'] as String),
      retryCount: map['retryCount'] as int? ?? 0,
    );
  }

  @override
  String toString() =>
      'PendingAction(id: $id, type: ${type.name},todoId: $todoId, retryCount: $retryCount),';
}
