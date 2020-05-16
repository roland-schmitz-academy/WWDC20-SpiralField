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
// PlaygroundSupport.PlaygroundPage.current.setLiveView(Rectangle().frame(width: 100, height: 100))


public struct ContentView: View {
    public init() {}
    @State var showSettings = true
    @State var edgeLength = CGFloat(250)
    @State var innerRotationPercentage = CGFloat(17)
    @State var iterations = 17
    @State var squareCornerRadius = CGFloat(20)
    @State var rowCount = 2
    @State var columnCount = 2
    @State var alternating = false
    
    public var body: some View {
        let spiralR = Spiral(
            steps: iterations,
            offsetRatio: innerRotationPercentage / 100.0,
            edgeLength: edgeLength,
            cornerRadius: squareCornerRadius
        )
        let spiralL = Spiral(
            steps: iterations,
            offsetRatio: (100 - innerRotationPercentage) / 100.0,
            edgeLength: edgeLength,
            cornerRadius: squareCornerRadius
        )
        return ZStack {
            ForEach(1...self.rowCount, id: \.self) { row in
                ForEach<ClosedRange<Int>, Int, AnyView>(1...self.columnCount, id: \.self) { column in
                    let spiral = (self.alternating && ((row + column) % 2) == 0) ? spiralL : spiralR
                    return AnyView( spiral.offset(
                        x: CGFloat(column*2 - self.columnCount - 1) * self.edgeLength / 2,
                        y: CGFloat(row*2 - self.rowCount - 1) * self.edgeLength / 2))
                }
            }
            settingsView()
        }
    }
    
    
    let smallRectangleIcon = Spiral(steps: 2, offsetRatio: 0.5, edgeLength: 10, color: Color(.label))
    let bigRectangleIcon = Spiral(steps: 2, offsetRatio: 0.5, edgeLength: 30, color: Color(.label))
    let rightRotationIcon = Spiral(steps: 2, offsetRatio: 0.2, edgeLength: 20, lineWidth: 1, color: Color(.label))
    let leftRotationIcon = Spiral(steps: 2, offsetRatio: 0.8, edgeLength: 20, lineWidth: 1, color: Color(.label))
    let rectangularCornerIcon = Spiral(steps: 2, offsetRatio: 0.4, edgeLength: 30, cornerRadius: 0, color: Color(.label))
    let roundedCornerIcon = Spiral(steps: 2, offsetRatio: 0.4, edgeLength: 30, cornerRadius: 9, color: Color(.label))

    func settingsView() -> AnyView {

        return AnyView (
            HStack {
                VStack {
                    Spacer()
                    if showSettings {
                        VStack {
                            Slider(value: $edgeLength, in: 10...1000,
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

public struct Spiral : View {
    public let steps: Int
    public let offsetRatio: CGFloat
    public let edgeLength: CGFloat
    public let cornerRadius: CGFloat
    public let lineWidth: CGFloat
    public let color: Color
    public var body: some View {
        let step = innerRotationTransform(offsetRatio: offsetRatio, centerX: edgeLength/2, centerY: edgeLength/2)
        let transforms = repeatedTransforms(times: steps, step: step)
        return ZStack {
            ForEach(transforms, id: \.self) {(transform: CGAffineTransform) in
                RoundedRectangle(cornerRadius: self.cornerRadius)
                    .transform(transform)
                    .stroke(lineWidth: self.lineWidth)
                    // if you swap the two lines above (.transform... and .stroke...) then linewidth is also transformed
                    .aspectRatio(contentMode: ContentMode.fit)
                    .frame(width: self.edgeLength, height: self.edgeLength)
                    .foregroundColor(self.color)
            }
        }

    }

    public init(
        steps: Int = 50,
        offsetRatio: CGFloat = 0.1,
        edgeLength: CGFloat = 500,
        cornerRadius: CGFloat = 0,
        lineWidth: CGFloat = 1,
        color: Color = .orange
    ) {
        self.steps = steps
        self.offsetRatio = offsetRatio
        self.edgeLength = edgeLength
        self.cornerRadius = cornerRadius
        self.lineWidth = lineWidth
        self.color = color

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

func repeatedTransforms(
    first: CGAffineTransform = CGAffineTransform.identity,
    times: Int,
    step: CGAffineTransform) -> [CGAffineTransform] {
    var results = [CGAffineTransform]()
    var transform = first
    for _ in (0..<times) {
        results.append(transform)
        transform = transform.concatenating(step)
    }
    return results
}

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


func mirrorHorizontalTransform(centerX: CGFloat, centerY: CGFloat) -> CGAffineTransform {
    CGAffineTransform(scaleX: -1, y: 1)
        .concatenating(CGAffineTransform(translationX: centerX * 2, y: 0))
}

func innerRotationTransform(offsetRatio: CGFloat, centerX: CGFloat, centerY: CGFloat) -> CGAffineTransform {
    CGAffineTransform(translationX: -centerX, y: -centerY)
        .concatenating(CGAffineTransform(a: 1 - offsetRatio, b: offsetRatio, c: 0 - offsetRatio, d: 1 - offsetRatio, tx: 0, ty: 0))
        .concatenating(CGAffineTransform(translationX: centerX, y: centerY))}

func rotationTransform(angle: CGFloat, centerX: CGFloat, centerY: CGFloat) -> CGAffineTransform {
    CGAffineTransform(translationX: -centerX, y: -centerY)
        .concatenating(CGAffineTransform(rotationAngle: angle))
        .concatenating(CGAffineTransform(translationX: centerX, y: centerY))
}

func scaleTransform(scaleX: CGFloat, scaleY: CGFloat, centerX: CGFloat, centerY: CGFloat) -> CGAffineTransform {
    CGAffineTransform(translationX: -centerX, y: -centerY)
        .concatenating(CGAffineTransform(scaleX: scaleX, y: scaleY))
        .concatenating(CGAffineTransform(translationX: centerX, y: centerY))
}

func scaleTransform(scale: CGFloat, centerX: CGFloat, centerY: CGFloat) -> CGAffineTransform {
    scaleTransform(scaleX: scale, scaleY: scale, centerX: centerX, centerY: centerY)
}


