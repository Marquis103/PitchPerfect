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
  var reverb:AVAudioUnitReverb!
  var echo:AVAudioUnitDelay!
  
  override func viewDidLoad() {
    audioEngine = AVAudioEngine()
    
    audioPlayer = AVAudioPlayerNode()
    timePitch = AVAudioUnitTimePitch()
    reverb = AVAudioUnitReverb()
    echo = AVAudioUnitDelay()
    
    audioEngine.attachNode(audioPlayer)
    audioEngine.attachNode(timePitch)
    audioEngine.attachNode(reverb)
    audioEngine.attachNode(echo)
    
    audioFile = try! AVAudioFile(forReading: receiveAudio.filePathUrl, commonFormat: .PCMFormatFloat32, interleaved: false)
    
  }
  
  func startAudioEngine(withRate rate:Float, usingPitch pitch:Float? = 1.0, reverbValue:Float?, echoValue:NSTimeInterval?) {
    if audioPlayer.playing {
      audioPlayer.stop()
    }
    
    selectedButton?.userInteractionEnabled = false
    
    timePitch.pitch = pitch!
    timePitch.rate = rate
    
    if let echoValue = echoValue, let reverbValue = reverbValue {
      reverb.loadFactoryPreset(.LargeHall)
      reverb.wetDryMix = reverbValue
      
      echo.delayTime = echoValue

    } else {
      reverb.loadFactoryPreset(.MediumHall)
      reverb.wetDryMix = 0.0
      
      echo.delayTime = 0
    }
    
    audioEngine.connect(audioPlayer, to: echo, format: nil)
    audioEngine.connect(echo, to: reverb, format: nil)
    audioEngine.connect(reverb, to: timePitch, format: nil)
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
    startAudioEngine(withRate: 1.5, usingPitch: 1000, reverbValue: nil, echoValue: nil)
  }
  
  @IBAction func playFastAudio(sender: UIButton) {
    selectedButton = sender
    startAudioEngine(withRate: 2.0, usingPitch: 1.0, reverbValue: nil, echoValue: nil)
  }
  
  @IBAction func playSlowAudio(sender: UIButton) {
    selectedButton = sender
    startAudioEngine(withRate: 0.5, usingPitch: 1.0, reverbValue: nil, echoValue: nil)
  }

  @IBAction func stopAutio(sender: UIButton) {
    audioPlayer.stop()
  }
  
  
  @IBAction func playReverbEcho(sender: UIButton) {
    selectedButton = sender
    startAudioEngine(withRate: 1.0, usingPitch: 1.0, reverbValue: 50, echoValue: 0.4)
  }
  
  @IBAction func playDarthVaderAudio(sender: UIButton) {
    selectedButton = sender
    startAudioEngine(withRate: 0.7, usingPitch: -1000, reverbValue: nil, echoValue: nil)
  }
}
