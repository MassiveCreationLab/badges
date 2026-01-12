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

        let now = Date()
        let calendar = Calendar.current

        let startOfTomorrow = calendar.startOfDay(
            for: calendar.date(byAdding: .day, value: 1, to: now)!
        )

        // Entry for "now"
        let todayEntry = Entry(
            date: now,
            count: ProgressStore.shared.todayCount(),
            minor: ProgressStore.shared.todayCrownProgress()
        )

        // Entry for "tomorrow" (will be shown at 00:00)
        let tomorrowEntry = Entry(
            date: startOfTomorrow,
            count: 0,
            minor: 0
        )

        let timeline = Timeline(
            entries: [todayEntry, tomorrowEntry],
            policy: .atEnd   // after tomorrow entry is shown, system will ask again
        )

        completion(timeline)
    }


}
