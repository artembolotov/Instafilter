//
//  ContentView.swift
//  Instafilter
//
//  Created by artembolotov on 07.03.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var blurAmount = 0.0
    
    var body: some View {
        VStack {
            Text("Hello!")
                .blur(radius: blurAmount)
            
            Slider(value: $blurAmount, in: 0...20)
            
            Button("Random blur") {
                blurAmount = Double.random(in: 0...20)
            }
        }
        .padding()
        .onChange(of: blurAmount) { newValue in
            print("Blur amount changed = \(newValue)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
