import SwiftUI

struct Task2View: View {
    @State private var currentDate = Date()
    @State private var showMonthPicker = false

    // MARK: - Customizable Sizes
    private let headerFontSize: CGFloat = 32
    private let sectionTitleSize: CGFloat = 18
    private let capsuleFontSize: CGFloat = 16
    private let capsuleValueSize: CGFloat = 20
    private let capsuleHeight: CGFloat = 60
    private let capsuleWidth: CGFloat = 150

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack(alignment: .leading, spacing: 25) {

                    // MARK: - Header
                    HStack {
                        Text("Activity")
                            .font(.system(size: headerFontSize, weight: .bold))
                            .foregroundColor(.white)

                        Spacer()

                        HStack(spacing: 18) {
                            NavigationLink(destination: CalendarView()) {
                                CircleButton(systemIcon: "calendar") {}
                            }

                            CircleButton(systemIcon: "pencil.and.outline") {
                                print("Edit tapped")
                            }
                        }
                    }
                    .padding(.horizontal, 25)
                    .padding(.top, 20)

                    // MARK: - Main Card
                    VStack(alignment: .leading, spacing: 16) {
                        // Month Header
                        HStack {
                            Button(action: {
                                withAnimation(.easeInOut) {
                                    showMonthPicker.toggle()
                                }
                            }) {
                                HStack(spacing: 4) {
                                    Text(currentMonthYear)
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(.white)
                                    Image(systemName: showMonthPicker ? "chevron.up" : "chevron.down")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(Color(hex: "#FF9230"))
                                }
                            }

                            Spacer()

                            HStack(spacing: 20) {
                                Button(action: { changeWeek(by: -1) }) {
                                    Image(systemName: "chevron.left")
                                        .foregroundColor(Color(hex: "#FF9230"))
                                }

                                Button(action: { changeWeek(by: 1) }) {
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color(hex: "#FF9230"))
                                }
                            }
                        }

                        if showMonthPicker {
                            monthYearPicker
                        } else {
                            weekView
                        }

                        Divider().background(Color.gray.opacity(0.3))

                        Text("Learning Swift")
                            .font(.system(size: sectionTitleSize, weight: .semibold))
                            .foregroundColor(.white)

                        HStack(spacing: 18) {
                            CapsuleInfo(
                                icon: "flame.fill",
                                iconColor: Color(hex: "#FF9230"),
                                value: 3,
                                label: "Days Learned",
                                color: Color(hex: "#5B3A1E"),
                                valueSize: capsuleValueSize,
                                labelSize: capsuleFontSize,
                                capsuleHeight: capsuleHeight,
                                capsuleWidth: capsuleWidth
                            )
                            CapsuleInfo(
                                icon: "cube.fill",
                                iconColor: Color(hex: "#77C9D4"),
                                value: 1,
                                label: "Day Freezed",
                                color: Color(hex: "#2B4D59"),
                                valueSize: capsuleValueSize,
                                labelSize: capsuleFontSize,
                                capsuleHeight: capsuleHeight,
                                capsuleWidth: capsuleWidth
                            )
                        }
                    }
                    .padding(20)
                    .background(Color(red: 0.10, green: 0.10, blue: 0.10))
                    .cornerRadius(18)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color.gray.opacity(0.25), lineWidth: 0.7)
                    )
                    .padding(.horizontal, 25)

                    // MARK: - Learned Today Section (خارج الكارد)
                    VStack(spacing: 20) {
                        ZStack {
                            Circle()
                                .fill(Color(hex: "#A4521C"))
                                .frame(width: 274, height: 274)
                                .shadow(color: Color(hex: "#A4521C").opacity(0.6), radius: 25) // ظل ناعم مثل الصورة
                            Text("Learned\nToday")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                        }

                        Button(action: {
                            print("Freeze Current day tapped")
                        }) {
                            Text("Freeze Current day")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 250, height: 48)
                                .background(Color(hex: "#4C99A7"))
                                .cornerRadius(25)
                        }

                        Text("1 out of 2 Freezes used")
                            .font(.system(size: 14))
                            .foregroundColor(.gray.opacity(0.8))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 10)
                    .padding(.bottom, 40)

                    Spacer()
                }
            }
        }
    }

    // MARK: - Week View
    private var weekView: some View {
        let weekDays = currentWeek
        return HStack(spacing: 14) {
            ForEach(weekDays, id: \.self) { day in
                VStack(spacing: 6) {
                    Text(weekday(for: day))
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.gray)

                    Text("\(Calendar.current.component(.day, from: day))")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 36, height: 36)
                        .background(
                            Circle()
                                .fill(Calendar.current.isDateInToday(day)
                                      ? Color(hex: "#FF9230")
                                      : Color(red: 0.15, green: 0.15, blue: 0.15))
                        )
                }
            }
        }
    }

    // MARK: - Month Picker
    private var monthYearPicker: some View {
        HStack(alignment: .center, spacing: 30) {
            Picker("Month", selection: Binding(
                get: { Calendar.current.component(.month, from: currentDate) },
                set: { updateMonth(to: $0) })) {
                ForEach(1...12, id: \.self) { month in
                    Text(monthName(for: month))
                        .foregroundColor(.white)
                        .tag(month)
                }
            }
            .pickerStyle(.wheel)
            .frame(width: 140, height: 160)
            .clipped()

            Picker("Year", selection: Binding(
                get: { Calendar.current.component(.year, from: currentDate) },
                set: { updateYear(to: $0) })) {
                ForEach(2020...2028, id: \.self) { year in
                    Text(englishDigits(from: year))
                        .foregroundColor(.white)
                        .tag(year)
                }
            }
            .pickerStyle(.wheel)
            .frame(width: 120, height: 160)
            .clipped()
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
    }

    private func englishDigits(from number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }

    private var currentWeek: [Date] {
        let calendar = Calendar.current
        guard let weekInterval = calendar.dateInterval(of: .weekOfMonth, for: currentDate) else { return [] }
        let startOfWeek = weekInterval.start
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
    }

    private var currentMonthYear: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentDate)
    }

    private func changeWeek(by offset: Int) {
        if let newDate = Calendar.current.date(byAdding: .weekOfMonth, value: offset, to: currentDate) {
            currentDate = newDate
        }
    }

    private func weekday(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date).uppercased()
    }

    private func monthName(for month: Int) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.monthSymbols[month - 1]
    }

    private func updateMonth(to newMonth: Int) {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: currentDate)
        components.month = newMonth
        if let newDate = Calendar.current.date(from: components) {
            currentDate = newDate
        }
    }

    private func updateYear(to newYear: Int) {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: currentDate)
        components.year = newYear
        if let newDate = Calendar.current.date(from: components) {
            currentDate = newDate
        }
    }
}

// MARK: - CalendarView (الصفحة الجديدة)
struct CalendarView: View {
    let months = ["September 2025", "October 2025", "November 2025"]

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                ForEach(months, id: \.self) { month in
                    VStack(alignment: .leading, spacing: 10) {
                        Text(month)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                        CalendarGrid()
                    }
                }
            }
            .padding()
        }
        .background(Color.black.ignoresSafeArea())
        .navigationTitle("All activities")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - CalendarGrid
struct CalendarGrid: View {
    let columns = Array(repeating: GridItem(.flexible()), count: 7)

    var body: some View {
        VStack(spacing: 6) {
            HStack {
                ForEach(["SUN","MON","TUE","WED","THU","FRI","SAT"], id: \.self) { day in
                    Text(day)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                }
            }

            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(1...30, id: \.self) { day in
                    Text("\(day)")
                        .font(.system(size: 14, weight: .semibold))
                        .frame(width: 36, height: 36)
                        .background(
                            Circle().fill(colorFor(day))
                        )
                        .foregroundColor(.white)
                }
            }
        }
    }

    private func colorFor(_ day: Int) -> Color {
        if day == 26 {
            return Color(hex: "#FF9230")
        } else if [13,14,21,22].contains(day) {
            return Color(hex: "#2B4D59")
        } else {
            return Color(hex: "#5B3A1E")
        }
    }
}

// MARK: - CircleButton
struct CircleButton: View {
    let systemIcon: String
    let action: () -> Void
    @State private var pressed = false

    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                pressed = true
                action()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    pressed = false
                }
            }
        }) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.06),
                                Color.black.opacity(0.7)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.white.opacity(0.12),
                                        Color.black.opacity(0.25)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )

                Image(systemName: systemIcon)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.white)
            }
            .frame(width: 58, height: 58)
            .scaleEffect(pressed ? 0.9 : 1.0)
        }
    }
}

// MARK: - Capsule Info
struct CapsuleInfo: View {
    let icon: String
    let iconColor: Color
    let value: Int
    let label: String
    let color: Color
    let valueSize: CGFloat
    let labelSize: CGFloat
    let capsuleHeight: CGFloat
    let capsuleWidth: CGFloat

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(iconColor)
            VStack(alignment: .leading, spacing: 2) {
                Text("\(value)")
                    .font(.system(size: valueSize, weight: .bold))
                Text(label)
                    .font(.system(size: labelSize))
            }
            .foregroundColor(.white)
        }
        .frame(width: capsuleWidth, height: capsuleHeight)
        .background(Capsule().fill(color))
    }
}

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hexString.hasPrefix("#") { hexString.removeFirst() }

        var rgb: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}

#Preview {
    Task2View()
}
