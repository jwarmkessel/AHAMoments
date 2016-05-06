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
        
        self.directoryName = url.path
        
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

    func trim(start : Int64, end  : Int64) {
        self.createSnippetsDir()
        
        let url = NSURL.fileURLWithPath(self.directoryName! as String)
    
        if let asset : AVURLAsset? = AVURLAsset(URL: url)
        {
            exportAsset(asset!, start: start, end: end)
        }
    }
    
    func createSnippetsDir() {
        
        let urlForThisMeetingDirectory = NSURL.fileURLWithPath(self.directoryName! as String)
        var dataPath = urlForThisMeetingDirectory.URLByDeletingLastPathComponent!
        dataPath = dataPath.URLByAppendingPathComponent("snippets")
        
        let fileManager : NSFileManager = NSFileManager.init()
        
        if (!fileManager.fileExistsAtPath(dataPath.absoluteString)) {
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(dataPath.path!, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Recorder: Could not create directory from the method createSnippetsDirectory()")
            }
        }
    }
    
    func createSnippetsDirectory() -> NSURL {
        
        let urlForThisMeetingDirectory = NSURL.fileURLWithPath(self.directoryName! as String)
        var dataPath = urlForThisMeetingDirectory.URLByDeletingLastPathComponent!
        dataPath = dataPath.URLByAppendingPathComponent("snippets")
        
        let fileManager : NSFileManager = NSFileManager.init()
        
        if (!fileManager.fileExistsAtPath(dataPath.absoluteString)) {
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(dataPath.path!, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Recorder: Could not create directory from the method createSnippetsDirectory()")
            }
        }
    
        return dataPath
    }
    
    func exportAsset(asset : AVURLAsset, start : Int64, end  : Int64) {
        let dataPath = self.createSnippetsDirectory()
        
        let name = NSUUID().UUIDString.stringByAppendingString(".m4a")
        let trimmedSoundFileURL = dataPath.URLByAppendingPathComponent(name)
        
        print("saving to \(trimmedSoundFileURL.path)")
        
        let filemanager = NSFileManager.defaultManager()
        
        if filemanager.fileExistsAtPath(self.directoryName!) {
            print("sound exists")
        }
        
        if let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A) {
            exporter.outputFileType = AVFileTypeAppleM4A
            exporter.outputURL = trimmedSoundFileURL
            
            let duration = CMTimeGetSeconds(asset.duration)
            if (duration < 5.0) {
                print("sound is not long enough")
                return
            }
//             e.g. the first 5 seconds
            let startTime = CMTimeMake(start, 1)
            let stopTime = CMTimeMake(end, 1)
            let exportTimeRange = CMTimeRangeFromTimeToTime(startTime, stopTime)
            exporter.timeRange = exportTimeRange
            
            
            // do it
            exporter.exportAsynchronouslyWithCompletionHandler({
                switch exporter.status {
                case  AVAssetExportSessionStatus.Failed:
                    print("export failed \(exporter.error)")
                case AVAssetExportSessionStatus.Cancelled:
                    print("export cancelled \(exporter.error)")
                default:
                    print("export complete")
                }
            })
        }
    }
}
