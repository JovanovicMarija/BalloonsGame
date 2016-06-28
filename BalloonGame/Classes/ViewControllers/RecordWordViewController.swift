//
//  recordWordViewController.swift
//  BalloonGame
//
//  Created by Marija Jovanovic on 4/20/16.
//  Copyright © 2016 Marija Jovanovic. All rights reserved.
//

import UIKit
import AVFoundation

class RecordWordViewController: UIViewController, AVAudioRecorderDelegate {
    
    var letter: Character!

    // IBOutlet
    @IBOutlet weak var labelTime: UILabel!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var buttonPlay: UIButton! {
        didSet {
            buttonPlay.userInteractionEnabled = false
            buttonPlay.alpha = 0.5
        }
    }
    
    @IBOutlet weak var buttonRecord: UIButton!
    
    // properties
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.clearColor()
        view.opaque = false
        
        // text view
        textField.delegate = self
        textField.text = String(letter)
        textField.becomeFirstResponder()
        
        // audio
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] (allowed: Bool) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    if allowed {
                        //                        self.loadRecordingUI()
                    } else {
                        // TODO: - failed to record!
                    }
                }
            }
        } catch {
            // TODO: - failed to record!
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - buttons
    @IBAction func buttonPlayPressed(sender: AnyObject) {
        
    }

    @IBAction func buttonRecordPressed(sender: AnyObject) {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
    // MARK: - audio
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func startRecording() {
        var audioFilename: NSString = getDocumentsDirectory().stringByAppendingPathComponent("recording.m4a")
        let audioURL = NSURL(fileURLWithPath: audioFilename as String)
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000.0,
            AVNumberOfChannelsKey: 1 as NSNumber,
            AVEncoderAudioQualityKey: AVAudioQuality.High.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(URL: audioURL, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
            buttonRecord.setTitle(NSLocalizedString("TapToStop", comment: "Tap to Stop"), forState: .Normal)
        } catch {
            finishRecording(success: false)
        }
    }
    
    func finishRecording(success success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
            buttonRecord.setTitle(NSLocalizedString("TapToRe-record", comment: "Tap to Re-record"), forState: .Normal)
        } else {
            buttonRecord.setTitle(NSLocalizedString("TapToRecord", comment: "Tap to Record"), forState: .Normal)
            // recording failed :(
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
}

extension RecordWordViewController: UITextFieldDelegate {
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        print(range.length, range.location)
        return !NSEqualRanges(range, NSMakeRange(0, 1))
    }
}
