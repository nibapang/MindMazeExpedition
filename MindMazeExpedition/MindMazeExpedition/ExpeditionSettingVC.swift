//
//  SettingVC.swift
//  MindMazeExpedition
//
//  Created by MindMaze Expedition on 14/02/25.
//

import Foundation
import UIKit

class ExpeditionSettingVC: UIViewController {
    
    @IBOutlet weak var titleView: UIView!
   
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleView.transform = CGAffineTransform(rotationAngle: 0.05)  // Slight tilt
        
    }
    
    @IBAction func btnBack(_ sender: Any) {
            navigationController?.popViewController(animated: true)
        }

}
