//
//  CapsuleInfo.swift
//  Learning Journey
//
//  Created by Aryam on 23/10/2025.
//
import SwiftUI

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
        VStack(spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(iconColor)

                Text("\(value)")
                    .font(.system(size: valueSize, weight: .bold))
                    .foregroundColor(.white)
            }

            Text(label)
                .font(.system(size: labelSize))
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(width: capsuleWidth, height: capsuleHeight)
        .background(
            Capsule()
                .fill(color) // اللون الأساسي فقط بدون أي خلفية رمادية
        )
        .shadow(color: color.opacity(0.4), radius: 8, y: 3) // توهج ناعم
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    CapsuleInfo(
        icon: "flame.fill",
        iconColor: .white,
        value: 3,
        label: "Days Learned",
        color: Color(hex: "#C1642E"),
        valueSize: 20,
        labelSize: 16,
        capsuleHeight: 60,
        capsuleWidth: 150
    )
    .padding()
    .background(Color.black)
}
