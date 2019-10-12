//
//  ViewController.swift
//  Match App
//
//  Created by User on 10/9/19.
//  Copyright © 2019 Tammy Laforest. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
	
	@IBOutlet weak var timerLabel: UILabel!
	
	@IBOutlet weak var collectionView: UICollectionView!
	
	var model = CardModel()
	var cardArray = [Card]()
	var firstFlippedCardIndex: IndexPath?
	var timer:Timer?
	var milliseconds:Float = 60 * 1000 // 10 seconds
//	var soundManager = SoundManager()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Call getCards method of CardModel
		cardArray = model.getCards()

		collectionView.delegate = self
		collectionView.dataSource = self
		
		// create timer
		timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
		
		RunLoop.main.add(timer!, forMode: .commonModes)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		SoundManager.playSound(.shuffle)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	// MARK: - Timer Methods
	
	@objc func timerElapsed(){
		
		milliseconds -= 1
		
		// Convert to seconds
		let seconds = String(format: "%.2f", milliseconds/1000)
		
		// Set label
		
		timerLabel.text = "Time Remaining: \(seconds)"
		
		// stop timer at zero
		
		if milliseconds <= 0 {
			timer?.invalidate()
			
			timerLabel.textColor = UIColor.red
			
			// check for unmatched cards
			checkGameEnded()
		}
		
	}
	
	
	// MARK: - UICollectionView Protocol Methods
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
			return cardArray.count
	}
	

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		// Get a CardCollectionViewCell object.
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
		
		// Get card CCV is trying to display.
		let card = cardArray[indexPath.row]
		
		// Set that card for the cell
		cell.setCard(card)
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		// Is there time left
		
		if milliseconds <= 0 {
			return
		}
		
		// Get cell user selected
		let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
		
		// Get card user selected
		let card = cardArray[indexPath.row]
		
		if card.isFlipped == false && card.isMatched == false {
			
			// Flip the card
			cell.flip()
			
			
			//play flip sound
			SoundManager.playSound(.flip)
			
			card.isFlipped = true
			
			// Determine if it is first or second card flipped
			if firstFlippedCardIndex == nil {
				
				firstFlippedCardIndex = indexPath
			}
			else {
				checkForMatches(indexPath)
			}
		}
//		else {
//			// Flip the card back
//			cell.flipBack()
//			card.isFlipped = false
//		}
		

	}
	
	// MARK: Game logic methods
	
	func checkForMatches(_ secondFlippedCardIndex: IndexPath){
		
		// Get the cells for the two cards that were revealed
		
		let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
		
		let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
		
		
		// Get the cards of the two cards that were revealed
		
		let cardOne = cardArray[firstFlippedCardIndex!.row]
		let cardTwo = cardArray[secondFlippedCardIndex.row]

		// compare two cards
		
		if cardOne.imageName == cardTwo.imageName {
			// match
			
			// Play sound
				SoundManager.playSound(.match)
			
			// set status of cards as matched
			cardOne.isMatched = true
			cardTwo.isMatched = true
			
			//remove cards from grid
			// no method
			
			cardOneCell?.remove()
			cardTwoCell?.remove()
			
			// Do unmatched cards remain?
			checkGameEnded()
		}
		else {
			// not  a match
			
			// Play sound
			SoundManager.playSound(.nomatch)
			
			// set status of cards
			cardOne.isFlipped = false
			cardTwo.isFlipped = false
			
			// flip cards back
			cardOneCell?.flipBack()
			cardTwoCell?.flipBack()
			
			
		}
		
		// Tell Collection View to reload if firstCard is nil
		
		if cardOneCell == nil {
			collectionView.reloadItems(at: [firstFlippedCardIndex!])
		}
		
		// Reset property that tracks first card flipped
		firstFlippedCardIndex = nil
		
		
		
		
		
	}
	
	func checkGameEnded() {
		// Unmatched cards remaining?
		
		var isWon = true
		
		for card in cardArray {
			if card.isMatched == false {
				isWon = false
				break
			}
		}
		
		// No. User won.
		
		var title = ""
		var message = ""
		
		if isWon == true {
			if milliseconds > 0 {
				timer?.invalidate()
			}
			title = "Congratulations!"
			message = "You have won!"
		}
		
		// Yes.
	
		else {
				//Time left?
			if milliseconds > 0 {
				return
			}
		
				title = "Game Over"
				message = "You've lost"
			}
			
			showAlert(title, message)
		}
	
		
		// Show message
	func showAlert(_ title:String, _ message:String){
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		
		let alertAction = UIAlertAction(title: "Ok.", style: .default, handler: nil)
		
		alert.addAction(alertAction)
		
		present(alert, animated: true, completion: nil)
		
		
	}
}

