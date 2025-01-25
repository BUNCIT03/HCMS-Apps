class Report {
  final String reportID;
  final String reportType;
  final String reportContent;

  Report({
    required this.reportID,
    required this.reportType,
    required this.reportContent,
  });

  static Future<Report> generate({
    required String reportType,
    required DateTime dateRangeStart,
    required DateTime dateRangeEnd,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    return Report(
      reportID: '12345',
      reportType: reportType,
      reportContent:
          'Report for $reportType from $dateRangeStart to $dateRangeEnd.',
    );
  }
}
