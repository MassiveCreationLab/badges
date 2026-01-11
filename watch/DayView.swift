//
//  DayView.swift
//  time
//
//  Created by MassiveCreationLab on 11.01.26.
//

import SwiftUI

struct DayView: View {
    let dayOffset: Int
    let crownProgress: Double

    @State private var refreshTick = 0

    private var date: Date {
        Calendar.current.date(byAdding: .day, value: dayOffset, to: Date())!
    }

    private var isToday: Bool { Calendar.current.isDateInToday(date) }

    private var rawCount: Int {
        _ = refreshTick
        return ProgressStore.shared.count(for: date)
    }

    private var clampedCount: Int {
        min(rawCount, ProgressStore.MAX_BADGE_LEVEL)
    }

    private var isMaxedOut: Bool {
        rawCount >= ProgressStore.MAX_BADGE_LEVEL
    }

    var body: some View {
        VStack(spacing: 8) {
            Image("badge_\(clampedCount)")
                .resizable()
                .scaledToFit()

            if isToday && !isMaxedOut {
                HStack(spacing: 6) {
                    Image(systemName: "crown")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)

                    ProgressView(value: crownProgress, total: 1.0)
                        .frame(width: 90)
                        .scaleEffect(y: 0.8)
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .progressChanged)) { _ in
            refreshTick += 1
        }
    }
}
