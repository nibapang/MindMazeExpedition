//
//  ManageGameVC.swift
//  MindMazeExpedition
//
//  Created by jin fu on 14/02/25.
//

import Foundation
import UIKit
import AVFoundation

class ExpeditionManageGameVC: UIViewController {
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var brickImage: UIImageView!
    @IBOutlet weak var scorePicker: UIPickerView!
    @IBOutlet weak var pickView: UIView!
    
    var arrows: [ExpeditionArrows?] = []
    let colors: [UIColor] = [.systemPink, .systemPurple, .systemBlue, .systemTeal]
    
    let rows = 8
    let columns = 8
    
    var score: Int = 0
    var scoresList: [Int] = [0]  // This will track the scores for UIPickerView
    
    var times : Int = 0
    
    let music = ExpeditionEffects()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        brickImage.image = UIImage(named: "bricks")
        brickImage.layer.borderWidth = 6
        brickImage.layer.cornerRadius = 5
        brickImage.layer.borderColor = UIColor.lightGray.cgColor
        
        
        // Set the delegate and data source for UIPickerView
        scorePicker.delegate = self
        scorePicker.dataSource = self
        
        pickView.applyGradient(colours: [.white, .color3])
        
        
        
        // Generate arrows with constraints
        arrows = generateConstrainedArrows(rows: rows, columns: columns)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        titleView.transform = CGAffineTransform(rotationAngle: 0.05) // Slight tilt
    }
    
    
    
    @IBAction func btnBackTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func restartGame(){
        times = 0
        score = 0
        scoresList = [0]
        // Generate arrows with constraints
        arrows = generateConstrainedArrows(rows: rows, columns: columns)
        collectionView.reloadData()
        scorePicker.reloadComponent(0)
        
    }
    
    func incrementScore() {
        score += 10
        scoresList.append(score)
        scorePicker.reloadAllComponents()
        
        // Automatically select the latest score in the picker
        scorePicker.selectRow(scoresList.count - 1, inComponent: 0, animated: true)
    }
    
    private func configureCell(_ cell: ExpeditionManageCell, withArrow arrow: ExpeditionArrows) {
        cell.isHidden = false
        cell.arrowImage.image = UIImage(named: arrow.rawValue)
        cell.colorView.backgroundColor = colors.randomElement()
        cell.colorView.layer.cornerRadius = 8
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.white.cgColor
    }
    
    func generateConstrainedArrows(rows: Int, columns: Int) -> [ExpeditionArrows] {
        var arrowsArray: [ExpeditionArrows?] = Array(repeating: nil, count: rows * columns)
        
        for row in 0..<rows {
            var rowHasLeftArrow = false
            var rowHasRightArrow = false
            
            for col in 0..<columns {
                var possibleArrows: [ExpeditionArrows] = [.top, .down, .left, .right]
                
                // Check existing arrows in the row to avoid both ➡️ and ⬅️ in the same row
                if rowHasLeftArrow {
                    possibleArrows.removeAll { $0 == .right }  // Remove ➡️ if ⬅️ exists
                }
                if rowHasRightArrow {
                    possibleArrows.removeAll { $0 == .left }   // Remove ⬅️ if ➡️ exists
                }
                
                // Check existing arrows in the column to avoid both ⬆️ and ⬇️ in the same column
                var columnHasTopArrow = false
                var columnHasDownArrow = false
                
                for r in 0..<row {
                    let index = r * columns + col
                    if arrowsArray[index] == .top {
                        columnHasTopArrow = true
                    }
                    if arrowsArray[index] == .down {
                        columnHasDownArrow = true
                    }
                }
                
                if columnHasTopArrow {
                    possibleArrows.removeAll { $0 == .down }  // Remove ⬇️ if ⬆️ exists in the column
                }
                if columnHasDownArrow {
                    possibleArrows.removeAll { $0 == .top }   // Remove ⬆️ if ⬇️ exists in the column
                }
                
                // Select a random arrow from the valid options
                if let selectedArrow = possibleArrows.randomElement() {
                    arrowsArray[row * columns + col] = selectedArrow
                    
                    // Update row status
                    if selectedArrow == .left { rowHasLeftArrow = true }
                    if selectedArrow == .right { rowHasRightArrow = true }
                }
            }
        }
        
        // Force unwrap the array to convert from [Arrows?] to [Arrows]
        return arrowsArray.compactMap { $0 }
    }
    
    
}

extension ExpeditionManageGameVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrows.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let currentRow = indexPath.item / columns
        let currentColumn = indexPath.item % columns
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ManageCell", for: indexPath) as! ExpeditionManageCell
        
        // Set arrow image from arrows array
        guard let arrow = arrows[indexPath.item] else { return UICollectionViewCell() }
        configureCell(cell, withArrow: arrow)
        
        // Hide diagonal cells
        if currentRow == currentColumn || currentRow + currentColumn == columns - 1 {
            cell.isHidden = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ExpeditionManageCell else { return }
        
        // Get the arrow direction from the arrows array
        guard let selectedArrow = arrows[indexPath.item] else {
            print("No direction assigned to this cell.")
            return
        }
        
        var currentIndex = indexPath.item
        let totalItems = rows * columns
        var canMove = true
        
        // Determine the step based on arrow direction
        var step = 0
        switch selectedArrow {
        case .top:
            step = -columns
        case .down:
            step = columns
        case .left:
            step = -1
        case .right:
            step = 1
        }
        
        // Check for obstacles in the selected direction
        while true {
            let nextIndex = currentIndex + step
            
            // Boundary checks
            if nextIndex < 0 || nextIndex >= totalItems { break }  // Reached grid boundary
            if selectedArrow == .left && nextIndex % columns == columns - 1 { break }  // Left edge check
            if selectedArrow == .right && currentIndex % columns == columns - 1 { break }  // Right edge check
            
            // Check if the next cell is empty
            if let nextCell = collectionView.cellForItem(at: IndexPath(item: nextIndex, section: 0)) as? ExpeditionManageCell,
               !nextCell.isHidden {
                canMove = false  // Obstacle found, cannot move further
                break
            }
            
            currentIndex = nextIndex
        }
        
        // If movement is possible, animate the cell
        if canMove {
            moveCell(cell, inDirection: selectedArrow, at: indexPath)
        } else {
            print("Movement blocked: There is an image in the direction.")
            
            if let blockedCell = collectionView.cellForItem(at: indexPath) as? ExpeditionPingoCell {
                applyShakeAnimation(to: blockedCell)
            }
            
            if times == 3 {
                let vc = storyboard?.instantiateViewController(withIdentifier: "EndGameVC") as! ExpeditionEndGameViewController
                vc.setCloser = {
                    self.restartGame()
                }
                vc.score = scoresList.last
                print("\(scoresList.last ?? 0)")
                navigationController?.pushViewController(vc, animated: true)
            }
            
            times += 1
        }
    }
    
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    
    func applyShakeAnimation(to cell: UICollectionViewCell) {
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.05  // Speed of each shake
        shake.repeatCount = 4  // Number of shakes
        shake.autoreverses = true  // Move back and forth
        
        let fromPoint = CGPoint(x: cell.center.x - 5, y: cell.center.y)
        let toPoint = CGPoint(x: cell.center.x + 5, y: cell.center.y)
        
        shake.fromValue = NSValue(cgPoint: fromPoint)
        shake.toValue = NSValue(cgPoint: toPoint)
        
        cell.layer.add(shake, forKey: "position")
    }
    
    func moveCell(_ cell: ExpeditionManageCell, inDirection direction: ExpeditionArrows, at indexPath: IndexPath) {
        var translation = CGAffineTransform.identity
        
        // Determine the animation translation based on the direction
        switch direction {
        case .top:
            translation = CGAffineTransform(translationX: 0, y: -collectionView.bounds.height / CGFloat(rows))
        case .down:
            translation = CGAffineTransform(translationX: 0, y: collectionView.bounds.height / CGFloat(rows))
        case .left:
            translation = CGAffineTransform(translationX: -collectionView.bounds.width / CGFloat(columns), y: 0)
        case .right:
            translation = CGAffineTransform(translationX: collectionView.bounds.width / CGFloat(columns), y: 0)
        }
        
        // Animate the cell movement
        UIView.animate(withDuration: 1.0, animations: {
            cell.transform = translation
            cell.alpha = 0
        }) { _ in
            self.music.playSound()
            cell.isHidden = true
            self.arrows[indexPath.item] = nil  // Mark the moved cell as empty in the arrows array
            
            self.incrementScore()  // Increase the score after a successful move
            print("Cell moved in direction: \(direction)")
           
            
        }
    }
    
    // Set cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 8 - 2, height: collectionView.frame.height / 8 - 2)
    }
    
}

extension ExpeditionManageGameVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
    // Number of columns in the picker (we only need 1)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Number of rows in the picker (equal to the number of scores)
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return scoresList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let scoreText = "\(scoresList[row])"
        
        // Replace "Helvetica-Bold" with the desired font name
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Helvetica-Bold", size: 30) ?? UIFont.systemFont(ofSize: 30),  // Fallback to system font if the custom font is not found
            .foregroundColor: UIColor.black
        ]
        
        return NSAttributedString(string: scoreText, attributes: attributes)
    }
    
}
