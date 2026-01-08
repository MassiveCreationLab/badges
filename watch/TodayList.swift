//
//  TodayList.swift
//  time
//
//  Created by MassiveCreationLab on 08.01.26.
//

import SwiftUI

struct TodayList: View {

    let entries = ProgressStore.shared.todayEntries()

    var body: some View {
        List(entries, id: \.self) { date in
            Text(date.formatted(date: .omitted, time: .shortened))
        }
        .navigationTitle("Today")
    }
}
