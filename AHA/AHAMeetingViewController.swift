//
//  ViewController.swift
//  AHA
//
//  Created by Justin Warmkessel on 5/5/16.
//  Copyright © 2016 Justin Warmkessel. All rights reserved.
//

import UIKit

class AHAMeetingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let meetingModel : AHAMeetingModel = AHAMeetingModel()
    var listIsActive : Bool = false
    @IBOutlet weak var tableView: UITableView!
    
    //Used to animate the height of the tableView.
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tableViewBottomLayoutConstraint: NSLayoutConstraint!
        {
        didSet{
            self.tableViewBottomLayoutConstraint.active = false
        }
    }
    @IBOutlet var displayTimeLabel: UILabel!
    {
        didSet{
            displayTimeLabel.alpha = 0.0;
        }
    }
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var doubleTapView: UIView!
    @IBOutlet weak var recordingView: UIView!
    @IBOutlet weak var doubleTapToPlayLabel: UILabel!

    @IBAction func stopRecording(sender: AnyObject) {
        print("stop")

        meetingModel.stopMeeting(nowTime)


        timerStop(self)

        self.view.bringSubviewToFront(self.doubleTapView)
        self.doubleTapView.userInteractionEnabled = true;
    }

    @IBAction func tapHandler(sender: AnyObject) {
        
        print("doubleTap")
        self.doubleTapToPlayLabel.alpha = 0.0;
        self.menuButton.alpha = 0.0;
        self.displayTimeLabel.alpha = 1.0;
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
        self.toggleListView()
        self.tableView.reloadData()
    }
    
    func toggleListView() {
        
        
        self.tableViewHeightConstraint.active = true
        
        var tableHeight : CGFloat = 0.0
        
        if(self.listIsActive) {
            
            self.listIsActive = false
        }
        else
        {
            tableHeight = self.doubleTapView.frame.size.height
            self.listIsActive = true
        }
        
        UIView.animateWithDuration(0.4) { () -> Void in
            
            self.tableViewHeightConstraint.constant = tableHeight
            
            self.view.layoutIfNeeded()
        }
    }

    // MARK: Shake Handling
  
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        
        if (motion == .MotionShake)
        {
            print("shake")
            self.menuButton.alpha = 1.0;
            stopRecording(self)
        
        }
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }

    // MARK: Timer
    var startTime = NSTimeInterval()

    var timer:NSTimer = NSTimer()

    var nowTime = NSNumber()

    func timerStart(sender: AnyObject) {
        if (!timer.valid) {
            let aSelector : Selector = "updateTime"
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
            startTime = NSDate.timeIntervalSinceReferenceDate()
        }
    }

    func timerStop(sender: AnyObject) {
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
        self.tableView.delegate = self
        self.tableView.registerClass(AHASegmentCellTableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell : AHASegmentCellTableViewCell = (tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? AHASegmentCellTableViewCell)!
        
    
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
}

