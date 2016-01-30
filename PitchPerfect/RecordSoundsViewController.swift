//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Marquis Dennis on 1/29/16.
//  Copyright © 2016 Marquis Dennis. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController {

  //MARK: Outlets
  @IBOutlet weak var recordingLabel: UILabel!
  @IBOutlet weak var recordButton: UIButton!
  @IBOutlet weak var stopButton: UIButton!

  var audioRecorder:AVAudioRecorder!
  var recordedAudio:RecordedAudio!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "stopRecording" {
      let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
      playSoundsVC.receiveAudio = sender as! RecordedAudio
    }
  }

  //MARK: Functions
  override func viewWillAppear(animated: Bool) {
    stopButton.hidden = true
    recordingLabel.text = "Tap to record"
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func recordAudio(sender: UIButton) {
    let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
    let currentDateTime = NSDate()
    let formatter = NSDateFormatter()
    formatter.dateFormat = "ddMMyyyy-HHmmss"
    let recordingName = "myaudio.wav"//formatter.stringFromDate(currentDateTime) + ".wav"
    let pathArray = [dirPath, recordingName]
    let filePath = NSURL.fileURLWithPathComponents(pathArray)
    
    let session = AVAudioSession.sharedInstance()
    try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
    try! session.overrideOutputAudioPort(.Speaker)
    try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
    audioRecorder.meteringEnabled = true
    audioRecorder.prepareToRecord()
    audioRecorder.record()
    audioRecorder.delegate = self
    recordingLabel.text = "Recording in progress"
    recordButton.enabled = false
    stopButton.hidden = false
  }

  @IBAction func stopRecording(sender: UIButton) {
    audioRecorder.stop()
    let audioSession = AVAudioSession.sharedInstance()
    try! audioSession.setActive(false)

    recordButton.enabled = true
    recordingLabel.text = "Tap to record"
    
  }
}

extension RecordSoundsViewController : AVAudioRecorderDelegate {
  func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
    if flag {
      recordedAudio = RecordedAudio()
      recordedAudio.filePathUrl = recorder.url
      recordedAudio.title = recorder.url.lastPathComponent
  
      self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
    } else {
      print("There was an error recording")
    }
  }
}

