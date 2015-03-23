//
//  RecordsSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Humberto Aquino on 3/7/15.
//  Copyright (c) 2015 Humberto Aquino. All rights reserved.
//

import AVFoundation
import UIKit

//
//  View controller used to record audio.
//  The recording can be paused and resumed.
//  When the recording is stopped a PlaySoundsViewControlled is presented
//
class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    // Information outlets
    @IBOutlet weak var recordingLabel: UILabel!

    // Recording audio outlets
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    // Model
    var recordedAudio: RecordedAudio!
    
    // Provides audio recording capability
    var audioRecorder:AVAudioRecorder?
    
    // MARK: Overrided methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.stateToReady()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording") {
            let playSoundVC: PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundVC.recordedAudio = data
        }
    }

    // MARK: Behavior and UI methods
    
    func enableControlButtons(enable: Bool) {
        stopButton.enabled = enable
        pauseButton.enabled = enable
    }
    
    func hideControlButtons(hide: Bool) {
        pauseButton.hidden = hide
        stopButton.hidden = hide
    }
    
    // Initialize the UI to a "ready to record" state
    func stateToReady() {
        hideControlButtons(true)
        recordButton.enabled = true
        recordingLabel.text = "Tap to record"
        // To force AudioRecorder initialization when recording for the first time
        audioRecorder = nil
    }
    
    // Change UI to "recording"
    func stateToRecording() {
        hideControlButtons(false)
        enableControlButtons(true)
        recordButton.enabled = false
        recordingLabel.text = "Recording in progress"
    }
    
    // Change UI to "pause"
    func stateToPause() {
        pauseButton.enabled = false
        recordButton.enabled = true
        recordingLabel.text = "Tap to continue recording"
    }
    
    func stopRecordingAudio() {
        audioRecorder?.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    func pauseRecordingAudio() {
        stateToPause()
        audioRecorder?.pause()
    }
    
    func continueRecordingAudio() {
        stateToRecording()
        audioRecorder?.record()
    }
    
    // Starts the recording once
    func startRecordingAudio() {
        stateToRecording()
        
        // Define filename to save the recorded audio
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime) + ".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        // Set the session to record category
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryRecord, error: nil)
        
        // Record the audio
        self.audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        let unwrappedAudioRecorder = self.audioRecorder!
        unwrappedAudioRecorder.delegate = self
        unwrappedAudioRecorder.meteringEnabled = true
        unwrappedAudioRecorder.prepareToRecord()
        unwrappedAudioRecorder.record()
    }
    

    // MARK: Actions
    // Action to start or continue a recording
    @IBAction func recordAudio(sender: UIButton) {
        if self.audioRecorder != nil {
            continueRecordingAudio()
        } else {
            startRecordingAudio()
        }
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        stopRecordingAudio()
    }
    
    @IBAction func pauseAudio(sender: UIButton) {
        pauseRecordingAudio()
    }
    
    // MARK: AVAudioRecorderDelegate
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if flag {
            recordedAudio = RecordedAudio(title: recorder.url.lastPathComponent, filePathUrl: recorder.url)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            println("Unsucessful recording")
            stateToReady()
        }
    }
    
}



