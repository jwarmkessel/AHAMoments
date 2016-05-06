//
//  ViewController.swift
//  AHA
//
//  Created by Justin Warmkessel on 5/5/16.
//  Copyright © 2016 Justin Warmkessel. All rights reserved.
//

import UIKit
import AudioToolbox

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
    @IBOutlet weak var doubleTapToPlayLabel: UILabel! {
        didSet {
            self.doubleTapToPlayLabel.alpha = 0.0;
        }

    }

    // MARK: - Actions

    @IBAction func stopRecording(sender: AnyObject) {
        print("stop")

        meetingModel.stopMeeting(nowTime)
        timerStop(self)

        self.view.bringSubviewToFront(self.doubleTapView)
        self.doubleTapView.userInteractionEnabled = true;

        doButtonCircularAnimation()

        UIView.animateWithDuration(0.8) { () -> Void in

            self.displayTimeLabel.alpha = 0.2;

            self.view.layoutIfNeeded()
        }
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

    func doButtonCircularAnimation() {

        menuButton.imageView?.image = UIImage.init(named: "B_0")

        let animationView = menuButton.imageView

        var animations = [UIImage]()
        var pngName : String

        for i in 0 ... 29 {

            pngName = "A_\(i)"
            animations.append(UIImage.init(named: pngName)!)

        }

        let animationDuration : NSTimeInterval = 1.0

        animationView?.animationImages = animations
        animationView?.animationDuration = animationDuration
        animationView?.animationRepeatCount = 1;

        menuButton.imageView?.startAnimating()

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(1 * NSEC_PER_SEC)), dispatch_get_main_queue()) { () -> Void in
            self.doButtonBarOutAnimation()
        }
    }

    func doButtonBarOutAnimation() {
        let animationView = menuButton.imageView

        var animations = [UIImage]()
        var pngName : String

        for i in 0 ... 15 {

            pngName = "B_\(i)"
            animations.append(UIImage.init(named: pngName)!)

        }

        let animationDuration : NSTimeInterval = 0.75

        animationView?.animationImages = animations
        animationView?.animationDuration = animationDuration
        animationView?.animationRepeatCount = 1;
        
        menuButton.imageView?.startAnimating()
    }

    @IBAction func snippetCaptureHandler(sender: UITapGestureRecognizer) {
        print("snippet Cature Tap")

        meetingModel.snippetCapture(nowTime)

        let locationInView = sender.locationInView(recordingView)

        doTouchAnimation(locationInView, inView: recordingView)
    }

    func doTouchAnimation(locationInView: CGPoint, inView view: UIView) {

        let image0 = UIImage.init(named: "touch-bg-1")
        let image1 = UIImage.init(named: "Touch-Target-1")
        let image2 = UIImage.init(named: "Touch-Target-2")
        let image3 = UIImage.init(named: "Touch-Target-3")
        let image4 = UIImage.init(named: "Touch-Target-4")
        let image5 = UIImage.init(named: "Touch-Target-5")
        let image6 = UIImage.init(named: "Touch-Target-6")

        let rect0 = CGRect.init(origin: locationInView, size: (image0?.size)!)
        let rect1 = CGRect.init(origin: locationInView, size: (image1?.size)!)
        let rect2 = CGRect.init(origin: locationInView, size: (image2?.size)!)
        let rect3 = CGRect.init(origin: locationInView, size: (image3?.size)!)
        let rect4 = CGRect.init(origin: locationInView, size: (image4?.size)!)
        let rect5 = CGRect.init(origin: locationInView, size: (image5?.size)!)
        let rect6 = CGRect.init(origin: locationInView, size: (image6?.size)!)

        let imageView0 = UIImageView.init(frame: rect0)
        let imageView1 = UIImageView.init(frame: rect1)
        let imageView2 = UIImageView.init(frame: rect2)
        let imageView3 = UIImageView.init(frame: rect3)
        let imageView4 = UIImageView.init(frame: rect4)
        let imageView5 = UIImageView.init(frame: rect5)
        let imageView6 = UIImageView.init(frame: rect6)


        imageView0.center = locationInView
        imageView1.center = locationInView
        imageView2.center = locationInView
        imageView3.center = locationInView
        imageView4.center = locationInView
        imageView5.center = locationInView
        imageView6.center = locationInView

        view.addSubview(imageView0)
        view.addSubview(imageView1)
        view.addSubview(imageView2)
        view.addSubview(imageView3)
        view.addSubview(imageView4)
        view.addSubview(imageView5)
        view.addSubview(imageView6)

        imageView0.image = image0;
        imageView1.image = image1;
        imageView2.image = image2;

        imageView2.alpha = 0.0
        imageView3.alpha = 0.0
        imageView4.alpha = 0.0
        imageView5.alpha = 0.0
        imageView6.alpha = 0.0

        imageView1.transform = CGAffineTransformScale(imageView1.transform, 0.1, 0.1)

        UIView.animateKeyframesWithDuration(1.5, delay: 0.1, options: .CalculationModeLinear,
            animations: { () -> Void in
                UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 1/7, animations: {
                    imageView0.alpha = 0.0
                    imageView2.alpha = 1.0

                    //imageView1.transform = CGAffineTransformScale(imageView1.transform, 1.25, 1.25)
                })

                UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 1/7, animations: {
                    imageView2.alpha = 0.0
                    imageView3.alpha = 1.0
                    imageView1.alpha = 0.95

                    imageView1.transform = CGAffineTransformScale(imageView1.transform, 2.0, 2.0)
                })
                UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 1/7, animations: {
                    imageView3.alpha = 0.0
                    imageView4.alpha = 1.0
                    imageView1.alpha = 0.85

                    imageView1.transform = CGAffineTransformScale(imageView1.transform, 2.0, 2.0)
                })
                UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 1/7, animations: {
                    imageView4.alpha = 0.0
                    imageView5.alpha = 1.0
                    imageView1.alpha = 0.75

                    imageView1.transform = CGAffineTransformScale(imageView1.transform, 2.0, 2.0)
                })
                UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 1/7, animations: {
                    imageView5.alpha = 0.0
                    imageView6.alpha = 1.0
                    imageView1.alpha = 0.65

                    imageView1.transform = CGAffineTransformScale(imageView1.transform, 2.0, 2.0)

                })
                UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 1/7, animations: {
                    imageView6.alpha = 0.0
                    imageView1.alpha = 0.0
                })

            }) { finished in
                imageView0.removeFromSuperview()
                imageView1.removeFromSuperview()
                imageView2.removeFromSuperview()
                imageView3.removeFromSuperview()
                imageView4.removeFromSuperview()
                imageView5.removeFromSuperview()
                imageView6.removeFromSuperview()
        }

    }

    func doTouchAnimationX(locationInView: CGPoint, inView view: UIView) {
        //let image = UIImage.init(named: "Touch-icon-lg")

        let image = UIImage.init(named: "Touch-Target-1")


        let rect = CGRect.init(origin: locationInView, size: (image?.size)!)
        let imageView = UIImageView.init(frame: rect)
        imageView.center = locationInView

        imageView.image = image;

        view.addSubview(imageView)

//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(1 * NSEC_PER_SEC)), dispatch_get_main_queue()) { () -> Void in
//            imageView.removeFromSuperview()
//        }

        UIView.animateWithDuration(0.7, animations: { () -> Void in
            imageView.alpha = 0.0
            }, completion: { (finished: Bool) in
                imageView.removeFromSuperview()
        })
    }

    @IBAction func TapStopHandler(sender: AnyObject) {
        self.menuButton.alpha = 1.0;
        stopRecording(self)
    }

    @IBAction func menuButtonHandler(sender: AnyObject, forEvent event: UIEvent) {
        self.toggleListView()
        self.tableView.reloadData()
    }

    func doBarsToXAnimation() {
        let animationView = menuButton.imageView

        var animations = [UIImage]()
        var pngName : String

        for i in 0 ... 30 {

            pngName = "C_\(i)"
            animations.append(UIImage.init(named: pngName)!)

        }

        let animationDuration : NSTimeInterval = 0.75
        animationView?.animationImages = animations
        animationView?.animationDuration = animationDuration
        animationView?.animationRepeatCount = 1;

        menuButton.imageView?.startAnimating()

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(1 * NSEC_PER_SEC)), dispatch_get_main_queue()) { () -> Void in
            animations.removeAll()
            self.menuButton.imageView?.image = UIImage.init(named: "C_31")
        }
    }

    func doXToBarsAnimation() {
        let animationView = menuButton.imageView

        var animations = [UIImage]()
        var pngName : String

        for i in (0 ... 30).reverse() {

            pngName = "C_\(i)"
            animations.append(UIImage.init(named: pngName)!)

        }

        let animationDuration : NSTimeInterval = 1.0

        animationView?.animationImages = animations
        animationView?.animationDuration = animationDuration
        animationView?.animationRepeatCount = 1;

        menuButton.imageView?.startAnimating()

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(1 * NSEC_PER_SEC)), dispatch_get_main_queue()) { () -> Void in
            animations.removeAll()
            self.menuButton.imageView?.image = UIImage.init(named: "C_0")
        }
    }

    @IBOutlet weak var nameOfMeetingButton: UIButton! {
        didSet{
            nameOfMeetingButton.contentHorizontalAlignment = .Left
        }
    }
    
    @IBOutlet weak var exportAllButton: UIButton!{
        didSet{
            exportAllButton.contentHorizontalAlignment = .Right
        }
    }


    @IBAction func exportAllButtonHandler(sender: AnyObject) {
        displayShareSheet("AHA Moment")
    }


    func displayShareSheet(shareContent:String) {
        let activityViewController = UIActivityViewController(activityItems: [shareContent as NSString], applicationActivities: nil)
        presentViewController(activityViewController, animated: true, completion: {})
    }
    
    func toggleListView() {
        
        
        self.tableViewHeightConstraint.active = true
        
        var tableHeight : CGFloat = 0.0
        
        if(self.listIsActive) {
            
            self.navigationController?.navigationBarHidden = true
            self.listIsActive = false
            AudioServicesDisposeSystemSoundID(mySound)
        }
        else
        {
            self.navigationController?.navigationBarHidden = false
            tableHeight = self.doubleTapView.frame.size.height
            self.listIsActive = true

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(1 * NSEC_PER_SEC)), dispatch_get_main_queue()) { () -> Void in
                self.doBarsToXAnimation()
            }
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
           // let aSelector : Selector = #selector(AHAMeetingViewController.updateTime)
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
        
        self.navigationController!.navigationBar.titleTextAttributes = NSDictionary(object: UIColor.whiteColor(), forKey: NSForegroundColorAttributeName) as! [String : AnyObject]
        
        self.tableView.registerNib(UINib.init(nibName: "AHASegmentCellTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "segmentCell")
        
        self.tableView.reloadData()
        
        self.navigationController?.navigationBarHidden = true
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animateWithDuration(1.0) { () -> Void in

            self.doubleTapToPlayLabel.alpha = 1.0;

            self.view.layoutIfNeeded()
        }

    }
    
    //MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return meetingModel.snippetTimes.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell : AHASegmentCellTableViewCell = (tableView.dequeueReusableCellWithIdentifier("segmentCell", forIndexPath: indexPath) as? AHASegmentCellTableViewCell)!
        
        cell.numberLabel.text =  String(indexPath.row + 1)

        cell.snippetLabel!.text = meetingModel.snippetTimes[indexPath.row][kSnippetText] as! String

        let timeText = convertToText(meetingModel.snippetTimes[indexPath.row][kSnippetTimeStamp] as! NSTimeInterval)
        cell.timeLabel!.text = timeText as String

        //cell.delegate = self


        if (indexPath.row == 0) {
            cell.ornamentationImageViewTop.hidden = false
        }
        else if (indexPath.row == meetingModel.snippetTimes.count - 1) {
            cell.ornamentationImageViewBottom.hidden = false
        }
        else {
            cell.ornamentationImageView.hidden = false
        }

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let soundFile = meetingModel.snippetTimes[indexPath.row][kSnippetSoundFile] as! String

        print("didSelectRowAtIndexPath row:\(indexPath.row) :: soundFile = \(soundFile)")

        playSnippet(soundFile)
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 100.0;//Choose your custom row height
    }


// MARK: - Helpers


    func convertToText(timestamp : NSTimeInterval) -> NSString {
        let ti = NSInteger(timestamp)

        //var ms = Int((timestamp % 1) * 1000)

        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600) % 24 - 7 // Hack the time zone... since this is GMT

        //return NSString(format: "%0.2d:%0.2d:%0.2d.%0.3d",hours,minutes,seconds,ms)
        return NSString(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
    }

    var mySound: SystemSoundID = 0

    func playSnippet(soundFile: String) {

        AudioServicesDisposeSystemSoundID(mySound)

        let soundURL = NSURL.init(fileURLWithPath: soundFile)

        AudioServicesCreateSystemSoundID(soundURL, &mySound)
        // Play
        AudioServicesPlaySystemSound(mySound);

    }
}

//extension AHAMeetingViewController : AHASegmentCellDelegate {

//    func didTapCell(cell: AHASegmentCellTableViewCell) {
//        let indexPath = tableView.indexPathForCell(cell)
//        tableView(tableView, cellForRowAtIndexPath: indexPath!)
//        tableView(tableView, didSelectRowAtIndexPath: indexPath!)
//    }
//}

