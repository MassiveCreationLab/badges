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

    var body: some View {
        ZStack {
            Circle()
                .fill(.background)
            Image("badge_\(entry.count)s")
                .resizable()
                .scaledToFit()
                .padding(4)
        }
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
    Entry(date: .now, count: 3)
}
