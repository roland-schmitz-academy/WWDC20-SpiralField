//
//  ContentView.swift
//  WWDC Student Challenge
//  SpiralGenerator
//
//  Created by Roland Schmitz on 16.05.20.
//  Copyright © 2020 Roland Schmitz
//




import CoreGraphics
import SwiftUI
//import PlaygroundSupport

//PlaygroundPage.current.wantsFullScreenLiveView = true
//PlaygroundPage.current.setLiveView(ContentView())

struct ContentView : View {
    var body: some View {
        NavigationView {
            List() {
                //Intro()
                NavigationLink(destination: SimpleTransformations()) {
                    Text("SimpleTransformations")
                }
                NavigationLink(destination: InnerRotation()) {
                    Text("InnerRotation")
                }
                NavigationLink(destination: SpiralField()) {
                    Text("SpiralField")
                }

            }.navigationBarTitle(Text("WWDC 2020"), displayMode: .inline)
        }
    }
    
}

