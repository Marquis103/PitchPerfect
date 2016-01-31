//
//  RecordedAudio.swift
//  PitchPerfect
//
//  Created by Marquis Dennis on 1/29/16.
//  Copyright © 2016 Marquis Dennis. All rights reserved.
//

import Foundation

class RecordedAudio {
  var filePathUrl: NSURL!
  var title:String!
  
  init(filePathUrl: NSURL, title:String) {
    self.filePathUrl = filePathUrl
    self.title = title
  }
}