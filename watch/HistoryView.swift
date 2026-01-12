//
//  HistoryView.swift
//  time
//
//  Created by MassiveCreationLab on 08.01.26.
//

import SwiftUI

struct HistoryView: View {

    @State private var refreshTick = 0

    var body: some View {
        let days = ProgressStore.shared.allDays()

        List(days, id: \.self) { date in
            let count = ProgressStore.shared.count(for: date)
            let minor = ProgressStore.shared.crownProgress(for: date)

            NavigationLink {
                DayDetailView(date: date)
            } label: {
                HStack {
                    MiniBadgeView(count: count, minor: minor)

                    Text(date.formatted(date: .abbreviated, time: .omitted))

                    Spacer()
                }
            }
        }
        .navigationTitle("History")
        .onReceive(NotificationCenter.default.publisher(for: .progressChanged)) { _ in
            refreshTick += 1
        }
    }
}
