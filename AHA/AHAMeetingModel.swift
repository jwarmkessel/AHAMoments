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

let kSnippetText = "text"
let kSnippetDuration = "duration"
let kSnippetTimeStamp = "timestamp"
let kSnippetSoundFile = "soundFile"

class AHAMeetingModel: NSObject {
    
    let recorder : AHARecorder = AHARecorder()

    var path : String?

    var uniqueID : String?

    //var meetings = [String]()

    var snippetTimes = [AnyObject]()

    func startMeeting() {

        path = createMeetingsDirectory()

        uniqueID = createMeeting(path!)

        //meetings.append(uniqueID)

        if let uniqueID = uniqueID {
            recorder.requestAudioRecordingPermission(uniqueID)
        }
    }

    func snippetCapture(nowTime: NSNumber) {

        let text = "Notes"

        let currentTime = NSDate.timeIntervalSinceReferenceDate()

        let blob : [String:AnyObject] = [kSnippetText : text, kSnippetDuration : nowTime, kSnippetTimeStamp : currentTime]

        snippetTimes.append(blob)

        print(snippetTimes)
    }

    func stopMeeting(nowTime: NSNumber) {
        recorder.finishRecording(success: true)
        
        for (index, element) in snippetTimes.enumerate() {
            print("Item \(index): \(element)")
            
            var blob : [String:AnyObject] = snippetTimes[index] as! [String : AnyObject]
            
            let duration : NSNumber = blob[kSnippetDuration] as! NSNumber
            let endTime = Int64(duration.integerValue)
            let startTime = Int64(duration.integerValue - 10)

            var soundFile : String

            if (startTime >= 0) {
                soundFile = self.recorder.trim(startTime, end: endTime)
            }
            else
            {
                soundFile = self.recorder.trim(0, end: endTime)
            }

            blob[kSnippetSoundFile] = soundFile;

            snippetTimes[index] = blob
        }
    }

    func findSnippets() {
        let snippetURL = recorder.createSnippetsDirectory()
        do {
            let fileList = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(snippetURL.path!)
            print(fileList)
        }catch let error as NSError {
            print(error.localizedDescription)
        }
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
