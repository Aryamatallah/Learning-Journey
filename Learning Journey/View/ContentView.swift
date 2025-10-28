//
//  ContentView.swift
//  Learning Journey
//
//  Created by Aryam on 16/10/2025.
//
import SwiftUI

struct ContentView: View {
    @State private var selectedPeriod = "Week"
    @State private var topic = "Swift"
    @State private var navigateToLearning = false
    @Environment(\.colorScheme) private var colorScheme
    @State private var screenHeight = UIScreen.main.bounds.height

    var body: some View {
        NavigationStack {
            ZStack {
                // MARK: - الخلفية الديناميكية
                LinearGradient(
                    colors: [
                        Color(.systemBackground),
                        Color(.secondarySystemBackground)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: screenHeight * 0.035) { // قللنا المسافة العمودية شوي
                    // MARK: - الشعار
                    ZStack {
                        Circle()
                            .fill(
                                colorScheme == .dark
                                ? Color(red: 0.1, green: 0.05, blue: 0.02)
                                : Color(red: 0.97, green: 0.94, blue: 0.90)
                            )
                            .frame(width: screenHeight * 0.13, height: screenHeight * 0.13)
                            .shadow(color: Color(hex: "#C56A2B").opacity(0.4), radius: 8, y: 4)

                        Image(systemName: "flame.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: screenHeight * 0.055, height: screenHeight * 0.055)
                            .foregroundColor(Color(hex: "#C56A2B"))
                    }
                    .padding(.top, screenHeight * 0.07)

                    // MARK: - العنوان
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Hello Learner")
                            .font(.system(size: screenHeight * 0.038, weight: .bold))
                            .foregroundColor(colorScheme == .dark ? .white : .black)

                        Text("This app will help you learn everyday!")
                            .font(.system(size: screenHeight * 0.019))
                            .foregroundColor(colorScheme == .dark ? .gray : .secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 25)

                    // MARK: - حقل الإدخال
                    VStack(alignment: .leading, spacing: 8) {
                        Text("I want to learn")
                            .font(.system(size: screenHeight * 0.022, weight: .medium))
                            .foregroundColor(colorScheme == .dark ? .white : .black)

                        TextField("", text: $topic)
                            .font(.system(size: screenHeight * 0.022))
                            .foregroundColor(colorScheme == .dark ? .white.opacity(0.8) : .black.opacity(0.8))
                            .overlay(
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(
                                        colorScheme == .dark
                                        ? .white.opacity(0.2)
                                        : .gray.opacity(0.4)
                                    ),
                                alignment: .bottom
                            )
                            .tint(Color(hex: "#C56A2B"))
                    }
                    .padding(.horizontal, 25)

                    // MARK: - خيارات المدة
                    VStack(alignment: .leading, spacing: 15) {
                        Text("I want to learn it in a")
                            .font(.system(size: screenHeight * 0.022, weight: .medium))
                            .foregroundColor(colorScheme == .dark ? .white : .black)

                        HStack(spacing: 12) {
                            ForEach(["Week", "Month", "Year"], id: \.self) { period in
                                Button(action: { selectedPeriod = period }) {
                                    Text(period)
                                        .font(.system(size: screenHeight * 0.02, weight: .semibold))
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 26)
                                        .background(
                                            RoundedRectangle(cornerRadius: 28)
                                                .fill(
                                                    selectedPeriod == period
                                                    ? Color(hex: "#C56A2B")
                                                    : (colorScheme == .dark
                                                        ? Color(red: 0.15, green: 0.15, blue: 0.15)
                                                        : Color(red: 0.92, green: 0.92, blue: 0.92))
                                                )
                                        )
                                        .foregroundColor(
                                            selectedPeriod == period
                                            ? .white
                                            : (colorScheme == .dark ? .white : .black)
                                        )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(.horizontal, 25)

                    Spacer()

                    // MARK: - زر البداية
                    NavigationLink(
                        destination: ContentView3(topic: topic, period: selectedPeriod)
                            .navigationBarBackButtonHidden(true),
                        isActive: $navigateToLearning
                    ) {
                        Button(action: {
                            withAnimation {
                                navigateToLearning = true
                            }
                        }) {
                            Text("Start learning")
                                .font(.system(size: screenHeight * 0.022, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: screenHeight * 0.22)
                                .padding(.vertical, 14)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(hex: "#C56A2B"),
                                            Color(hex: "#8B4216")
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .cornerRadius(35)
                                .shadow(color: Color(hex: "#C56A2B").opacity(0.4), radius: 8, y: 4)
                        }
                    }
                    .padding(.bottom, screenHeight * 0.05)
                }
                .padding(.horizontal, 10)
            }
        }
    }
}

#Preview {
    ContentView()
}
