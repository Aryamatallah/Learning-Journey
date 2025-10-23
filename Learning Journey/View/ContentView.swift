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

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 35) {
                // Logo
                ZStack {
                    Circle()
                        .fill(Color(red: 0.08, green: 0.05, blue: 0.03))
                        .frame(width: 120, height: 120)
                        .shadow(color: Color(hex: "#C56A2B").opacity(0.4), radius: 10, y: 5)

                    Image(systemName: "flame.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color(hex: "#C56A2B"))
                }
                .padding(.top, 60)

                // Title and subtitle (aligned left)
                VStack(alignment: .leading, spacing: 5) {
                    Text("Hello Learner")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)

                    Text("This app will help you learn everyday!")
                        .font(.system(size: 17))
                        .foregroundColor(Color.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 25)

                // Text input
                VStack(alignment: .leading, spacing: 8) {
                    Text("I want to learn")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)

                    TextField("", text: $topic)
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                        .overlay(Rectangle().frame(height: 1).foregroundColor(.gray), alignment: .bottom)
                }
                .padding(.horizontal, 25)

                // Period selection
                VStack(alignment: .leading, spacing: 15) {
                    Text("I want to learn it in a")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)

                    HStack(spacing: 15) {
                        ForEach(["Week", "Month", "Year"], id: \.self) { period in
                            Button(action: { selectedPeriod = period }) {
                                Text(period)
                                    .font(.system(size: 18, weight: .semibold))
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 30)
                                    .background(
                                        RoundedRectangle(cornerRadius: 30)
                                            .fill(selectedPeriod == period ?
                                                  Color(hex: "#C56A2B") :
                                                  Color(red: 0.15, green: 0.15, blue: 0.15))
                                    )
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
                .padding(.horizontal, 25)

                Spacer()

                // Start button
                Button(action: {
                    print("Start learning tapped!")
                }) {
                    Text("Start learning")
                        .font(.system(size: 19, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 200, height: 29)
                        .padding(.vertical, 16)
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
                        .shadow(color: Color(hex: "#C56A2B").opacity(0.5), radius: 10, y: 5)
                }
                .padding(.horizontal, 25)
                .padding(.bottom, 40)
            }
        }
    }
}

// MARK: - Helper for Hex colors


#Preview {
    ContentView()
}
