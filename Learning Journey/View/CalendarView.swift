import SwiftUI

struct CalendarView: View {
    @ObservedObject var vm: LearningViewModel
    @Environment(\.dismiss) var dismiss

    // MARK: - Colors
    private let emptyColor = Color(hex: "#1E1E1E")

    @State private var months: [Date] = []
    @State private var scrollToDate: Date = Date()

    var body: some View {
        ZStack {
            // خلفية الصفحة
            LinearGradient(
                colors: [Color.black, Color(red: 0.07, green: 0.04, blue: 0.02)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            // MARK: - المحتوى
            ScrollViewReader { scrollProxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 32) {
                        ForEach(months, id: \.self) { monthStart in
                            VStack(alignment: .leading, spacing: 12) {
                                // اسم الشهر والسنة
                                Text(getMonthYearString(from: monthStart))
                                    .foregroundColor(.white)
                                    .font(.system(size: 18, weight: .semibold))
                                    .padding(.leading, 20)
                                    .id(monthStart)

                                // أسماء الأيام
                                HStack {
                                    ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                                        Text(day)
                                            .foregroundColor(.white.opacity(0.6))
                                            .font(.system(size: 14))
                                            .frame(maxWidth: .infinity)
                                    }
                                }
                                .padding(.horizontal, 16)

                                // الأيام داخل الشهر
                                let days = getDays(for: monthStart)
                                let firstWeekday = getFirstWeekday(for: monthStart)

                                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 14) {
                                    // مسافات فارغة لبداية الشهر
                                    ForEach(0..<firstWeekday, id: \.self) { _ in
                                        Circle()
                                            .fill(Color.clear)
                                            .frame(width: 38, height: 38)
                                    }

                                    // الأيام الفعلية
                                    ForEach(days, id: \.self) { date in
                                        let key = dateKey(date)
                                        let calendar = Calendar.current
                                        let isToday = calendar.isDateInToday(date)

                                        // ✅ تحديد اللون حسب الحالة الحالية أو المسجلة
                                        let (dayColor, textColor): (Color, Color) = {
                                            if isToday {
                                                switch vm.currentState {
                                                case .logAsLearned:
                                                    return (Color(hex: "#FF9230"), .white)
                                                case .learnedToday:
                                                    return (Color(hex: "#4C311A"), Color(hex: "#FF9230"))
                                                case .dayFreezed:
                                                    return (Color(hex: "#1D414B"), Color(hex: "#3CD3FE"))
                                                }
                                            } else if let state = vm.learning.loggedDays[key] {
                                                switch state {
                                                case .learnedToday:
                                                    return (Color(hex: "#4C311A"), Color(hex: "#FF9230"))
                                                case .dayFreezed:
                                                    return (Color(hex: "#1D414B"), Color(hex: "#3CD3FE"))
                                                default:
                                                    return (emptyColor, .white)
                                                }
                                            } else {
                                                return (emptyColor, .white)
                                            }
                                        }()

                                        Circle()
                                            .fill(dayColor)
                                            .frame(width: 38, height: 38)
                                            .overlay(
                                                Text("\(Calendar.current.component(.day, from: date))")
                                                    .foregroundColor(textColor)
                                                    .font(.system(size: 15, weight: .semibold))
                                            )
                                            .animation(.easeInOut(duration: 0.25), value: vm.currentState)
                                            .shadow(color: isToday ? dayColor.opacity(0.6) : .clear,
                                                    radius: isToday ? 6 : 0)
                                    }
                                }
                                .padding(.horizontal, 16)

                                Divider()
                                    .background(Color.white.opacity(0.1))
                                    .padding(.top, 8)
                            }
                        }
                    }
                    .padding(.top, 120)
                    .padding(.bottom, 60)
                    .onAppear {
                        generateMonths()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            withAnimation(.easeInOut(duration: 0.8)) {
                                scrollProxy.scrollTo(scrollToDate, anchor: .top)
                            }
                        }
                    }
                }
            }

            // MARK: - Header (زر الرجوع الزجاجي)
            VStack {
                HStack {
                    // زر الرجوع
                    Button(action: { dismiss() }) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.white.opacity(0.15),
                                            Color.white.opacity(0.05)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .background(
                                    Circle()
                                        .fill(Color.white.opacity(0.08))
                                        .blur(radius: 2)
                                )
                                .overlay(
                                    Circle()
                                        .stroke(
                                            LinearGradient(
                                                colors: [
                                                    Color.white.opacity(0.4),
                                                    Color.white.opacity(0.05)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 1.2
                                        )
                                )
                                .shadow(color: Color.white.opacity(0.05), radius: 2, x: 1, y: 1)
                                .shadow(color: Color.black.opacity(0.6), radius: 3, x: 1, y: 2)

                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .font(.system(size: 18, weight: .semibold))
                        }
                        .frame(width: 42, height: 42)
                    }

                    Spacer()

                    Text("All activities")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .semibold))
                        .shadow(color: .black.opacity(0.4), radius: 2, y: 1)

                    Spacer()
                    Spacer().frame(width: 42)
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 8)
                .background(Color.clear)
                Spacer()
            }
            .zIndex(1)
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Calendar Helpers
    private func generateMonths() {
        let calendar = Calendar.current
        let current = Date()
        var tempMonths: [Date] = []

        for offset in -240...240 {
            if let newMonth = calendar.date(byAdding: .month, value: offset, to: current),
               let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: newMonth)) {
                tempMonths.append(startOfMonth)
            }
        }

        months = tempMonths.sorted()
        scrollToDate = calendar.date(from: calendar.dateComponents([.year, .month], from: current)) ?? current
    }

    private func getMonthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }

    private func getDays(for monthStart: Date) -> [Date] {
        let calendar = Calendar.current
        guard let range = calendar.range(of: .day, in: .month, for: monthStart) else { return [] }
        return range.compactMap { day -> Date? in
            calendar.date(byAdding: .day, value: day - 1, to: monthStart)
        }
    }

    private func getFirstWeekday(for monthStart: Date) -> Int {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: monthStart)
        return weekday - 1
    }

    private func dateKey(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}

#Preview {
    CalendarView(vm: LearningViewModel())
}
