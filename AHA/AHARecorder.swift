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
    var recordingSession         : AVAudioSession?
    
    var movieFileOutput : AVCaptureMovieFileOutput?
    var dataOutput      : AVCaptureVideoDataOutput?
    var device          : AVCaptureDevice?
    var audioDevice     : AVCaptureDevice?
    
    let documentsURL                                    = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
    var directoryName   : String?                       = NSUUID().UUIDString
    var arrayOfVideos   : [AnyObject]                   = [AnyObject]()
    var isRecording                                     = false
    var kTimerInterval : NSTimeInterval                 = 0.02
    var completedVideoURL : NSURL?
    
    var audioRecorder: AVAudioRecorder!
    
    // func: Create AHA Recorder Object
    // subfunc: Create meetings directory
    // subfunc: Create uniqueID directory for this meeting
    // Start recording
    
    func requestAudioRecordingPermission()
    {
        recordingSession = AVAudioSession.sharedInstance()
        
        if let recordingSession = recordingSession {
            do {
                try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
                try recordingSession.setActive(true)
                recordingSession.requestRecordPermission() { [unowned self] (allowed: Bool) -> Void in
                    dispatch_async(dispatch_get_main_queue()) {
                        if allowed {
//                            self.loadRecordingUI()
                        } else {
                            // failed to record!
                        }
                    }
                }
            } catch {
                // failed to record!
            }
        }
    }
    
    func startRecording(uniqueID : String) { }
    
//        let documentDirectory : String = getDocumentsDirectory()
//        let audioFilename = documentDirectory.stringByAppendingPathComponent("recording.m4a")
//        let audioURL = NSURL(fileURLWithPath: audioFilename)
//        
//        let settings = [
//            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
//            AVSampleRateKey: 12000.0,
//            AVNumberOfChannelsKey: 1 as NSNumber,
//            AVEncoderAudioQualityKey: AVAudioQuality.High.rawValue
//        ]
//        
//        do {
//            audioRecorder = try AVAudioRecorder(URL: audioURL, settings: settings)
//            audioRecorder.delegate = self
//            audioRecorder.record()
//            
//        } catch {
//            finishRecording(success: false)
//        }
//    }
//    
//    func getDocumentsDirectory() -> String {
//        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
//        let documentsDirectory = paths[0]
//        return documentsDirectory
//    }
//    
//    func finishRecording(success success: Bool) {
//        audioRecorder.stop()
//        audioRecorder = nil
//        
//        if success {
//            recordButton.setTitle("Tap to Re-record", forState: .Normal)
//        } else {
//            recordButton.setTitle("Tap to Record", forState: .Normal)
//            // recording failed :(
//        }
//    }
}
