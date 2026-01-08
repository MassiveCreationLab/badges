//
//  ProgressStore.swift
//  time
//
//  Created by MassiveCreationLab on 08.01.26.
//

import Foundation

final class ProgressStore {
    static let shared = ProgressStore()

    private let defaults = UserDefaults(suiteName: "group.com.yourcompany.yourapp")!
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

    private func load() -> [String: [Date]] {
        guard let data = defaults.data(forKey: key),
              let decoded = try? JSONDecoder().decode([String: [Date]].self, from: data)
        else { return [:] }
        return decoded
    }

    private func save(_ dict: [String: [Date]]) {
        let data = try! JSONEncoder().encode(dict)
        defaults.set(data, forKey: key)
    }


    func addTap() {
        var dict = load()
        let today = todayKey()
        dict[today, default: []].append(Date())
        save(dict)
        NotificationCenter.default.post(name: .progressChanged, object: nil)
    }

    func todayCount() -> Int {
        let dict = load()
        return dict[todayKey()]?.count ?? 0
    }

    func all() -> [String: [Date]] {
        load()
    }
    
    func todayEntries() -> [Date] {
        let dict = load()
        return dict[todayKey()] ?? []
    }
    
    func count(for date: Date) -> Int {
        let dict = load()
        let key = dayKey(for: date)
        return dict[key]?.count ?? 0
    }

    func entries(for date: Date) -> [Date] {
        let dict = load()
        let key = dayKey(for: date)
        return dict[key] ?? []
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

        guard var arr = dict[key] else { return }

        arr.removeAll { $0 == entry }
        dict[key] = arr
        save(dict)
        NotificationCenter.default.post(name: .progressChanged, object: nil)
    }
}

extension Notification.Name {
    static let progressChanged = Notification.Name("progressChanged")
}
