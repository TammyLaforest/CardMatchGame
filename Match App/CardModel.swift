//
//  CardModel.swift
//  Match App
//
//  Created by User on 10/9/19.
//  Copyright © 2019 Tammy Laforest. All rights reserved.
//

import Foundation

class CardModel {
	
	// Store numbers we've already generated
	var generatedNumbersArray = [Int]()
	
	func getCards() -> [Card] {
		// Declare array to store generated cards
		var generatedCardsArray = [Card]()
		
		// randomly generate pairs of cards
		
	
		while generatedNumbersArray.count < 8 {
			
			// Get random number
			let randomNumber =	arc4random_uniform(13) + 1
			
			if generatedNumbersArray.contains(Int(randomNumber)) == false {
				
				// Log number
				print(randomNumber)
				
				// Store Number
				generatedNumbersArray.append(Int(randomNumber))
				
				
				// Create First Card Object
				let cardOne = Card()
				cardOne.imageName = "card\(randomNumber)"
				generatedCardsArray.append(cardOne)
				
				// Create Second Card Object
				let cardTwo = Card()
				cardTwo.imageName = "card\(randomNumber)"
				generatedCardsArray.append(cardTwo)
			}
			
			// Restrict to unique pairs
			
			for i in 0...generatedCardsArray.count - 1 {
				let randomNumber = Int(arc4random_uniform(UInt32(generatedCardsArray.count)))
				let temp = generatedCardsArray[i]
				generatedCardsArray[i] = generatedCardsArray[randomNumber]
				generatedCardsArray[randomNumber] = temp
			}

		}
		
		
		
		// Randomize the array
		
		// Return the array
		return generatedCardsArray
		
	}
}
