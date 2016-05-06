//
//  ViewController.swift
//  AHA
//
//  Created by Justin Warmkessel on 5/5/16.
//  Copyright © 2016 Justin Warmkessel. All rights reserved.
//

import UIKit

class AHAMeetingViewController: UIViewController {

    let meetingModel : AHAMeetingModel = AHAMeetingModel()

    @IBOutlet weak var tableView: UITableView!
    //Used to animate the height of the tableView.
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tableViewBottomLayoutConstraint: NSLayoutConstraint!
        {
        didSet{
            self.tableViewBottomLayoutConstraint.active = false
        }
    }
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var doubleTapView: UIView!
    @IBOutlet weak var recordingView: UIView!

    @IBAction func stopRecording(sender: AnyObject) {
        print("stop")

        meetingModel.stopMeeting(nowTime)


        timerStop(self)

        self.view.bringSubviewToFront(self.doubleTapView)
        self.doubleTapView.userInteractionEnabled = true;
    }

    @IBAction func tapHandler(sender: AnyObject) {
        
        print("doubleTap")

        self.doubleTapView.userInteractionEnabled = false;
        self.view.bringSubviewToFront(self.recordingView)
    
        meetingModel.startMeeting()

        timerStart(self)
    }
    
    @IBAction func snippetCaptureHandler(sender: AnyObject) {
        print("snippet Cature Tap")

        meetingModel.snippetCapture(nowTime)
    }

    @IBAction func menuButtonHandler(sender: AnyObject, forEvent event: UIEvent) {
        //TODO FIXME://Animate tableview not working expected manner.
        //self.toggleListView()
    }
    
    func toggleListView() {
        self.tableViewHeightConstraint.active = false
        
        if (self.tableViewBottomLayoutConstraint == nil)
        {
            let verticalConstraint = NSLayoutConstraint(item: self.tableView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
            
            self.tableView.addConstraint(verticalConstraint)
        }
        else
        {
            self.tableViewBottomLayoutConstraint.active = true
            self.tableViewBottomLayoutConstraint.constant = 0
        }
        
        UIView.animateWithDuration(0.4) { () -> Void in
            
            
            self.view.layoutIfNeeded()
        }
    }

    // MARK: Shake Handling
  
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        
        if (motion == .MotionShake)
        {
            print("shake")

            stopRecording(self)
        
        }
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }


    // MARK: Timer

    @IBOutlet var displayTimeLabel: UILabel!

    var startTime = NSTimeInterval()

    var timer:NSTimer = NSTimer()

    var nowTime = NSNumber()

    @IBAction func timerStart(sender: AnyObject) {
        if (!timer.valid) {
            let aSelector : Selector = "updateTime"
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
            startTime = NSDate.timeIntervalSinceReferenceDate()
        }
    }

    @IBAction func timerStop(sender: AnyObject) {
        timer.invalidate()
    }

    func updateTime() {
        let currentTime = NSDate.timeIntervalSinceReferenceDate()

        //Find the difference between current time and start time.
        var elapsedTime: NSTimeInterval = currentTime - startTime
        let timeNow: NSTimeInterval = currentTime - startTime

        //calculate the minutes in elapsed time.
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (NSTimeInterval(minutes) * 60)

        //calculate the seconds in elapsed time.
        let seconds = UInt8(elapsedTime)
        elapsedTime -= NSTimeInterval(seconds)

        //find out the fraction of milliseconds to be displayed.
        //let fraction = UInt8(elapsedTime * 100)

        //add the leading zero for minutes, seconds and millseconds and store them as string constants

        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        //let strFraction = String(format: "%02d", fraction)

        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
        //displayTimeLabel.text = "\(strMinutes):\(strSeconds):\(strFraction)"
        displayTimeLabel.text = "\(strMinutes):\(strSeconds)"

        let uTime = Int64(timeNow)
        // Keep this to send to model
        nowTime = NSNumber(longLong: uTime)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

