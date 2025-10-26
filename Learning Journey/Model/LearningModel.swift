import Foundation

// الحالات الثلاث للدائرة / الكلندر
enum LearningState: String, Codable {
    case logAsLearned
    case learnedToday
    case dayFreezed
}

// المودل الأساسي
struct LearningModel: Codable {
    var topic: String
    var daysLearned: Int
    var daysFreezed: Int
    var totalFreezes: Int = 2
    var loggedDays: [String: LearningState] = [:]
}
