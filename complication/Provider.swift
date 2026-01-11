//
//  Provider.swift
//  time
//
//  Created by MassiveCreationLab on 08.01.26.
//

import WidgetKit

struct Provider: TimelineProvider {

    func placeholder(in context: Context) -> Entry {
        Entry(date: .now, count: 0, minor: 0)
    }

    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        completion(Entry(
            date: .now,
            count: ProgressStore.shared.todayCount(),
            minor: ProgressStore.shared.todayCrownProgress()
        ))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let entry = Entry(
            date: .now,
            count: ProgressStore.shared.todayCount(),
            minor: ProgressStore.shared.todayCrownProgress()
        )

        completion(Timeline(entries: [entry], policy: .never))
    }
}
