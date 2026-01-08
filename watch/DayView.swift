//
//  DayView.swift
//  time
//
//  Created by MassiveCreationLab on 08.01.26.
//

import SwiftUI

struct DayView: View {
    let dayOffset: Int

    @State private var refreshTick = 0
    @State private var crownProgress: Double = 0   // 0...1

    private let commitThreshold: Double = 1.0

    private var date: Date {
        Calendar.current.date(byAdding: .day, value: dayOffset, to: Date())!
    }

    private var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }

    private var count: Int {
        _ = refreshTick
        return ProgressStore.shared.count(for: date)
    }

    var body: some View {
        VStack(spacing: 8) {
            Image("badge_\(count)")
                .resizable()
                .scaledToFit()

            if isToday {
                HStack(spacing: 6) {
                    Image(systemName: "crown")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)

                    ProgressView(value: crownProgress, total: commitThreshold)
                        .frame(width: 90)     // tune this
                        .scaleEffect(y: 0.8)  // thinner
                }
            }
        }
        .focusable(isToday)
        .digitalCrownRotation(
            $crownProgress,
            from: 0,
            through: commitThreshold,
            by: 0.05,
            sensitivity: .low,
            isContinuous: false,
            isHapticFeedbackEnabled: true
        )
        .onChange(of: crownProgress) { _, newValue in
            guard isToday else { return }

            if newValue >= commitThreshold {
                ProgressStore.shared.addTap()
                crownProgress = 0   // reset for next commit
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .progressChanged)) { _ in
            refreshTick += 1
        }
    }
}
