//
//  File.swift
//  Pitch Perfect
//
//  Created by Humberto Aquino on 3/17/15.
//  Copyright (c) 2015 Humberto Aquino. All rights reserved.
//

import Foundation

//
//  Model class used to represent a recorded audio
//
class RecordedAudio: NSObject {
    
    var filePathUrl: NSURL!
    var title: String!
    
    init(title: String!, filePathUrl: NSURL) {
        self.title = title
        self.filePathUrl = filePathUrl
    }
    
}