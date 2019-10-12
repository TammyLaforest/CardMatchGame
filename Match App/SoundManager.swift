//
//  SoundManager.swift
//  Match App
//
//  Created by User on 10/11/19.
//  Copyright © 2019 Tammy Laforest. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {
	static var audioPlayer:AVAudioPlayer?
	
	enum SoundEffect {
		case flip
		case shuffle
		case match
		case nomatch
	}
	
	static func playSound(_ effect:SoundEffect){
		var soundFilename = ""
		
		switch effect {
		case .flip:
			soundFilename = "cardflip"
		case .shuffle:
			soundFilename = "shuffle"
		case .match:
			soundFilename = "dingcorrect"
		case .nomatch:
			soundFilename = "dingwrong"
//		default:
//			soundFilename = ""
		}
		
		let bundlePath = Bundle.main.path(forResource: soundFilename, ofType: "wav")
		
		guard bundlePath != nil else {
			print("couldn't find sound file \(soundFilename) in bundle")
			return
		}
		// Create URL object from string path
		
		let soundURL = URL(fileURLWithPath: bundlePath!)
		
		// create audio player object
		do {
			audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
			
			// Play sound
			audioPlayer?.play()
		} catch {
			// log error
			print("Couldn't create audio player object for sound file \(soundFilename) ")
		}
}

}
