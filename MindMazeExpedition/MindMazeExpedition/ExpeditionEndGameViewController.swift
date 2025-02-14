//
//  EndGameVC.swift
//  MindMazeExpedition
//
//  Created by jin fu on 14/02/25.
//

import Foundation
import UIKit
import SwiftConfettiView

class ExpeditionEndGameViewController: UIViewController {
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var confettiContainerView: UIView!  // Renamed to differentiate from SwiftConfettiView
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    var score: Int?
    var setCloser: (() -> Void)?  // Made optional to avoid initialization issues
    
    private var confettiView: SwiftConfettiView?  // Confetti view to manage the confetti effect

    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.isHidden = true  // Hiding back button
        
        // Displaying the score
        scoreLabel.text = "\(score ?? 0)"
        
        // UI customizations
        titleView.transform = CGAffineTransform(rotationAngle: 0.05)  // Slight tilt
        restartButton.applyGradient(colours: [.white, .color2])
        homeButton.applyGradient(colours: [.white, .color2])
        
        // Confetti setup
        confettiView = SwiftConfettiView(frame: self.view.bounds)
        confettiView?.type = .star
        if let confettiView = confettiView {
            confettiContainerView.addSubview(confettiView)
            confettiView.startConfetti()
        }
    }
    
    @IBAction func btnHomeTapped(_ sender: Any) {
        confettiView?.stopConfetti()  // Stop confetti animation
        
        if let viewControllers = navigationController?.viewControllers {
            for vc in viewControllers {
                if vc is ExpeditionHomeVC {
                    navigationController?.popToViewController(vc, animated: true)
                    return
                }
            }
        }
        
        // If MazeStartVC is not found, navigate to root as a fallback
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func btnRestartTapped(_ sender: Any) {
        confettiView?.stopConfetti()  // Stop confetti animation
        
        setCloser?()  // Call the closure if it's set
        
        navigationController?.popViewController(animated: true)  // Pop back to the game screen
    }
}
