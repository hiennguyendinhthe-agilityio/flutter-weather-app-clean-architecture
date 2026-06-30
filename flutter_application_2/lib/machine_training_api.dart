enum MachineStatus { normal, warning, critical }

class MachineReport {
  final String machineCode;
  final String machineName;
  final double temperature;
  final MachineStatus status;
  final DateTime reportedAt;

  MachineReport({
    required this.machineCode,
    required this.machineName,
    required this.temperature,
    required this.status,
    required this.reportedAt,
  });

  factory MachineReport.fromJson(Map<String, dynamic> json) {
    return MachineReport(
      machineCode: json['machineCode'] as String,
      machineName: json['machineName'] as String,
      temperature: (json['temperature'] as num).toDouble(),
      status: MachineStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => MachineStatus.normal,
      ),
      reportedAt: DateTime.parse(json['reportedAt'] as String),
    );
  }

  bool get isCritical {
    return status == MachineStatus.critical;
  }

  bool get requiresImmediateAction {
    return status == MachineStatus.critical || temperature >= 90;
  }

  MachineReport copyWith({
    String? machineCode,
    String? machineName,
    double? temperature,
    MachineStatus? status,
    DateTime? reportedAt,
  }) {
    return MachineReport(
      machineCode: machineCode ?? this.machineCode,
      machineName: machineName ?? this.machineName,
      temperature: temperature ?? this.temperature,
      status: status ?? this.status,
      reportedAt: reportedAt ?? this.reportedAt,
    );
  }
}
