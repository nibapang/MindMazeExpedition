//
//  MazeStartVC.swift
//  MindMazeExpedition
//
//  Created by jin fu on 14/02/25.
//

import Foundation
import UIKit

class ExpeditionMazeStartVC: UIViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var startButtton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.startButtton.applyGradient(colours: [.white, .color2])
        logoImageView.image = UIImage(named: "logo")
        
    }
    
    @IBAction func startTappedButton(_ sender: Any) {
        
    }

}
