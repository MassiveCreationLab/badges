//
//  ContentView.swift
//  time Watch App
//
//  Created by Daniel Mass on 07.01.26.
//

import SwiftUI

struct ContentView: View {

    @State private var selectedDayOffset = 0

    var body: some View {
        NavigationStack {
            TabView(selection: $selectedDayOffset) {
                ForEach(-7...0, id: \.self) { offset in
                    DayView(dayOffset: offset)
                        .tag(offset)
                }
            }
            .tabViewStyle(.page)
            .navigationTitle(titleText)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        TodayList()
                    } label: {
                        Image(systemName: "list.bullet")
                    }
                    .buttonStyle(.plain)
                    .controlSize(.mini)
                }
            }
        }
    }

    private var titleText: String {
        let date = Calendar.current.date(byAdding: .day, value: selectedDayOffset, to: Date())!
        let f = DateFormatter()
        f.dateFormat = "dd.MM"
        return "\(f.string(from: date))"
    }
}



#Preview {
    ContentView()
}
