import SwiftUI

struct ContentView2: View {
    @State private var currentDate = Date()
    
    // كل الشهور للسنة الحالية
    private let months: [String] = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL yyyy"
        let calendar = Calendar.current
        let year = calendar.component(.year, from: Date())
        return (1...12).map { month -> String in
            let dateComponents = DateComponents(year: year, month: month)
            let date = calendar.date(from: dateComponents)!
            return dateFormatter.string(from: date)
        }
    }()
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea() // الخلفية الرئيسية
            
            VStack(spacing: 0) {
                // MARK: - Fully Transparent Header
                HStack {
                    // السهم بدائرة شفافة
                    Button(action: {}) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.clear)
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    // العنوان شفاف بالكامل
                    Text("All activities")
                        .font(.headline)
                        .foregroundColor(.white) // يظهر على أي خلفية
                    
                    Spacer()
                    
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 44, height: 44)
                }
                .padding(.horizontal)
                .padding(.top, 16) // مسافة من الأعلى
                .background(Color.clear) // مافي خلفية
                .zIndex(1)
                
                // MARK: - Scrollable Calendar
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 32) {
                        ForEach(months, id: \.self) { month in
                            VStack(spacing: 10) {
                                Text(month)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                CalendarGridView()
                                    .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.top, 8)
                }
            }
        }
    }
}

// MARK: - Calendar Grid
struct CalendarGridView: View {
    let days = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    let numbers = Array(1...30)
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                ForEach(days, id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                }
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 16) {
                ForEach(numbers, id: \.self) { number in
                    Text("\(number)")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 36, height: 36)
                        .background(Color.clear)
                        .clipShape(Circle())
                }
            }
        }
    }
}

#Preview {
    ContentView2()
}
