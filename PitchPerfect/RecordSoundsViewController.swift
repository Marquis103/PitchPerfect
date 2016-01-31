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
  var timer:NSTimer?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    createAudioRecorder()
    
  }
  
  func createAudioRecorder() {
    let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
    let recordingName = "myaudio.wav"
    let pathArray = [dirPath, recordingName]
    let filePath = NSURL.fileURLWithPathComponents(pathArray)
    try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [AVNumberOfChannelsKey : NSNumber(int: 1)])
  }
  
  func startLabelAnimation() {
    recordingLabel.fadeOut()
    recordingLabel.fadeIn()
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
    if audioRecorder.recording {
      audioRecorder.pause()
      if let timer = timer {
        timer.invalidate()
      }
      
      recordingLabel.text = "Recording has been paused"
      
    } else {
      
      let session = AVAudioSession.sharedInstance()
      try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
      try! session.overrideOutputAudioPort(.Speaker)

      audioRecorder.meteringEnabled = true
      audioRecorder.prepareToRecord()
      audioRecorder.record()
      audioRecorder.delegate = self
      recordingLabel.text = "Recording in progress"
      timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "startLabelAnimation", userInfo: nil, repeats: true)

      //recordButton.enabled = false
      stopButton.hidden = false
    }
    
  }

  @IBAction func stopRecording(sender: UIButton) {
    audioRecorder.stop()
    let audioSession = AVAudioSession.sharedInstance()
    try! audioSession.setActive(false)

    //recordButton.enabled = true
    if let timer = timer {
      timer.invalidate()
    }
    
    recordingLabel.text = "Tap to record"
    
  }
  
  func alertUserOfAction(withTitle title:String, withMessage message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
    alert.addAction(alertAction)
    
    presentViewController(alert, animated: true, completion: nil)
  }
}

extension RecordSoundsViewController : AVAudioRecorderDelegate {
  func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
    if flag {
      recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
      performSegueWithIdentifier("stopRecording", sender: recordedAudio)
      
    } else {
      alertUserOfAction(withTitle: "Recording Error", withMessage: "Recording was unsuccessful")
    }
  }
}

extension UIView {
  func fadeIn() {
    UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
      self.alpha = 1.0
      }, completion: nil)
  }
  
  func fadeOut() {
    UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
      self.alpha = 0.0
      }, completion: nil)
  }
}