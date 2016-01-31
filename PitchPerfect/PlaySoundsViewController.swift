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
  var selectedButton:UIButton?
  
  override func viewDidLoad() {
    audioEngine = AVAudioEngine()
    
    audioPlayer = AVAudioPlayerNode()
    timePitch = AVAudioUnitTimePitch()
  
    audioEngine.attachNode(audioPlayer)
    audioEngine.attachNode(timePitch)
    
    audioFile = try! AVAudioFile(forReading: receiveAudio.filePathUrl, commonFormat: .PCMFormatFloat32, interleaved: false)
    
  }
  
  func startAudioEngine(withRate rate:Float, usingPitch pitch:Float? = 1.0) {
    if audioPlayer.playing {
      audioPlayer.stop()
    }
    
    selectedButton?.userInteractionEnabled = false
    
    timePitch.pitch = pitch!
    timePitch.rate = rate
    
    audioEngine.connect(audioPlayer, to: timePitch, format: nil)
    audioEngine.connect(timePitch, to: audioEngine.outputNode, format: nil)
    
    audioPlayer.scheduleFile(audioFile, atTime: nil) { () -> Void in
      self.selectedButton?.userInteractionEnabled = true
    }
    
    try! audioEngine.start()
    audioPlayer.volume = 1.0
    audioPlayer.play()
  }
  
  @IBAction func playChipmunkAudio(sender: UIButton) {
    selectedButton = sender
    startAudioEngine(withRate: 1.5, usingPitch: 1000)
  }
  
  @IBAction func playFastAudio(sender: UIButton) {
    selectedButton = sender
    startAudioEngine(withRate: 2.0)
  }
  
  @IBAction func playSlowAudio(sender: UIButton) {
    selectedButton = sender
    startAudioEngine(withRate: 0.5)
  }

  @IBAction func stopAutio(sender: UIButton) {
    audioPlayer.stop()
  }
  
  @IBAction func playDarthVaderAudio(sender: UIButton) {
    selectedButton = sender
    startAudioEngine(withRate: 0.7, usingPitch: -1000)
  }
}
