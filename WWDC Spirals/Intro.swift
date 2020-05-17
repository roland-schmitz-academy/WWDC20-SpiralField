//
//  Intro.swift
//  WWDC Spirals
//
//  Created by Roland Schmitz on 17.05.20.
//  Copyright © 2020 2rs. All rights reserved.
//

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
 
 #### Lets try it

 With just a few lines of code you can draw a shape with SwiftUI in Playgrounds:
 */

#if canImport(PlaygroundSupport)

import PlaygroundSupport
import SwiftUI

let _ = PlaygroundPage.current.setLiveView(
   VStack {
       Spacer()
       Rectangle().fill().frame(width: 100, height: 100)
       Spacer()
       nextPageButton()
   }.padding()
)

#endif

/**
 Run the code! It should show a simple rectangle.
 
 If you want to experiment a bit try to
 replace `Rectangle()` with `Circle()` or
 with `RoundedRectangle(cornerRadius: 10)`.
 
 Or try to replace `fill()` with `stroke(lineWidth: 5)` or
 add a `.foregroundColor(.orange)` modifier after the `.fill()`.
 
 Now lets go to the next page to see some Affine Transformations.
 
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

