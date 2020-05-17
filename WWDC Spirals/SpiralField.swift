//
//  SpiralField.swift
//  WWDC Student Challenge
//  SpiralGenerator
//
//  Created by Roland Schmitz on 14.05.20.
//  Copyright © 2020 Roland Schmitz
//

import SwiftUI

/**
 The SpiralField View lets you play with many spirals side by side.
 You can play with a lot of settings and create your personal
 spiral field.
 
 Run the code and play with the settings and
 take screenshot of your favourites.
 
 */

struct SpiralField: View {
    
    /// state value for all the settings
    @State var edgeLength = CGFloat(250)
    @State var innerRotationPercentage = CGFloat(17)
    @State var iterations = 17
    @State var squareCornerRadius = CGFloat(20)
    @State var rowCount = 2
    @State var columnCount = 2
    @State var alternating = false
    
    public var body: some View {

        /// only one right turning spiral is generated and used multiple times
        let spiralR = Spiral(
            steps: iterations,
            offsetRatio: innerRotationPercentage / 100.0,
            edgeLength: edgeLength,
            cornerRadius: squareCornerRadius
        )

        /// only one right turning spiral is generated and used multiple times
        let spiralL = Spiral(
            steps: iterations,
            offsetRatio: (100 - innerRotationPercentage) / 100.0,
            edgeLength: edgeLength,
            cornerRadius: squareCornerRadius
        )

        /// loops to generate repeated copies of the spirals in multiple rows and columns
        return ZStack {
            ForEach(1...self.rowCount, id: \.self) { row in
                ForEach<ClosedRange<Int>, Int, AnyView>(1...self.columnCount, id: \.self) { column in
                    
                    /// if *alternate* switch is active, then two alternating spirals are used
                    let spiral = (self.alternating && ((row + column) % 2) == 0) ? spiralL : spiralR
                    
                    /// offset the spirals to have them side by side without gaps
                    return AnyView( spiral.offset(
                        x: CGFloat(column*2 - self.columnCount - 1) * self.edgeLength / 2,
                        y: CGFloat(row*2 - self.rowCount - 1) * self.edgeLength / 2))
                }
            }
            settingsView()
        }
    }

    public init() {}

    /// The Icons for the slider labels in the settings view are enerated at runtime:
    let smallRectangleIcon = Spiral(steps: 2, offsetRatio: 0.5, edgeLength: 10, color: Color(.label))
    let bigRectangleIcon = Spiral(steps: 2, offsetRatio: 0.5, edgeLength: 30, color: Color(.label))
    let rightRotationIcon = Spiral(steps: 2, offsetRatio: 0.2, edgeLength: 20, lineWidth: 1, color: Color(.label))
    let leftRotationIcon = Spiral(steps: 2, offsetRatio: 0.8, edgeLength: 20, lineWidth: 1, color: Color(.label))
    let rectangularCornerIcon = Spiral(steps: 2, offsetRatio: 0.4, edgeLength: 30, cornerRadius: 0, color: Color(.label))
    let roundedCornerIcon = Spiral(steps: 2, offsetRatio: 0.4, edgeLength: 30, cornerRadius: 9, color: Color(.label))

    /// state variable which defines, if the settings view is visible or not
    @State var showSettings = true
    
    /// create the settingsview
    func settingsView() -> AnyView {

        return AnyView (
            HStack {
                VStack {
                    Spacer()
                    if showSettings {
                        VStack {
                            Slider(value: $edgeLength, in: 10...600,
                                   minimumValueLabel: smallRectangleIcon,
                                   maximumValueLabel: bigRectangleIcon
                            ) {
                                Text("Edge length")
                            }
                            
                            Slider(value: $innerRotationPercentage, in: 0.5...99.5,
                                   minimumValueLabel: rightRotationIcon,
                                   maximumValueLabel: leftRotationIcon
                            ) { Text("Inner Rotation") }
                            
                            Stepper("\(iterations) Iterations", value: $iterations, in: 1...99, step: 2)
                            
                            Stepper("\(rowCount) Rows", value: $rowCount, in: 1...7)
                            
                            Stepper("\(columnCount) Columns", value: $columnCount, in: 1...7)
                            
                            Toggle("Alternating", isOn: $alternating)
                            
                            Slider(value: $squareCornerRadius, in: 0...100,
                                   minimumValueLabel: rectangularCornerIcon,
                                   maximumValueLabel: roundedCornerIcon
                            ) {
                                Text("Square Corner Radius:")
                            }
                            
                            Button(action: { self.showSettings = false }) {
                                HStack {
                                    Image(systemName: "xmark.circle.fill").font(.headline).padding(.top, 10)
                                    Spacer()
                                }
                                
                            }
                        }   .frame(maxWidth: 200, alignment: .topTrailing)
                            .padding(10)
                            .background(Color(.tertiarySystemBackground).opacity(0.6))
                            .cornerRadius(20)
                            .padding(10)
                        
                    } else {
                        Button(action: { self.showSettings = true }) {
                            Image(systemName: "gear").font(.headline).aspectRatio(contentMode: .fit)
                        }
                        .padding(10)
                        .background(Color(.tertiarySystemBackground).opacity(0.6))
                        .cornerRadius(20)
                        .padding(10)
                    }
                }.animation(.spring())
                Spacer()
            }
        )
    }
}


/// The "Enable Results" feature has been disabled on
/// this page in the manifest due to performance reasons

#if canImport(PlaygroundSupport)

import PlaygroundSupport
import SwiftUI
let _ = PlaygroundPage.current.setLiveView(SpiralField())
let _ = ( PlaygroundPage.current.wantsFullScreenLiveView = true )

#endif
