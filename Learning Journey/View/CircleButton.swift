import SwiftUI

struct CircleButton: View {
    var systemIcon: String
    var action: (() -> Void)? = nil
    @State private var pressed = false

    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                pressed = true
                action?()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    pressed = false
                }
            }
        }) {
            Image(systemName: systemIcon)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 52, height: 52)
                .background(
                    Circle()
                        .fill(Color.white.opacity(0.08))
                        .background(.ultraThinMaterial)
                        .overlay(
                            Circle().stroke(Color(hex: "#FF9230").opacity(0.4), lineWidth: 1)
                        )
                        .shadow(color: Color(hex: "#FF9230").opacity(0.5), radius: 6, y: 3)
                )
                .scaleEffect(pressed ? 0.9 : 1.0)
        }
        .buttonStyle(.plain)
    }
}
