import SwiftUI

struct callView: View {
    // MARK: - Properties
    private let months: [String] = [
        "September 2025",
        "October 2025",
        "November 2025"
    ]
    
    private let daysInMonth = [
        30, 31, 30
    ]
    
    // لتنسيق الأيام بالألوان
    private let highlightedDays: [Int: [Int]] = [
        0: [13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26],
        1: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26],
        2: [13, 14, 15]
    ]
    
    private let blueDays = [13, 14, 20, 21, 22]
    
    // MARK: - View
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                
                // MARK: - Header
                HStack {
                    Button(action: {}) {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                    Text("All activities")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.horizontal)
                
                // MARK: - Calendar
                ScrollView {
                    VStack(alignment: .leading, spacing: 32) {
                        ForEach(months.indices, id: \.self) { index in
                            VStack(alignment: .leading, spacing: 10) {
                                Text(months[index])
                                    .foregroundColor(.white)
                                    .font(.headline)
                                    .padding(.horizontal)
                                
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 7), spacing: 10) {
                                    ForEach(1...daysInMonth[index], id: \.self) { day in
                                        Circle()
                                            .fill(
                                                blueDays.contains(day)
                                                ? Color.blue
                                                : highlightedDays[index]?.contains(day) ?? false
                                                    ? Color(red: 0.4, green: 0.25, blue: 0.1)
                                                    : Color.clear
                                            )
                                            .frame(width: 36, height: 36)
                                            .overlay(
                                                Text("\(day)")
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 14, weight: .semibold))
                                            )
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
            }
            .padding(.top, 16)
        }
    }
}

#Preview {
    callView()
}

