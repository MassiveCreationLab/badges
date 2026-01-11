//
//  complication.swift
//  complication
//
//  Created by Daniel Mass on 07.01.26.
//

import WidgetKit
import SwiftUI

struct ComplicationView: View {
    let entry: Entry

    private var safeCount: Int {
        min(entry.count, 3)
    }

    private var color: Color {
        .badgeColor(for: safeCount)
    }

    var body: some View {
        ZStack {
            // Background track
            Circle()
                .stroke(color.opacity(0.25), lineWidth: 6)

            // Foreground progress
            Circle()
                .trim(from: 0, to: max(0, min(entry.minor, 1)))
                .stroke(
                    color,
                    style: StrokeStyle(lineWidth: 6, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))

            // Center number (badge index = count + 1)
            Text("\(safeCount + 1)")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(color)
        }
        .padding(6)
    }
}



@main
struct ProjectComplication: Widget {

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "ProjectComplication", provider: Provider()) { entry in
            ComplicationView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .supportedFamilies([.accessoryCircular])
    }
}



#Preview(as: .accessoryCircular) {
    ProjectComplication()
} timeline: {
    Entry(date: .now, count: 3, minor: 20)
}



extension Color {
    static func badgeColor(for count: Int) -> Color {
        switch count {
        case 0: return Color(red: 0.72, green: 0.45, blue: 0.20) // copper
        case 1: return Color(red: 0.75, green: 0.75, blue: 0.78) // silver
        case 2: return Color(red: 0.90, green: 0.75, blue: 0.25) // gold
        default: return Color(red: 0.35, green: 0.20, blue: 0.55) // dark purple
        }
    }
}
