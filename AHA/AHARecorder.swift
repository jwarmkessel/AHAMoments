//
//  AHARecorder.swift
//  AHA
//
//  Created by Justin Warmkessel on 5/5/16.
//  Copyright © 2016 Justin Warmkessel. All rights reserved.
//

import UIKit
import AVFoundation

protocol RecordAudioDelegate: class {
    func didFinishTask(sender: AHARecorder)
}
class AHARecorder: NSObject, AVAudioRecorderDelegate {
    weak var delegate:RecordAudioDelegate?
    var audioSession    : AVAudioSession = AVAudioSession.sharedInstance()
    var audioRecorder   : AVAudioRecorder?
    let documentsURL    = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
    var directoryName   : String?
    
    func requestAudioRecordingPermission(urlString : String)
    {
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioSession.setActive(true)
            audioSession.requestRecordPermission() { [unowned self] (allowed: Bool) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    if allowed {
                        self.startRecording(urlString)
                    } else {
                        // failed to record!
                    }
                }
            }
        } catch {
            // failed to record!
        }
    }
    
    func startRecording(urlString : String) {
    
        let documents: AnyObject = NSSearchPathForDirectoriesInDomains( NSSearchPathDirectory.DocumentDirectory,  NSSearchPathDomainMask.UserDomainMask, true)[0]
        let str =  documents.stringByAppendingPathComponent("recordTest.mp4")
        var url = NSURL.fileURLWithPath(str as String)
        
        url = NSURL.fileURLWithPath(urlString as String)
        url = url.URLByAppendingPathComponent("recordTest.mp4")
        
        print("url : \(url)")
        do {
            audioRecorder = try AVAudioRecorder.init(URL: url, settings: [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000.0,
                AVNumberOfChannelsKey: 1 as NSNumber,
                AVEncoderAudioQualityKey: AVAudioQuality.High.rawValue
                ])
            
            audioRecorder?.record()
        } catch {
            
        }
    }
    
    func getDocumentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func finishRecording(success success: Bool) {
        audioRecorder?.stop()
        audioRecorder = nil

    }
}
