//
//  InnerRotation.swift
//  WWDC Student Challenge
//  SpiralGenerator
//
//  Created by Roland Schmitz on 16.05.20.
//  Copyright © 2020 Roland Schmitz
//

import SwiftUI

/**
 The InnerRotation View shows the behaviour of a special affine transformation.
 I call the transformation *inner rotation*.
 
 If you draw a rectangle once with and once without the the inner rotation
 transformation then you get an outer rectangle and an inner rectangle which
 has its corners exactly on the edges of the outer rectangle.
 
 When generating the inner rotation you can provide a ratio between 0 and 1
 which describes where on the outer edge the inner corner is placed.
 
 Run the code to see the iner rotation in action and generate a nice spiral!
 
 */

public struct InnerRotation: View {

    /// state value for the edge length of the rectangle
    @State var edgeLength = CGFloat(250)

    /// state value for rotation ratio in percent
    @State var innerRotationPercentage = CGFloat(17)

    /// state value for the overall number of rectangles which
    /// are repeatedly drawn inside each other
    @State var iterations = 2
    
    public var body: some View {
        return ZStack {
            ZStack {
                Spiral(
                    steps: iterations,
                    offsetRatio: innerRotationPercentage / 100.0,
                    edgeLength: edgeLength
                )
                
                nextPageView()
                
            }.padding(20)
            settingsView()
        }
    }
    
    public init() {}

    /// The Icons for the slider labels in the settings view are enerated at runtime:
    let smallRectangleIcon = Spiral(steps: 2, offsetRatio: 0.5, edgeLength: 10, color: Color(.label))
    let bigRectangleIcon = Spiral(steps: 2, offsetRatio: 0.5, edgeLength: 30, color: Color(.label))
    let rightRotationIcon = Spiral(steps: 2, offsetRatio: 0.2, edgeLength: 20, lineWidth: 1, color: Color(.label))
    let leftRotationIcon = Spiral(steps: 2, offsetRatio: 0.8, edgeLength: 20, lineWidth: 1, color: Color(.label))
    
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
                            
                            Slider(value: $innerRotationPercentage, in: 0...100,
                                   minimumValueLabel: rightRotationIcon,
                                   maximumValueLabel: leftRotationIcon
                            ) { Text("Inner Rotation") }
                            
                            Stepper("\(iterations) Iterations", value: $iterations, in: 1...99, step: 1)
                            
                            /// show the resulting inner rotation matrix
                            Text("Inner Rotation Transformation:").padding(.top, 10)
                            CGAffineTransformView(
                                innerRotationTransform(
                                    offsetRatio: innerRotationPercentage / 100,
                                    centerX: edgeLength/2,
                                    centerY: edgeLength/2))

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
let _ = PlaygroundPage.current.setLiveView(InnerRotation())
let _ = ( PlaygroundPage.current.wantsFullScreenLiveView = true )

#endif
