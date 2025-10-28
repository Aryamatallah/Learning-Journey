import Foundation

// MARK: - الحالات الثلاث للدائرة
enum LearningState: String, Codable {
    case logAsLearned
    case learnedToday
    case dayFreezed
}

// MARK: - نموذج البيانات الأساسي
struct LearningModel: Codable {
    var topic: String                      // اسم الموضوع (مثل Swift أو Design)
    var daysLearned: Int                   // عدد الأيام اللي تم تسجيلها كـ "Learned"
    var daysFreezed: Int                   // عدد الأيام اللي تم تجميدها
    var totalFreezes: Int = 2              // الحد الأقصى المسموح به للتجميد (يُحدث حسب المدة)
    var loggedDays: [String: LearningState] = [:] // سجل الأيام (مثلاً: "2025-10-28": .learnedToday)

    // 🕒 لتتبع آخر تاريخ تم تسجيله كـ Learned أو Freezed
    var lastLoggedDate: Date? = nil
}
