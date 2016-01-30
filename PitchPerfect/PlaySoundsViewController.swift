//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Marquis Dennis on 1/29/16.
//  Copyright © 2016 Marquis Dennis. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
  
  var receiveAudio:RecordedAudio!
  var audioEngine:AVAudioEngine!
  var audioFile:AVAudioFile!
  var audioPlayer: AVAudioPlayerNode!
  var timePitch: AVAudioUnitTimePitch!
  
  override func viewDidLoad() {
    audioEngine = AVAudioEngine()
    
    audioPlayer = AVAudioPlayerNode()
    timePitch = AVAudioUnitTimePitch()
  
    audioEngine.attachNode(audioPlayer)
    audioEngine.attachNode(timePitch)
    
    audioFile = try! AVAudioFile(forReading: receiveAudio.filePathUrl)
    
  }
  
  func startAudioEngine(withRate rate:Float, usingPitch pitch:Float? = 1.0) {
    timePitch.pitch = pitch!
    timePitch.rate = rate
    
    audioEngine.connect(audioPlayer, to: timePitch, format: audioFile.processingFormat)
    audioEngine.connect(timePitch, to: audioEngine.outputNode, format: audioFile.processingFormat)
    
    audioPlayer.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
    
    try! audioEngine.start()
    audioPlayer.play()
  }
  
  @IBAction func playChipmunkAudio(sender: UIButton) {
    startAudioEngine(withRate: 1.5, usingPitch: 1000)
  }
  
  @IBAction func playFastAudio(sender: UIButton) {
    startAudioEngine(withRate: 1.5)
  }
  
  @IBAction func playSlowAudio(sender: UIButton) {
    startAudioEngine(withRate: 0.5)
  }

  @IBAction func stopAutio(sender: UIButton) {
    audioPlayer.stop()
  }
  
  @IBAction func playDarthVaderAudio(sender: UIButton) {
    startAudioEngine(withRate: 0.7, usingPitch: -1000)
  }
}
