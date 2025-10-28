import SwiftUI

struct ContentView3: View {
    @StateObject private var vm = LearningViewModel()
    @State private var showCalendar = false
    @State private var showGoal = false
    @State private var showCompletionView = false
    @Environment(\.colorScheme) private var colorScheme

    private let screenHeight = UIScreen.main.bounds.height
    private let screenWidth = UIScreen.main.bounds.width

    @State var topic: String
    @State var period: String

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color(.systemBackground), Color(.secondarySystemBackground)],
                    startPoint: .top, endPoint: .bottom
                )
                .ignoresSafeArea()

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: screenHeight * 0.03) {
                        headerView
                        mainCardView

                        if showCompletionView {
                            completionView
                        } else {
                            learnedTodayView
                        }

                        Spacer(minLength: 25)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 45)
                    .frame(maxWidth: screenWidth * 0.95)
                }
            }
            // ✅ التعديل هنا فقط
            .onAppear {
                // تحديث الأسبوع الحالي
                vm.moveToCurrentWeek()

                // تأخير بسيط لتحديث التاريخ
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    vm.currentDate = Date()
                }

                // إعادة فحص الهدف
                showCompletionView = false
                checkGoalCompletion()

                // ✅ فحص مرور 32 ساعة على آخر تسجيل
                vm.checkStreakReset()
            }
            .fullScreenCover(isPresented: $showCalendar) { CalendarView(vm: vm) }
            .fullScreenCover(isPresented: $showGoal) { Goul(topic: $topic, period: $period) }
            .onChange(of: vm.learning.daysLearned) { _ in checkGoalCompletion() }
        }
    }

    // MARK: - تحقق الهدف
    private func checkGoalCompletion() {
        let targetDays: Int
        switch period.lowercased() {
        case "week": targetDays = 7
        case "month": targetDays = 30
        case "year": targetDays = 365
        default: targetDays = 7
        }
        if vm.learning.daysLearned >= targetDays {
            withAnimation(.easeInOut(duration: 0.4)) { showCompletionView = true }
        }
    }

    // MARK: - شاشة Well Done
    private var completionView: some View {
        VStack(spacing: screenHeight * 0.015) {
            Image(systemName: "hands.clap.fill")
                .font(.system(size: screenHeight * 0.053))
                .foregroundColor(Color(hex: "#FF9230"))
                .shadow(color: .orange.opacity(0.4), radius: 8, y: 4)

            Text("Well done!")
                .font(.system(size: screenHeight * 0.026, weight: .bold))
                .foregroundColor(.primary)

            Text("Goal completed! Start learning again or\nset new learning goal.")
                .font(.system(size: screenHeight * 0.021))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)

            Button {
                withAnimation { showGoal = true }
            } label: {
                Text("Set new learning goal")
                    .font(.system(size: screenHeight * 0.02, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: screenWidth * 0.6, height: screenHeight * 0.052)
                    .background(RoundedRectangle(cornerRadius: 22).fill(Color(hex: "#AF4402")))
            }
            .shadow(color: .orange.opacity(0.4), radius: 7, y: 3)
            .padding(.top, 12)

            Button {
                withAnimation {
                    vm.learning.daysLearned = 0
                    showCompletionView = false
                }
            } label: {
                Text("Set same learning goal and duration")
                    .font(.system(size: screenHeight * 0.017))
                    .foregroundColor(Color(hex: "#FF9230"))
            }
            .padding(.top, 6)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, screenHeight * 0.05)
    }

    // MARK: - Header
    private var headerView: some View {
        HStack {
            Text("Activity")
                .font(.system(size: screenHeight * 0.035, weight: .bold))
                .foregroundColor(.primary)
            Spacer()
            HStack(spacing: 12) {
                glassButton(icon: "calendar") { withAnimation { showCalendar = true } }
                glassButton(icon: "pencil.and.outline") { withAnimation { showGoal = true } }
            }
        }
        .padding(.top, 28)
    }

    private func glassButton(icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.white.opacity(0.15), Color.white.opacity(0.05)]),
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        Circle().stroke(
                            LinearGradient(
                                colors: [Color.white.opacity(0.4), Color.white.opacity(0.05)],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            ), lineWidth: 1
                        )
                    )
                Image(systemName: icon)
                    .font(.system(size: screenHeight * 0.019, weight: .semibold))
                    .foregroundColor(.primary)
            }
            .frame(width: screenHeight * 0.052, height: screenHeight * 0.052)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Main Card
    private var mainCardView: some View {
        VStack(alignment: .leading, spacing: 13) {
            HStack {
                Button(action: { withAnimation { vm.showMonthPicker.toggle() } }) {
                    HStack(spacing: 5) {
                        Text(vm.currentMonthYear)
                            .font(.system(size: screenHeight * 0.019, weight: .medium))
                            .foregroundColor(.primary)
                        Image(systemName: "chevron.forward")
                            .font(.system(size: screenHeight * 0.015, weight: .bold))
                            .foregroundColor(Color(hex: "#FF9230"))
                            .rotationEffect(.degrees(vm.showMonthPicker ? 90 : 0))
                            .animation(.spring(), value: vm.showMonthPicker)
                    }
                }
                Spacer()
                HStack(spacing: 15) {
                    Button(action: { vm.changeWeek(by: -1) }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color(hex: "#FF9230"))
                    }
                    Button(action: { vm.changeWeek(by: 1) }) {
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color(hex: "#FF9230"))
                    }
                }
            }

            if vm.showMonthPicker { monthYearPicker } else { weekView }

            Divider().background(Color.gray.opacity(0.25))

            Text("Learning \(topic)")
                .font(.system(size: screenHeight * 0.021, weight: .semibold))
                .foregroundColor(.primary)

            HStack(spacing: 12) {
                capsuleView(
                    bgColor: Color(hex: "#4A3422"),
                    icon: "flame.fill",
                    iconColor: Color(hex: "#FF9230"),
                    value: vm.learning.daysLearned,
                    label: vm.learning.daysLearned <= 1 ? "Day Learned" : "Days Learned"
                )
                capsuleView(
                    bgColor: Color(hex: "#243C46"),
                    icon: "cube.fill",
                    iconColor: Color(hex: "#77C9D4"),
                    value: vm.learning.daysFreezed,
                    label: vm.learning.daysFreezed <= 1 ? "Day Freezed" : "Days Freezed"
                )
            }
        }
        .padding(17)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
        )
    }

    private var weekView: some View {
        HStack(spacing: 9) {
            ForEach(vm.currentWeek, id: \.self) { day in
                VStack(spacing: 4) {
                    Text(vm.weekday(for: day))
                        .font(.system(size: screenHeight * 0.012, weight: .medium))
                        .foregroundColor(.gray)

                    let bgColor = vm.weekDayBackgroundColor(for: day)
                    let hasCircle = bgColor != Color.clear

                    Text("\(Calendar.current.component(.day, from: day))")
                        .font(.system(size: screenHeight * 0.016, weight: .semibold))
                        .foregroundColor(
                            hasCircle ? vm.weekDayTextColor(for: day)
                                      : (colorScheme == .dark ? .white : .black)
                        )
                        .frame(width: screenHeight * 0.04, height: screenHeight * 0.04)
                        .background(Circle().fill(bgColor))
                }
            }
        }
    }

    private var monthYearPicker: some View {
        HStack(spacing: 0) {
            Picker("Month", selection: $vm.selectedMonth) {
                ForEach(1...12, id: \.self) { month in
                    Text(vm.monthName(for: month)).tag(month)
                }
            }
            Picker("Year", selection: $vm.selectedYear) {
                ForEach(2020...2030, id: \.self) { year in
                    Text(String(year)).tag(year)
                }
            }
        }
        .frame(height: 140)
        .pickerStyle(.wheel)
        .padding(.horizontal, 8)
    }

    private func capsuleView(bgColor: Color, icon: String, iconColor: Color, value: Int, label: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(bgColor)
                .frame(width: screenWidth * 0.38, height: screenHeight * 0.07)
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                VStack(alignment: .leading, spacing: 1) {
                    Text("\(value)")
                        .font(.system(size: screenHeight * 0.024, weight: .bold))
                        .foregroundColor(.white)
                    Text(label)
                        .font(.system(size: screenHeight * 0.014))
                        .foregroundColor(.white)
                }
            }
        }
    }

    // MARK: - دائرة Log as Learned
    private var learnedTodayView: some View {
        VStack(spacing: 25) {
            ZStack {
                Circle()
                    .fill(circleFillStyle)
                    .overlay(Circle().strokeBorder(circleStrokeStyle, lineWidth: 2))
                    .frame(width: screenHeight * 0.34, height: screenHeight * 0.34)

                VStack(spacing: 3) {
                    switch vm.currentState {
                    case .logAsLearned: Text("Log as"); Text("Learned")
                    case .learnedToday: Text("Learned"); Text("Today")
                    case .dayFreezed: Text("Day"); Text("Freezed")
                    }
                }
                .font(.system(size: screenHeight * 0.04, weight: .bold))
                .foregroundColor(circleTextColor)
            }
            .onTapGesture {
                withAnimation {
                    if vm.currentState == .logAsLearned {
                        vm.currentState = .learnedToday
                        vm.markTodayAsLearned()
                    }
                }
            }

            // ✅ زر Log as Freezed
            Button {
                withAnimation {
                    vm.currentState = .dayFreezed
                    vm.markTodayAsFreezed()
                }
            } label: {
                Text("Log as Freezed")
                    .font(.system(size: screenHeight * 0.020, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: screenWidth * 0.7, height: screenHeight * 0.052)
                    .background(RoundedRectangle(cornerRadius: 20).fill(vm.freezeButtonColor))
                    .padding(.top, 10)
            }
            .disabled(!vm.isFreezeButtonEnabled)

            // ✅ قرّبنا الكلام الرمادي من الزر
            Text("\(vm.learning.daysFreezed) out of \(vm.learning.totalFreezes) Freezes used")
                .font(.system(size: screenHeight * 0.016))
                .foregroundColor(.gray.opacity(0.8))
                .padding(.top, -8)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - أنماط الدائرة
    private var circleFillStyle: AnyShapeStyle {
        switch vm.currentState {
        case .logAsLearned:
            return AnyShapeStyle(LinearGradient(
                gradient: Gradient(colors: [Color(hex: "#B24500"), Color(hex: "#FF9230").opacity(0.4)]),
                startPoint: .topLeading, endPoint: .bottomTrailing
            ))
        case .learnedToday:
            return AnyShapeStyle(LinearGradient(
                gradient: Gradient(colors: [Color(hex: "#150000"), Color(hex: "#4C311A").opacity(0.4)]),
                startPoint: .topLeading, endPoint: .bottomTrailing
            ))
        case .dayFreezed:
            return AnyShapeStyle(Color(hex: "#00060C"))
        }
    }

    private var circleStrokeStyle: AnyShapeStyle {
        switch vm.currentState {
        case .logAsLearned:
            return AnyShapeStyle(LinearGradient(
                gradient: Gradient(colors: [Color(hex: "#FF9230").opacity(0.6), Color.clear]),
                startPoint: .topLeading, endPoint: .bottomTrailing
            ))
        case .learnedToday:
            return AnyShapeStyle(LinearGradient(
                gradient: Gradient(colors: [Color(hex: "#4C311A"), Color.clear]),
                startPoint: .topLeading, endPoint: .bottomTrailing
            ))
        case .dayFreezed:
            return AnyShapeStyle(Color(hex: "#00D2E0"))
        }
    }

    private var circleTextColor: Color {
        switch vm.currentState {
        case .logAsLearned: return .white
        case .learnedToday: return Color(hex: "#FF9230")
        case .dayFreezed: return Color(hex: "#00D2E0")
        }
    }
}

#Preview {
    ContentView3(topic: "Swift", period: "Week")
}
