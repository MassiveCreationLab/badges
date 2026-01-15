//
//  ContentView.swift
//  time Watch App
//
//  Created by Daniel Mass on 07.01.26.
//

import SwiftUI

struct ContentView: View {

    @State private var selectedDayOffset = 0

    // Crown accumulator model (no wrap)
    @State private var crownValue: Double = 0
    @State private var lastCrownValue: Double = 0
    @State private var accumulated: Double = 0   // 0...threshold

    private let threshold: Double = 1.0

    private var isTodaySelected: Bool { selectedDayOffset == 0 }

    var body: some View {
        NavigationStack {
            ZStack {
                TabView(selection: $selectedDayOffset) {
                    ForEach(-7...0, id: \.self) { offset in
                        DayView(
                            dayOffset: offset
                        )
                        .tag(offset)
                    }
                }
                .tabViewStyle(.page)
            }
            .focusable(isTodaySelected && !isMaxedOutToday)
            .digitalCrownRotation(
                $crownValue,
                from: -100,              // symmetric range prevents wrap surprises
                through: 100,
                by: 0.05,
                sensitivity: .low,
                isContinuous: false,     // IMPORTANT: no wrap-around
                isHapticFeedbackEnabled: true
            )
            .onAppear { syncFromStore() }
            .onChange(of: selectedDayOffset) { _, newOffset in
                // Only care when landing back on today
                if newOffset == 0 { syncFromStore() }
            }
            .onChange(of: crownValue) { _, newValue in
                guard isTodaySelected else { return }
                guard !isMaxedOutToday else { return }

                let delta = newValue - lastCrownValue
                lastCrownValue = newValue

                // Safety net: ignore jumps (can happen on focus changes / system weirdness)
                if abs(delta) > 5 {
                    return
                }

                accumulated += delta

                // Allow decreasing, but never below zero
                if accumulated < 0 { accumulated = 0 }

                // Commit as many times as needed
                while accumulated >= threshold {
                    if ProgressStore.shared.todayCount() >= ProgressStore.MAX_BADGE_LEVEL {
                        accumulated = 0
                        ProgressStore.shared.setTodayCrownProgress(0)
                        return
                    }
                    ProgressStore.shared.addTap()
                    accumulated -= threshold
                }

                ProgressStore.shared.setTodayCrownProgress(accumulated / threshold)
            }
            .navigationTitle(titleText)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink { HistoryView() } label: { Image(systemName: "calendar") }
                        .buttonStyle(.plain)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink { TodayList() } label: { Image(systemName: "list.bullet") }
                        .buttonStyle(.plain)
                }
            }
        }
    }

    private var isMaxedOutToday: Bool {
        ProgressStore.shared.todayCount() >= ProgressStore.MAX_BADGE_LEVEL
    }

    private func syncFromStore() {
        let minor = ProgressStore.shared.todayCrownProgress() // 0...1
        accumulated = max(0, min(minor, 1)) * threshold

        // Reset crown tracking cleanly (no delta spike)
        crownValue = 0
        lastCrownValue = 0
    }

    private var titleText: String {
        let date = Calendar.current.date(byAdding: .day, value: selectedDayOffset, to: Date())!
        let f = DateFormatter()
        f.dateFormat = "dd.MM"
        return "\(f.string(from: date))"
    }
}





#Preview {
    ContentView()
}
