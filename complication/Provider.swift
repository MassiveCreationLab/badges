//
//  Provider.swift
//  time
//
//  Created by MassiveCreationLab on 08.01.26.
//

import WidgetKit

struct Provider: TimelineProvider {

    func placeholder(in context: Context) -> Entry {
        Entry(date: Date(), count: 0)
    }

    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        completion(Entry(date: Date(), count: ProgressStore.shared.todayCount()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let count = ProgressStore.shared.todayCount()
        let entry = Entry(date: Date(), count: count)

        // Reload when system feels like it, AND when app pushes reload
        completion(Timeline(entries: [entry], policy: .never))
    }
}
