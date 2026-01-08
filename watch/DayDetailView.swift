//
//  DayDetailView.swift
//  time
//
//  Created by MassiveCreationLab on 08.01.26.
//

import SwiftUI

struct DayDetailView: View {
    let date: Date

    var body: some View {
        let entries = ProgressStore.shared.entries(for: date)

        List(entries, id: \.self) { d in
            Text(d.formatted(date: .omitted, time: .shortened))
        }
        .navigationTitle(date.formatted(date: .abbreviated, time: .omitted))
    }
}
