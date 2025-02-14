//
//  UIView+color.swift
//  MindMazeExpedition
//
//  Created by MindMaze Expedition on 14/02/25.
//

import Foundation
import UIKit

extension UIView {
    
    func applyGradient(colours : [UIColor]) -> CAGradientLayer{
        return self.applyGradient(colours: colours, locations: nil)
    }
    
    func applyGradient(colours : [UIColor], locations : [NSNumber]?) -> CAGradientLayer {
        let gradient : CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map{ $0.cgColor }
        gradient.locations = locations
        gradient.startPoint = CGPoint(x: 0, y: 0.1)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.cornerRadius = 25
        gradient.borderWidth = 1
        gradient.borderColor = UIColor.black.cgColor
        
        self.layer.insertSublayer(gradient, at: 0)
        
        return gradient
    }
}
