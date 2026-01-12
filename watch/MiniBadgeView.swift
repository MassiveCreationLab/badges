//
//  MiniBadgeView.swift
//  time
//
//  Created by MassiveCreationLab on 12.01.26.
//

import SwiftUI

struct MiniBadgeView: View {
    let count: Int        // 0...3
    let minor: Double     // 0...1

    private var safeCount: Int {
        min(count, ProgressStore.MAX_BADGE_LEVEL)
    }

    private var color: Color {
        Color.badgeColor(for: safeCount)
    }

    var body: some View {
        ZStack {
            // Background track
            Circle()
                .stroke(color.opacity(0.25), lineWidth: 3)

            // Foreground progress
            Circle()
                .trim(from: 0, to: max(0, min(minor, 1)))
                .stroke(
                    color,
                    style: StrokeStyle(lineWidth: 3, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))

            // Center number
            Text("\(safeCount + 1)")
                .font(.system(size: 10, weight: .bold, design: .rounded))
                .foregroundStyle(color)
        }
        .frame(width: 26, height: 26)
    }
}
