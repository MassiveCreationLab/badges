//
//  HistoryView.swift
//  time
//
//  Created by MassiveCreationLab on 08.01.26.
//

import SwiftUI

struct HistoryView: View {

    let days = ProgressStore.shared.allDays()

    var body: some View {
        List(days, id: \.self) { date in
            NavigationLink {
                DayDetailView(date: date)
            } label: {
                Text(date.formatted(date: .abbreviated, time: .omitted))
            }
        }
        .navigationTitle("History")
    }
}
