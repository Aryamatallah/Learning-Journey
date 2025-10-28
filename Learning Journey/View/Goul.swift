import SwiftUI

struct Goul: View {
    enum Duration: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case year = "Year"
    }

    @Binding var topic: String
    @Binding var period: String
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) private var colorScheme // ✅ لمعرفة الثيم الحالي

    @State private var showAlert = false
    @State private var goalText: String
    @State private var selectedDuration: Duration

    // 🎨 اللون البرتقالي الجديد
    private let orangeMain = Color(hex: "#AF4402")

    init(topic: Binding<String>, period: Binding<String>) {
        _topic = topic
        _period = period
        _goalText = State(initialValue: topic.wrappedValue)
        _selectedDuration = State(initialValue: Duration(rawValue: period.wrappedValue.capitalized) ?? .week)
    }

    var body: some View {
        ZStack {
            // ✅ الخلفية حسب الثيم
            LinearGradient(
                colors: colorScheme == .dark
                    ? [Color.black.opacity(0.7), Color(hex: "#1A0E06")]
                    : [Color.white, Color(red: 0.97, green: 0.96, blue: 0.95)], // ✅ تم تصحيح Color.white
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                // MARK: - الشريط العلوي
                HStack {
                    glassEffectButton(icon: "chevron.left") {
                        presentationMode.wrappedValue.dismiss()
                    }

                    Spacer()

                    Text("Learning Goal")
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .font(.system(size: 20, weight: .semibold))

                    Spacer()

                    glassOrangeButton(icon: "checkmark") {
                        withAnimation(.spring()) {
                            showAlert = true
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 10)

                Spacer().frame(height: 8)

                // MARK: - المحتوى الرئيسي
                VStack(alignment: .leading, spacing: 18) {
                    Text("I want to learn")
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .font(.system(size: 18, weight: .semibold))

                    ZStack(alignment: .leading) {
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(colorScheme == .dark ? Color.white.opacity(0.25) : Color.black.opacity(0.25))

                            .offset(y: 18)

                        TextEditorWrapper(text: $goalText, textColor: colorScheme == .dark ? .white : .black)
                            .frame(height: 36)
                            .background(Color.clear)
                            .font(.system(size: 18))
                    }

                    Text("I want to learn it in a")
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .font(.system(size: 16, weight: .regular))
                        .padding(.top, 8)

                    // MARK: - اختيار المدة
                    HStack(spacing: 12) {
                        ForEach(Duration.allCases, id: \.self) { d in
                            Button(action: {
                                withAnimation(.easeInOut) {
                                    selectedDuration = d
                                }
                            }) {
                                Text(d.rawValue)
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(
                                        selectedDuration == d
                                            ? .white
                                            : (colorScheme == .dark ? .white.opacity(0.8) : .black.opacity(0.8))
                                    )
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 26)
                                    .background(
                                        Group {
                                            if selectedDuration == d {
                                                Capsule()
                                                    .fill(orangeMain)
                                                    .shadow(color: orangeMain.opacity(0.5), radius: 4, x: 0, y: 2)
                                            } else {
                                                Capsule()
                                                    .fill(
                                                        LinearGradient(
                                                            gradient: Gradient(colors: [
                                                                colorScheme == .dark
                                                                    ? Color.white.opacity(0.15)
                                                                    : Color.black.opacity(0.08),
                                                                colorScheme == .dark
                                                                    ? Color.white.opacity(0.05)
                                                                    : Color.black.opacity(0.03)
                                                            ]),
                                                            startPoint: .topLeading,
                                                            endPoint: .bottomTrailing
                                                        )
                                                    )
                                                    .overlay(
                                                        Capsule()
                                                            .stroke(
                                                                LinearGradient(
                                                                    colors: [
                                                                        colorScheme == .dark
                                                                            ? Color.white.opacity(0.35)
                                                                            : Color.black.opacity(0.2),
                                                                        Color.clear
                                                                    ],
                                                                    startPoint: .topLeading,
                                                                    endPoint: .bottomTrailing
                                                                ),
                                                                lineWidth: 1.1
                                                            )
                                                    )
                                                    .shadow(color: Color.black.opacity(0.15), radius: 2, x: 1, y: 2)
                                            }
                                        }
                                    )
                            }
                        }
                        Spacer()
                    }
                }
                .padding(.horizontal, 20)

                Spacer()
            }
            .padding(.top, 6)

            // MARK: - ALERT
            if showAlert {
                (colorScheme == .dark ? Color.black.opacity(0.45) : Color.white.opacity(0.4))
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .onTapGesture {
                        withAnimation { showAlert = false }
                    }

                VStack(spacing: 16) {
                    Text("Update Learning goal")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(colorScheme == .dark ? .white : .black)

                    Text("If you update now, your streak will start over.")
                        .font(.system(size: 15))
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 8)

                    HStack(spacing: 12) {
                        Button(action: {
                            withAnimation { showAlert = false }
                        }) {
                            Text("Dismiss")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(
                                    colorScheme == .dark
                                        ? Color.gray.opacity(0.35)
                                        : Color.black.opacity(0.1)
                                )
                                .cornerRadius(14)
                        }

                        Button(action: {
                            topic = goalText
                            period = selectedDuration.rawValue
                            withAnimation {
                                showAlert = false
                                presentationMode.wrappedValue.dismiss()
                            }
                        }) {
                            Text("Update")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(orangeMain)
                                .cornerRadius(14)
                                .shadow(color: orangeMain.opacity(0.3), radius: 4, y: 2)
                        }
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                .padding(.horizontal, 40)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 6)
                .transition(.scale.combined(with: .opacity))
            }
        }
    }

    // MARK: - زر الرجوع الزجاجي
    private func glassEffectButton(icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                colorScheme == .dark
                                    ? Color.white.opacity(0.15)
                                    : Color.black.opacity(0.1),
                                colorScheme == .dark
                                    ? Color.white.opacity(0.05)
                                    : Color.black.opacity(0.05)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        colorScheme == .dark
                                            ? Color.white.opacity(0.3)
                                            : Color.black.opacity(0.3),
                                        Color.clear
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.2
                            )
                    )

                Image(systemName: icon)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .font(.system(size: 18, weight: .semibold))
            }
            .frame(width: 44, height: 44)
        }
    }

    // MARK: - زر الصح (AF4402)
    private func glassOrangeButton(icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(orangeMain)
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.3),
                                        Color.white.opacity(0.05)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.2
                            )
                    )

                Image(systemName: icon)
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .bold))
            }
            .frame(width: 44, height: 44)
        }
    }
}

// MARK: - TextEditor single-line wrapper (يدعم الثيم)
struct TextEditorWrapper: UIViewRepresentable {
    @Binding var text: String
    var textColor: Color

    func makeUIView(context: Context) -> UITextView {
        let tv = UITextView()
        tv.backgroundColor = .clear
        tv.textColor = UIColor(textColor)
        tv.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        tv.isScrollEnabled = false
        tv.text = text
        tv.keyboardType = .default
        tv.returnKeyType = .done
        tv.autocorrectionType = .no
        tv.delegate = context.coordinator
        tv.textContainerInset = .zero
        tv.textContainer.lineFragmentPadding = 0
        tv.tintColor = UIColor(textColor)
        return tv
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
        uiView.textColor = UIColor(textColor)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: TextEditorWrapper
        init(_ parent: TextEditorWrapper) { self.parent = parent }

        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if text == "\n" {
                textView.resignFirstResponder()
                return false
            }
            return true
        }
    }
}

#Preview {
    Goul(topic: .constant("Swift"), period: .constant("Week"))
}
