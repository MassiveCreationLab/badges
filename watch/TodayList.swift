//
//  TodayList.swift
//  time
//
//  Created by MassiveCreationLab on 08.01.26.
//

import SwiftUI

struct TodayList: View {

    @State private var entries: [Date] = []

    var body: some View {
        List {
            ForEach(entries, id: \.self) { date in
                Text(date.formatted(date: .omitted, time: .shortened))
            }
            .onDelete(perform: delete)
        }
        .navigationTitle("Today")
        .onAppear {
            reload()
        }
    }

    private func reload() {
        entries = ProgressStore.shared.todayEntries()
    }

    private func delete(at offsets: IndexSet) {
        for i in offsets {
            let entry = entries[i]
            ProgressStore.shared.delete(entry: entry)
        }
        reload()
    }
}

