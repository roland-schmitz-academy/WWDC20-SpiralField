//
//  ContentView.swift
//  WWDC Spirals
//
//  Created by Roland Schmitz on 14.05.20.
//  Copyright © 2020 2rs. All rights reserved.
//




import CoreGraphics
import SwiftUI
//import PlaygroundSupport

//PlaygroundPage.current.wantsFullScreenLiveView = true
//PlaygroundPage.current.setLiveView(ContentView())



public struct ContentView: View {
    public init() {}
    @State var showSettings = true
    @State var edgeLength = CGFloat(250)
    @State var innerRotationPercentage = CGFloat(17)
    @State var iterations = 17
    @State var squareCornerRadius = CGFloat(0)
    @State var rowCount = 1
    @State var columnCount = 1
    @State var alternating = false
    
    public var body: some View {
        let normalSpiral = spiralRight()
        let alternateSpiral = spiralLeft()
        return ZStack {
            ForEach(1...self.rowCount, id: \.self) { row in
                ForEach<ClosedRange<Int>, Int, AnyView>(1...self.columnCount, id: \.self) { column in
                    let spiralView = (self.alternating && ((row + column) % 2) == 0) ? alternateSpiral : normalSpiral
                    return AnyView(spiralView.transformEffect(CGAffineTransform.init(translationX: (CGFloat(column - 1) - CGFloat(self.columnCount-1)/CGFloat(2.0)) * self.edgeLength, y: (CGFloat(row - 1) - CGFloat(self.rowCount-1)/CGFloat(2.0)) * self.edgeLength)))
                }
            }
            settingsView()
        }
        
    }
    
    func spiralRight() -> AnyView {
        AnyView(
            spiral(
                steps: self.iterations,
                offsetRatio: self.innerRotationPercentage / 100.0,
                edgeLength: self.edgeLength,
                cornerRadius: self.squareCornerRadius
            )
        )
    }
    
    func spiralLeft() -> AnyView {
        AnyView(
            spiral(
                steps: self.iterations,
                offsetRatio: (100 - self.innerRotationPercentage) / 100.0,
                edgeLength: self.edgeLength,
                cornerRadius: self.squareCornerRadius
            )
        )
    }
    
    let smallRectangleIcon = AnyView(
        spiral(steps: 2, offsetRatio: 0.5, edgeLength: 10, color: Color(.label))
    )

    let bigRectangleIcon = AnyView(
        spiral(steps: 2, offsetRatio: 0.5, edgeLength: 30, color: Color(.label))
    )
        
    let rightRotationIcon = AnyView(
        spiral(steps: 2, offsetRatio: 0.2, edgeLength: 20, lineWidth: 1, color: Color(.label))
    )
        
    let leftRotationIcon = AnyView(
        spiral(steps: 2, offsetRatio: 0.8, edgeLength: 20, lineWidth: 1, color: Color(.label))
    )
        
    let rectangularCornerIcon = AnyView(
        spiral(steps: 2, offsetRatio: 0.4, edgeLength: 30, cornerRadius: 0, color: Color(.label))
    )
        
    let roundedCornerIcon = AnyView(
        spiral(steps: 2, offsetRatio: 0.4, edgeLength: 30, cornerRadius: 9, color: Color(.label))
    )
        
    func settingsView() -> AnyView {
        AnyView (
            HStack {
                VStack {
                    Spacer()
                    if showSettings {
                        VStack {
                            Slider(value: $edgeLength, in: 0...500,
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
                                    Image(systemName: "xmark.circle.fill").font(.headline)
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




func spiral(
    steps: Int = 50,
    offsetRatio: CGFloat = 0.1,
    edgeLength: CGFloat = 500,
    cornerRadius: CGFloat = 0,
    lineWidth: CGFloat = 1,
    color: Color = .orange
) -> some View {
    
    let oneStep = innerRotation(offsetRatio: offsetRatio, edgeLength: edgeLength)
    var currentTransform = CGAffineTransform.identity
    let ts = (1...steps).map { _ -> CGAffineTransform in
        let result: CGAffineTransform = currentTransform
        currentTransform = currentTransform.concatenating(oneStep)
        return result
    }
    return ZStack {
        ForEach(ts, id: \.self) {(t: CGAffineTransform) in
            RoundedRectangle(cornerRadius: cornerRadius)
                .transform(t)
                .stroke(lineWidth: lineWidth)
                // if you swap the two lines above (.transform... and .stroke...) then linewidth is also transformed
                .aspectRatio(contentMode: ContentMode.fit)
                .frame(width: edgeLength, height: edgeLength)
                .foregroundColor(color)
            
        }
    }
}

extension CGAffineTransform : Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(a)
        hasher.combine(b)
        hasher.combine(c)
        hasher.combine(d)
        hasher.combine(tx)
        hasher.combine(ty)
    }
}

func square(
    transform: CGAffineTransform = CGAffineTransform.identity,
    edgeLength: CGFloat = 50,
    cornerRadius: CGFloat = 0,
    lineWidth: CGFloat = 2
) -> some View {
    return RoundedRectangle(cornerRadius: cornerRadius)
        .transform(transform)
        .stroke(lineWidth: lineWidth)
        .aspectRatio(contentMode: ContentMode.fit)
        .frame(width: edgeLength, height: edgeLength)
    
}



func repeatTransform(times: Int, step: CGAffineTransform) -> CGAffineTransform {
    var transform = CGAffineTransform.identity
    (0..<times).forEach {_ in
        transform = transform.concatenating(step)
    }
    return transform
}

func mirrorHorizontal(centerX: CGFloat, centerY: CGFloat) -> CGAffineTransform {
    CGAffineTransform(scaleX: -1, y: 1)
        .concatenating(CGAffineTransform(translationX: centerX * 2, y: 0))
}

func innerRotation(offsetRatio: CGFloat, edgeLength: CGFloat) -> CGAffineTransform {
    CGAffineTransform(translationX: -edgeLength/2, y: -edgeLength/2)
        .concatenating(CGAffineTransform(a: 1 - offsetRatio, b: offsetRatio, c: 0 - offsetRatio, d: 1 - offsetRatio, tx: 0, ty: 0))
        .concatenating(CGAffineTransform(translationX: edgeLength/2, y: edgeLength/2))}

func cornerOnEdgeRotation(offsetRatio: CGFloat, centerX: CGFloat, centerY: CGFloat) -> CGAffineTransform {
    CGAffineTransform(translationX: -centerX, y: -centerY)
        .concatenating(CGAffineTransform(a: 1 - offsetRatio, b: offsetRatio, c: 0 - offsetRatio, d: 1 - offsetRatio, tx: 0, ty: 0))
        .concatenating(CGAffineTransform(translationX: centerX, y: centerY))}

struct Matrix : View {
    @Binding var t: CGAffineTransform
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                Text("\(t.a)")
                Text("\(t.b)")
            }
            HStack(spacing: 10) {
                Text("\(t.c)")
                Text("\(t.d)")
            }
            HStack(spacing: 10) {
                Text("\(t.tx)")
                Text("\(t.ty)")
            }
        }
    }
}

func affineTransform (rotationAngle: CGFloat, centerX: CGFloat, centerY: CGFloat) -> CGAffineTransform {
    CGAffineTransform(translationX: -centerX, y: -centerY)
        .concatenating(CGAffineTransform(rotationAngle: rotationAngle))
        .concatenating(CGAffineTransform(translationX: centerX, y: centerY))
}

func affineTransform(scaleX: CGFloat, scaleY: CGFloat, centerX: CGFloat, centerY: CGFloat) -> CGAffineTransform {
    CGAffineTransform(translationX: -centerX, y: -centerY)
        .concatenating(CGAffineTransform(scaleX: scaleX, y: scaleY))
        .concatenating(CGAffineTransform(translationX: centerX, y: centerY))
}

func affineTransform(scale: CGFloat, centerX: CGFloat, centerY: CGFloat) -> CGAffineTransform {
    affineTransform(scaleX: scale, scaleY: scale, centerX: centerX, centerY: centerY)
}


