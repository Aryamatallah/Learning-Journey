import Foundation
import SwiftUI
import Combine

final class LearningViewModel: ObservableObject {
    // MARK: - Published properties
    @Published var currentDate = Date()
    @Published var showMonthPicker = false
    @Published var selectedMonth = Calendar.current.component(.month, from: Date())
    @Published var selectedYear = Calendar.current.component(.year, from: Date())

    @Published var learning: LearningModel
    @Published var currentState: LearningState = .logAsLearned
    @Published var lastLogDate: Date? = nil

    // MARK: - Combine cancellables
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Formatter
    private let dayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()

    // MARK: - Init
    init(topic: String = "Swift", period: String = "Week") {
        var totalFreezes = 2 // الافتراضي للأسبوع

        switch period.lowercased() {
        case "month":
            totalFreezes = 8
        case "year":
            totalFreezes = 96
        default:
            totalFreezes = 2
        }

        self.learning = LearningModel(topic: topic, daysLearned: 0, daysFreezed: 0, totalFreezes: totalFreezes)

        // ✅ تحديث الشهر والسنة تلقائيًا عند التغيير
        $selectedMonth.combineLatest($selectedYear)
            .sink { [weak self] (month, year) in
                guard let self = self else { return }
                var components = DateComponents()
                components.year = year
                components.month = month
                components.day = 1
                if let newDate = Calendar.current.date(from: components) {
                    self.currentDate = newDate
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - Month + Year text
    var currentMonthYear: String {
        let f = DateFormatter()
        f.dateFormat = "MMMM yyyy"
        return f.string(from: currentDate)
    }

    // MARK: - Move to current week (for live calendar)
    func moveToCurrentWeek() {
        let calendar = Calendar.current
        let today = Date()
        if let weekStart = calendar.dateInterval(of: .weekOfMonth, for: today)?.start {
            currentDate = weekStart
        }
    }

    // MARK: - Week Handling
    var currentWeek: [Date] {
        let calendar = Calendar.current
        guard let weekInterval = calendar.dateInterval(of: .weekOfMonth, for: currentDate) else { return [] }
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: weekInterval.start) }
    }

    func changeWeek(by value: Int) {
        if let newDate = Calendar.current.date(byAdding: .weekOfMonth, value: value, to: currentDate) {
            currentDate = newDate
        }
    }

    func monthName(for month: Int) -> String {
        let f = DateFormatter()
        return f.monthSymbols[month - 1]
    }

    func weekday(for date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "EEE"
        return f.string(from: date)
    }

    // MARK: - Calendar Colors
    func weekDayBackgroundColor(for day: Date) -> Color {
        let calendar = Calendar.current
        let key = dayFormatter.string(from: day)

        if calendar.isDateInToday(day) {
            switch currentState {
            case .logAsLearned: return Color(hex: "#FF9230")
            case .learnedToday: return Color(hex: "#4C311A")
            case .dayFreezed: return Color(hex: "#1D414B")
            }
        }

        if learning.loggedDays[key] == .dayFreezed { return Color(hex: "#1D414B") }
        if learning.loggedDays[key] == .learnedToday { return Color(hex: "#4C311A") }
        return .clear
    }

    func weekDayTextColor(for day: Date) -> Color {
        let calendar = Calendar.current
        let key = dayFormatter.string(from: day)

        if calendar.isDateInToday(day) {
            switch currentState {
            case .logAsLearned: return .white
            case .learnedToday: return Color(hex: "#FF9230")
            case .dayFreezed: return Color(hex: "#3CD3FE")
            }
        }

        if learning.loggedDays[key] == .dayFreezed { return Color(hex: "#3CD3FE") }
        if learning.loggedDays[key] == .learnedToday { return Color(hex: "#FF9230") }
        return Color.white.opacity(0.8)
    }

    // MARK: - Freeze Button Logic
    var isFreezeButtonEnabled: Bool {
        guard learning.daysFreezed < learning.totalFreezes else { return false }
        let todayKey = dayFormatter.string(from: Date())
        return learning.loggedDays[todayKey] == nil
    }

    var freezeButtonColor: Color {
        if learning.daysFreezed >= learning.totalFreezes {
            return Color(hex: "#091D1D") // انتهت الفريزات
        } else {
            return Color(hex: "#008593") // اللون الأساسي
        }
    }

    // MARK: - Actions
    func markTodayAsLearned() {
        let key = dayFormatter.string(from: Date())
        guard learning.loggedDays[key] == nil else { return }
        learning.loggedDays[key] = .learnedToday
        learning.daysLearned += 1
        currentState = .learnedToday
        lastLogDate = Date()
    }

    func markTodayAsFreezed() {
        let key = dayFormatter.string(from: Date())
        guard learning.loggedDays[key] == nil, learning.daysFreezed < learning.totalFreezes else { return }
        learning.loggedDays[key] = .dayFreezed
        learning.daysFreezed += 1
        currentState = .dayFreezed
        lastLogDate = Date()
    }

    func resetDailyStateIfNeeded() {
        let calendar = Calendar.current
        if let lastLogDate = lastLogDate, !calendar.isDateInToday(lastLogDate) {
            currentState = .logAsLearned
        }
    }
}
