//
//  GridduelGameVC.swift
//  MindMazeExpedition
//
//  Created by MindMaze Expedition on 14/02/25.
//

import Foundation
import UIKit

class ExpeditionGridduelGameViewController: UIViewController {
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var puzzelCollectionView: UICollectionView!
    @IBOutlet weak var player_One: UIView!
    @IBOutlet weak var player_Two: UIView!
    
    private var isPlayerOneTurn = true
    private var gameState = Array(repeating: Array(repeating: "", count: 3), count: 3)
    private var winningLineLayer: CAShapeLayer?
    private var progressLayerPlayerOne: CAShapeLayer!
    private var progressLayerPlayerTwo: CAShapeLayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGame()
        titleView.transform = CGAffineTransform(rotationAngle: 0.05) // Slight tilt
        
        player_One.layer.cornerRadius = 8
        player_Two.layer.cornerRadius = 8
    }
    

    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    private func setupGame() {
        puzzelCollectionView.delegate = self
        puzzelCollectionView.dataSource = self
        setupPlayerViews()
        
    }
    
    private func setupPlayerViews() {
        player_One.layer.cornerRadius = 0
        player_Two.layer.cornerRadius = 0
        player_One.clipsToBounds = true
        player_Two.clipsToBounds = true
    }
    
    private func highlightActivePlayer() {
        UIView.animate(withDuration: 0.10) {
            self.player_One.alpha = self.isPlayerOneTurn ? 1 : 0.5
            self.player_Two.alpha = self.isPlayerOneTurn ? 0.5 : 1
        }
    }
    
    
    
    
    private func switchTurn() {
        isPlayerOneTurn.toggle()
        highlightActivePlayer()
        
    }
    
    private func showWinningAlert(winner: String?) {
        let message = winner != nil ? "\(winner!) wins!" : "It's a draw!"
        let alert = UIAlertController(title: "Game Over", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in self.resetGame() }))
        present(alert, animated: true)
    }
    
    private func resetGame() {
        gameState = Array(repeating: Array(repeating: "", count: 3), count: 3)
        isPlayerOneTurn = true
        highlightActivePlayer()
        puzzelCollectionView.reloadData()
        
    }
    
    
    
    
}



extension ExpeditionGridduelGameViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PingoCell", for: indexPath) as! ExpeditionPingoCell
        cell.markImage.image = nil
        
        
        let tab = cell.tabView.layer
        tab.borderColor = UIColor.color4.cgColor
        tab.borderWidth = 3
        tab.cornerRadius = 5
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 3 - 10
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("tap here")
        let cell = collectionView.cellForItem(at: indexPath) as! ExpeditionPingoCell
        let row = indexPath.item / 3
        let col = indexPath.item % 3
        
        guard cell.markImage.image == nil else { return }
        
        cell.markImage.image = isPlayerOneTurn ? UIImage(named: "plate") : UIImage(named: "sine")
        gameState[row][col] = isPlayerOneTurn ? "X" : "O"
        
        if checkWinner() {
            resizeAllCellImages(scale: 0.5)
            DispatchQueue.main.asyncAfter(deadline: .now()  + 1.5, execute: {
                self.showWinningAlert(winner: self.isPlayerOneTurn ? "1" : "2")
            })
        } else if isGameDraw() {
            showWinningAlert(winner: nil)
            // dumbing cell for win
            
        } else {
            switchTurn()
        }
    }
    
    
    func resizeAllCellImages(scale: CGFloat) {
        for i in 0..<9 {
            if let cell = puzzelCollectionView.cellForItem(at: IndexPath(item: i, section: 0)) as? ExpeditionPingoCell {
                UIView.animate(withDuration: 0.5) {
                    // Apply scaling transformation to the image
                    cell.markImage.transform = CGAffineTransform(scaleX: scale, y: scale)
                }
            }
        }
        
        // Optionally disable further interaction after resizing
        highlighledAllCells()
    }
    
    
    func highlighledAllCells() {
        for i in 0..<9 {
            if let cell = puzzelCollectionView.cellForItem(at: IndexPath(item: i, section: 0)) as? ExpeditionPingoCell {
               
                // Reset the image size to its original scale
                UIView.animate(withDuration: 0.3) {
                    cell.markImage.transform = CGAffineTransform.identity  // Reset any scaling to original size
                }
            }
        }
    }
    
    
    private func isGameDraw() -> Bool {
        return !gameState.flatMap { $0 }.contains("")
    }
    
    private func checkWinner() -> Bool {
        // Remove any existing line
        winningLineLayer?.removeFromSuperlayer()
        
        for i in 0..<3 {
            // Check rows
            if gameState[i][0] != "" && gameState[i][0] == gameState[i][1] && gameState[i][1] == gameState[i][2] {
                drawWinningLine(from: indexPathFor(row: i, col: 0), to: indexPathFor(row: i, col: 2))
                return true
            }
            // Check columns
            if gameState[0][i] != "" && gameState[0][i] == gameState[1][i] && gameState[1][i] == gameState[2][i] {
                drawWinningLine(from: indexPathFor(row: 0, col: i), to: indexPathFor(row: 2, col: i))
                return true
            }
        }

        // Check main diagonal
        if gameState[0][0] != "" && gameState[0][0] == gameState[1][1] && gameState[1][1] == gameState[2][2] {
            drawWinningLine(from: indexPathFor(row: 0, col: 0), to: indexPathFor(row: 2, col: 2))
            return true
        }
        // Check anti-diagonal
        if gameState[0][2] != "" && gameState[0][2] == gameState[1][1] && gameState[1][1] == gameState[2][0] {
            drawWinningLine(from: indexPathFor(row: 0, col: 2), to: indexPathFor(row: 2, col: 0))
            return true
        }

        return false
    }

    func indexPathFor(row: Int, col: Int) -> IndexPath {
        return IndexPath(item: row * 3 + col, section: 0)
    }

    func drawWinningLine(from startIndexPath: IndexPath, to endIndexPath: IndexPath) {
        guard let startCell = puzzelCollectionView.cellForItem(at: startIndexPath),
              let endCell = puzzelCollectionView.cellForItem(at: endIndexPath) else { return }
        
        let startCenter = startCell.center
        let endCenter = endCell.center
        
        
        let linePath = UIBezierPath()
        linePath.move(to: startCenter)
        linePath.addLine(to: endCenter)
        
        winningLineLayer = CAShapeLayer()
        winningLineLayer?.path = linePath.cgPath
        winningLineLayer?.strokeColor = UIColor.color6.cgColor
        winningLineLayer?.lineWidth = 15.0
        winningLineLayer?.lineCap = .round
        winningLineLayer?.strokeEnd = 0
        winningLineLayer?.shadowRadius = 5
        
        puzzelCollectionView.layer.addSublayer(winningLineLayer!)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 1.0
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        winningLineLayer?.add(animation, forKey: "lineDrawing")
        
       
    }
    
    
    
    
    
    
    
    
    
    
}
