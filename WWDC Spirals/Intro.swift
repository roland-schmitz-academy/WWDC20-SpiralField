//
//  Intro.swift
//  WWDC Spirals
//
//  Created by Roland Schmitz on 17.05.20.
//  Copyright © 2020 2rs. All rights reserved.
//

import SwiftUI

/**
 # The Beauty of Affine Transformations with SwiftUI
 
 ## Intro
 
 ### What are Affine Transformations?

 Affine Transformations are geometric transformations which are common in graphical computer systems.
 
 They can be easily used for
 
 - scaling,
 - rotation and
 - translation
 
 of
 
 - individual points,
 - lines,
 - shapes,
 - graphical assets,
 - pictures,
 - videos and even
 - Bezier curves.
 
 The concept of Affine Transformations is not new.
 It is used in classic graphical systems and also in modern systems.
 Two examples with 44 years in between:
 
 * Graphical Kernel System which was introduced in 1977
 * SwiftUI which was introduced in 2019.

 ### What is SwiftUI?

 Here is a quote from Apples Documentation about SwiftUI:
 
    *SwiftUI is an innovative, exceptionally simple way to build user interfaces across all Apple platforms with the power of Swift.*
 
 With SwiftUI you can easily write responsive, reactive UIs in a declarative style
 without any boilerplate code and connect the components with different data providers via
 the Combine framework.
 
 And now you can also use SwiftUI with Playgrounds.
 
 With just a few lines of code you can draw a shape with SwiftUI in Playgrounds:

 ````
 import SwiftUI
 import PlaygroundSupport

 PlaygroundPage.current.setLiveView(
    Rectangle().fill().frame(width: 100, height: 100)
 )
````
 
 Run the code on this page to see a Rectangle and another one which is
 transformed by a CGAffineTransform.
 
 The Matrix shows the content of the CGAffineTransform.identity.
 Try to change some of the values to see what happens.
 
 If you want to experiment, find the Rectangle in the code of this page and
 try to replace `Rectangle()` with `Circle()` or
 with `RoundedRectangle(cornerRadius: 10)`.
 
 Or try to replace `fill()` with `stroke(lineWidth: 5)`.
 
 Now lets go to the next page to see some common Affine Transformations.
 
 If you prefer to skip all the explaining steps you can jump directly
 to the Spiral Field page and have fun creating your personal
 drawing.
 
 
 ## Additional Infos
 
 If you have a working internet connection you can find more in depth information by
 navigating the following links:
 
 ### Links to Apple Documentation:
 
 * [CGAffineTransform - Core Graphics | Apple Developer Documentation](https://developer.apple.com/documentation/coregraphics/cgaffinetransform)
 * Framework: Core Graphics
 * SDKs: iOS 2.0+, macOS 10.0+, Mac Catalyst 13.0+, tvOS 9.0+, watchOS 2.0+
 * [AffineTransform - Foundation | Apple Developer Documentation](https://developer.apple.com/documentation/foundation/affinetransform)
 - Framework: Foundation
 - SDKs: macOS 10.9+
 * [Working with Matrices | Apple Developer Documentation](https://developer.apple.com/documentation/accelerate/working_with_matrices)
 * Framework: Accelerate
 
 ### External Links
 
 * [Affine transformation - Wikipedia](https://en.wikipedia.org/wiki/Affine_transformation)
 * [What are Affine Transformations? - Computer Graphics Stack Exchange](https://computergraphics.stackexchange.com/questions/391/what-are-affine-transformations)
 * [Graphical Kernel System - Wikipedia](https://en.wikipedia.org/wiki/Graphical_Kernel_System)
 
 */

struct MatrixDemo: View {

    // edge length of the original rectangle
    let edgeLength: CGFloat = 100

    @State var transformation: CGAffineTransform = CGAffineTransform(a: 0.9, b: 0.1, c: -0.1, d: 0.9, tx: 10, ty: 0)


    public var body: some View {

        return ZStack {
            
            ZStack {
                Goal(message: "Try changing the coefficients of the matrix and understand what happens!")
                
                /// Draw a gray Rectangle without transformation
                Rectangle().stroke(lineWidth: 5).frame(width: 100, height: 100).foregroundColor(.gray)
                
                /// Draw an orange Rectangle with transformation
                Rectangle().transform(transformation).fill().frame(width: 100, height: 100).foregroundColor(.orange).opacity(0.8)
                
                nextPageView()
                
            }.padding(20)
            settingsView(t: transformation)
        }
    }
    

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
                            
                            /// show an editable transformation matrix
                            Text("Transformation:").padding(.top, 10)
                            EditableCGAffineTransformView(t: $transformation)
                            
                            Button(action: { self.showSettings = false }) {
                                HStack {
                                    Image(systemName: "xmark.circle.fill").font(.headline).padding(.top, 10)
                                    Spacer()

                                }
                            }
                        }   .frame(maxWidth: 200, alignment: .topTrailing)
                            .padding(10)
                            .background(Color(.systemGray2).opacity(0.7))
                            .cornerRadius(20)
                            .padding(10)
                        
                    } else {
                        Button(action: { self.showSettings = true }) {
                            Image(systemName: "gear").font(.headline).aspectRatio(contentMode: .fit)
                        }
                        .padding(10)
                        .background(Color(.systemGray2).opacity(0.7))
                        .cornerRadius(20)
                        .padding(10)
                    }
                }.animation(.spring())
                Spacer()
            }
        )
    }
}

public struct EditableCGAffineTransformView : View {
    @Binding public var t: CGAffineTransform
    
    //public init(_ t: CGAffineTransform) { self.t = t }
    
    public var body: some View {
        
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                AdjustableValue(value: $t.a, step: 0.1)
                AdjustableValue(value: $t.b, step: 0.1)
            }
            HStack(spacing: 10) {
                AdjustableValue(value: $t.c, step: 0.1)
                AdjustableValue(value: $t.d, step: 0.1)
            }
            HStack(spacing: 10) {
                AdjustableValue(value: $t.tx, step: 5)
                AdjustableValue(value: $t.ty, step: 5)
            }
            Button( action: {self.t = CGAffineTransform.identity}) {
                Text("Reset")
            }
        }.padding().overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(.gray)).padding(2)
    }
}

public struct AdjustableValue : View {
    @Binding var value: CGFloat
    public var step: CGFloat = 1
    public var body: some View {
        HStack {
            Text("\(value, specifier: "%.1f")")
            VStack {
                Button( action: {self.value += self.step}) {
                    Text("+").font(.body).bold().padding(2)
                }
                Button( action: {self.value -= self.step}) {
                    Text("-").font(.body).bold().padding(2)
                }
            }.padding(2).background(Color(.tertiarySystemBackground).opacity(0.6)).cornerRadius(5)
        }

    }
}

/// The "Enable Results" feature has been disabled on
/// this page in the manifest due to performance reasons

#if canImport(PlaygroundSupport)

import PlaygroundSupport
let _ = PlaygroundPage.current.setLiveView(MatrixDemo())
let _ = ( PlaygroundPage.current.wantsFullScreenLiveView = true )

#endif
