//
//  UnusedUtilities.swift
//  WWDC Student Challenge
//  SpiralGenerator
//
//  Created by Roland Schmitz on 16.05.20.
//  Copyright © 2020 Roland Schmitz
//


import Foundation
import SwiftUI

func scaleTransform(scaleX: CGFloat, scaleY: CGFloat, centerX: CGFloat, centerY: CGFloat) -> CGAffineTransform {
    CGAffineTransform(translationX: -centerX, y: -centerY)
        .concatenating(CGAffineTransform(scaleX: scaleX, y: scaleY))
        .concatenating(CGAffineTransform(translationX: centerX, y: centerY))
}

func scaleTransform(scale: CGFloat, centerX: CGFloat, centerY: CGFloat) -> CGAffineTransform {
    scaleTransform(scaleX: scale, scaleY: scale, centerX: centerX, centerY: centerY)
}

func mirrorHorizontalTransform(centerX: CGFloat, centerY: CGFloat) -> CGAffineTransform {
    CGAffineTransform(scaleX: -1, y: 1)
        .concatenating(CGAffineTransform(translationX: centerX * 2, y: 0))
}

func rotationTransform(angle: CGFloat, centerX: CGFloat, centerY: CGFloat) -> CGAffineTransform {
    CGAffineTransform(translationX: -centerX, y: -centerY)
        .concatenating(CGAffineTransform(rotationAngle: angle))
        .concatenating(CGAffineTransform(translationX: centerX, y: centerY))
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

