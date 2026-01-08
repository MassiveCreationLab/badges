//
//  ContentView.swift
//  time Watch App
//
//  Created by Daniel Mass on 07.01.26.
//

import SwiftUI

struct ContentView: View {

    @State private var todayCount = 0

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Image("badge_\(todayCount)")
                    .resizable()
                    .scaledToFit()
                
                Spacer()
                
                Button("+1") {
                    ProgressStore.shared.addTap()
                    reload()
                }
            }
            .onAppear { reload() }
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
            .navigationTitle(titleText)
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func reload() {
        todayCount = ProgressStore.shared.todayCount()
    }
    
    private var titleText: String {
        let f = DateFormatter()
        f.dateFormat = "dd.MM.YYYY"
        return "\(f.string(from: Date()))"
    }
}


#Preview {
    ContentView()
}
