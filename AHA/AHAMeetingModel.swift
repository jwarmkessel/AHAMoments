//
//  AHAMeetingModel.swift
//  AHA
//
//  Created by Justin Warmkessel on 5/5/16.
//  Copyright © 2016 Justin Warmkessel. All rights reserved.
//

import UIKit

// func: Create Model > Create AHA Recorder Object
// subfunc: Create meetings directory
// subfunc: Create uniqueID directory for this meeting
// Start recording
// Model Send a uniqueID (folder) to recorder to store recordings
// Track taps - snippetTap

class AHAMeetingModel: NSObject {
    
    let recorder : AHARecorder = AHARecorder()

    var path : String?

    var uniqueID : String?

    //var meetings = [String]()

    var snippetTimes = [NSNumber]()

    func startMeeting() {

        path = createMeetingsDirectory()

        uniqueID = createMeeting(path!)

        //meetings.append(uniqueID)

        if let uniqueID = uniqueID {
            recorder.requestAudioRecordingPermission(uniqueID)
        }
    }

    func snippetCapture(nowTime: NSNumber) {

        snippetTimes.append(nowTime)

        print(snippetTimes)
    }

    func stopMeeting(nowTime: NSNumber) {
        recorder.finishRecording(success: true)
    }

// MARK: File Handling

    func createMeetingsDirectory() -> String {

        snippetTimes.removeAll()

        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory: AnyObject = paths[0]
        let dataPath = documentsDirectory.stringByAppendingPathComponent("AHAMoments")

        do {
            try NSFileManager.defaultManager().createDirectoryAtPath(dataPath, withIntermediateDirectories: false, attributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
        }

        return dataPath
    }

    func createMeeting(path: String) -> String {

        let directoryName   : String?  = NSUUID().UUIDString

        //let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0])

        let pathURL = NSURL.init(fileURLWithPath: path, isDirectory: true)

        let logsPath = pathURL.URLByAppendingPathComponent(directoryName!)
        do {
            try NSFileManager.defaultManager().createDirectoryAtPath(logsPath.path!, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            NSLog("Unable to create directory \(error.debugDescription)")
        }

        return logsPath.absoluteString
    }
}
