//
//  SimpleTransformations.swift
//  WWDC Student Challenge
//  SpiralGenerator
//
//  Created by Roland Schmitz on 16.05.20.
//  Copyright © 2020 Roland Schmitz
//

import SwiftUI

/**
 SimpleTransformations View has state variables for some basic transformations:

 - Translation
 - Scaling
 - Rotation

 Affine transformations can be concatenated. Concatenation is implementated
 with a matrix multiplication. The resulting transformation has the same effect
 as if the transformations are done step by step.
 
 Run the code and experiment with the sliders!
 If you want you can try changing the order of the three transformations
 
 */

struct SimpleTransformations: View {

    /// state values for the translation
    @State var offsetX = CGFloat(0)
    @State var offsetY = CGFloat(0)

    /// state values for the scaleing
    @State var scaleX = CGFloat(1)
    @State var scaleY = CGFloat(1)
    
    /// state value for the rotation
    @State var rotationAngle = CGFloat(0)

    // edge length of the original rectangle
    let edgeLength = 100
    
    public var body: some View {

        /// Creation of the CGAffineTransform for the translation
        let translation = CGAffineTransform(translationX: offsetX, y: offsetY)

        /// Creation of the CGAffineTransform for the translation
        let scaling = CGAffineTransform.init(scaleX: scaleX, y: scaleY)

        /// Creation of the CGAffineTransform for the translation
        let rotation = CGAffineTransform(rotationAngle: rotationAngle * .pi / 180)

        /// Combining translation, scaling and rotation.
        /// Try to change the order and see what happens.
        let transformation = translation.concatenating(scaling).concatenating(rotation)
        
        return ZStack {
            
            ZStack {
                
                /// Draw a gray Rectangle without transformation
                Rectangle().stroke(lineWidth: 5).frame(width: 100, height: 100).foregroundColor(.gray)
                
                /// Draw an orange Rectangle with transformation
                Rectangle().transform(transformation).stroke(lineWidth: 5).frame(width: 100, height: 100).foregroundColor(.orange)
                
                nextPageView()
                
            }.padding(20)
            settingsView(t: transformation)
        }
    }
    
    public init() {}

    /// state variable which defines, if the settings view is visible or not
    @State var showSettings = true

    /// create the settingsview
    func settingsView(t: CGAffineTransform) -> AnyView {
        return AnyView (
            HStack {
                VStack {
                    Spacer()
                    if showSettings {
                        VStack {
                            Group {
                                /// sliders for all the adjustable input values
                                Slider(value: $offsetX, in: -100...100,
                                       minimumValueLabel: Text("-100"),
                                       maximumValueLabel: Text("+100")
                                ) {
                                    Text("Translate X")
                                }
                                Text("Translate X: \(offsetX, specifier: "%.1f")")
                                
                                Slider(value: $offsetY, in: -100...100,
                                       minimumValueLabel: Text("-100"),
                                       maximumValueLabel: Text("+100")
                                ) {
                                    Text("Delta Y")
                                }
                                
                                Text("Translate Y: \(offsetY, specifier: "%.1f")")
                                
                                Slider(value: $scaleX, in: -3...3,
                                       minimumValueLabel: Text("-3"),
                                       maximumValueLabel: Text("+3")
                                ) {
                                    Text("Scale X")
                                }
                                Text("Scale X: \(scaleX, specifier: "%.1f")")
                                
                                Slider(value: $scaleY, in: -3...3,
                                       minimumValueLabel: Text("-3"),
                                       maximumValueLabel: Text("+3")
                                ) {
                                    Text("Scale Y")
                                }
                                Text("Scale Y: \(scaleY, specifier: "%.1f")")
                                
                                Slider(value: $rotationAngle, in: -180...180,
                                       minimumValueLabel: Text("-180"),
                                       maximumValueLabel: Text("+180")
                                ) {
                                    Text("Rotation")
                                }
                                Text("Rotation: \(rotationAngle, specifier: "%.0f")°")

                                
                            }
                            
                            /// show the resulting matrix
                            Text("Resulting Transformation Matrix:").padding(.top, 10)
                            CGAffineTransformView(t)
                            
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
let _ = PlaygroundPage.current.setLiveView(SimpleTransformations())
let _ = ( PlaygroundPage.current.wantsFullScreenLiveView = true )

#endif
