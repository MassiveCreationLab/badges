//
//  DayView.swift
//  time
//
//  Created by MassiveCreationLab on 08.01.26.
//

import SwiftUI

struct DayView: View {
    let dayOffset: Int

    private var date: Date {
        Calendar.current.date(byAdding: .day, value: dayOffset, to: Date())!
    }

    private var count: Int {
        ProgressStore.shared.count(for: date)
    }

    var body: some View {
        VStack {
            Spacer()

            Image("badge_\(count)")
                .resizable()
                .scaledToFit()

            Spacer()

            if Calendar.current.isDateInToday(date) {
                Button("+1") {
                    ProgressStore.shared.addTap()
                }
            }
        }
    }
}
