//
//  CardCollectionViewCell.swift
//  Match App
//
//  Created by User on 10/9/19.
//  Copyright © 2019 Tammy Laforest. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
	@IBOutlet weak var frontImageView: UIImageView!
	
	@IBOutlet weak var backImageView: UIImageView!
	
	var card:Card?
	
	func setCard(_ card:Card){
		
		// Keep track of the card passed in
		self.card = card
		
		// Protect from cell reuse. Keep cells invisible
		if card.isMatched == true {
			backImageView.alpha = 0
			frontImageView.alpha = 0
			
			// do not execute further code on mathced card
			return
		}
		else {
			
			// Protect from cell reuse. Keep cells visible
			if card.isMatched == false {
				backImageView.alpha = 1
				frontImageView.alpha = 1
			}
		}
		frontImageView.image = UIImage(named: card.imageName)
		
		if card.isFlipped == true && card.isMatched == false {
			
					UIView.transition(from: backImageView, to: frontImageView, duration: 0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
			
		}
		else {
				UIView.transition(from: frontImageView, to: backImageView, duration: 0, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
		}
		
	}
	
	func flip(){
		UIView.transition(from: backImageView, to: frontImageView, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
	}
	
	func flipBack(){
		
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
			UIView.transition(from: self.frontImageView, to: self.backImageView, duration: 0.3, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
		}
	}
	
	func remove(){
		
		// makes matched imageViews invisible
		backImageView.alpha = 0

		// Animate
		UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
			self.frontImageView.alpha = 0
		}, completion: nil)
	}
}
