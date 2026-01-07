//
//  ContentView.swift
//  time Watch App
//
//  Created by Daniel Mass on 07.01.26.
//

import SwiftUI

struct ContentView: View {
    
    @State var count = 0
    
    
    var body: some View {
        VStack {
            Text("Projects")
            Spacer()
            Image("badge_\(count)")
                .resizable()
                .scaledToFit()
                .clipped()
            Spacer()
            Button("+1"){
                count += 1
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ContentView()
}
