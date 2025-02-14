//
//  HomeVC.swift
//  MindMazeExpedition
//
//  Created by MindMaze Expedition on 14/02/25.
//

import Foundation
import UIKit

class ExpeditionHomeVC: UIViewController {

    @IBOutlet weak var titleView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        titleView.transform = CGAffineTransform(rotationAngle: 0.05)  // Slight tilt
    
    }
}
