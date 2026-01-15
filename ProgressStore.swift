//
//  ProgressStore.swift
//  time
//
//  Created by MassiveCreationLab on 08.01.26.
//

import Foundation
import WidgetKit

struct DayProgress: Codable {
    var taps: [Date]
    var crownProgress: Double   // 0.0 ... 1.0
}

final class ProgressStore {
    static let shared = ProgressStore()
    static let MAX_BADGE_LEVEL = 3

    private let defaults = UserDefaults(suiteName: "group.com.massivecreationlab.badges")!
    private let key = "progressByDay"

    private let dayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.timeZone = .current
        return f
    }()

    private func todayKey() -> String {
        dayFormatter.string(from: Date())
    }

    private func load() -> [String: DayProgress] {
        guard let data = defaults.data(forKey: key),
              let decoded = try? JSONDecoder().decode([String: DayProgress].self, from: data)
        else { return [:] }
        return decoded
    }
    
    func todayCrownProgress() -> Double {
        let dict = load()
        return dict[todayKey()]?.crownProgress ?? 0
    }

    func crownProgress(for date: Date) -> Double {
        let dict = load()
        let key = dayKey(for: date)
        return dict[key]?.crownProgress ?? 0
    }
    
    func setTodayCrownProgress(_ value: Double) {
        var dict = load()
        let key = todayKey()
        var day = dict[key] ?? DayProgress(taps: [], crownProgress: 0)
        day.crownProgress = value
        dict[key] = day
        save(dict)

        NotificationCenter.default.post(name: .progressChanged, object: nil)
        WidgetCenter.shared.reloadAllTimelines()
    }


    private func save(_ dict: [String: DayProgress]) {
        let data = try! JSONEncoder().encode(dict)
        defaults.set(data, forKey: key)
    }


    func addTap() {
        let key = todayKey()
        var dict = load()

        var day = dict[key] ?? DayProgress(taps: [], crownProgress: 0)

        guard day.taps.count < ProgressStore.MAX_BADGE_LEVEL else { return }

        day.taps.append(Date())
        day.crownProgress = 0   // reset minor progress after commit

        dict[key] = day
        save(dict)

        NotificationCenter.default.post(name: .progressChanged, object: nil)
        WidgetCenter.shared.reloadAllTimelines()
    }



    func todayCount() -> Int {
        let dict = load()
        return dict[todayKey()]?.taps.count ?? 0
    }

    func all() -> [String: DayProgress] {
        load()
    }

    func todayEntries() -> [Date] {
        let dict = load()
        return dict[todayKey()]?.taps ?? []
    }

    func count(for date: Date) -> Int {
        let dict = load()
        let key = dayKey(for: date)
        return dict[key]?.taps.count ?? 0
    }

    func entries(for date: Date) -> [Date] {
        let dict = load()
        let key = dayKey(for: date)
        return dict[key]?.taps ?? []
    }

    private func dayKey(for date: Date) -> String {
        dayFormatter.string(from: date)
    }

    func allDays() -> [Date] {
        let dict = load()
        let f = dayFormatter
        return dict.keys.compactMap { f.date(from: $0) }.sorted(by: >)
    }

    func delete(entry: Date, for date: Date = Date()) {
        var dict = load()
        let key = dayKey(for: date)

        guard var day = dict[key] else { return }

        day.taps.removeAll { $0 == entry }

        dict[key] = day
        save(dict)

        NotificationCenter.default.post(name: .progressChanged, object: nil)
        WidgetCenter.shared.reloadAllTimelines()
    }

}

extension Notification.Name {
    static let progressChanged = Notification.Name("progressChanged")
}
