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
        meetingModel.recorder.finishRecording(success: true)
    }

    @IBAction func tapHandler(sender: AnyObject) {
        
        print("doubleTap")

        self.doubleTapView.userInteractionEnabled = false;

        self.view.bringSubviewToFront(self.recordingView)
    
        meetingModel.startMeeting()

    }
    
    @IBAction func snippetCaptureHandler(sender: AnyObject) {
        print("snippet Cature Tap")
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
  
    //TODO fix shake to stop
    override func motionCancelled(motion: UIEventSubtype, withEvent event: UIEvent?) {
        
        if (motion == .MotionShake)
        {
            print("shake")
        
        }
    }
    
    //TODO fix shake to stop
    override func canBecomeFirstResponder() -> Bool {
        return true
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

