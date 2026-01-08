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

    private var date: Date {
        Calendar.current.date(byAdding: .day, value: dayOffset, to: Date())!
    }

    private var count: Int {
        _ = refreshTick   // force recompute
        return ProgressStore.shared.count(for: date)
    }

    var body: some View {
        VStack {
            Image("badge_\(count)")
                .resizable()
                .scaledToFit()

            if Calendar.current.isDateInToday(date) {
                Button("+1") {
                    ProgressStore.shared.addTap()
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .progressChanged)) { _ in
            refreshTick += 1
        }
    }
}
