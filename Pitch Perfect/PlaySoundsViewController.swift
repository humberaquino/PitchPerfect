//
//  PlaySoundViewController.swift
//  Pitch Perfect
//
//  Created by Humberto Aquino on 3/9/15.
//  Copyright (c) 2015 Humberto Aquino. All rights reserved.
//

import UIKit
import AVFoundation

//
//  View controller that plays the recorded sound with a specific effect
//
class PlaySoundsViewController: UIViewController {

    // Effects contant values
    let darthvaderPitch: Float = -1000
    let chipmunkPitch: Float = 1000
    let fastAudioRate: Float = 1.5
    let slowAudioRate: Float = 0.5
    let reverbValue: Float = 80
    let delayTime: NSTimeInterval = NSTimeInterval(0.3)
    
    // Model
    var recordedAudio: RecordedAudio!
    var audioFile: AVAudioFile!
    
    // Audio players and egines
    var audioPlayer: AVAudioPlayer!
    var audioEngine: AVAudioEngine!
   
    // Outlets
    @IBOutlet weak var stopButton: UIButton!
    
    // MARK: Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let url = recordedAudio.filePathUrl
        
        audioPlayer = AVAudioPlayer(contentsOfURL: url, error: nil)        
        
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: url, error: nil)
        
        // Changed the shared audio session to "Playback" in order to have a higher volume
        // http://discussions.udacity.com/t/low-volume-on-device/13772/2
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayback, error: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Behavior and UI methods
    
    func stopAndResetAudio() {
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.stop()
    }
    
    // Utility method to play audio with a effect
    func playAudioWithNode(node: AVAudioNode) {
        stopAndResetAudio()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        audioEngine.attachNode(node)
        
        audioEngine.connect(audioPlayerNode, to: node, format: nil)
        audioEngine.connect(node, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    // Play audio with a specific pitch
    func playAudioWithVariablePitch(pitch: Float) {
        stopAndResetAudio()
        // Pitch effect
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        playAudioWithNode(changePitchEffect)
    }
    
    func playAudioWithEcho() {
        stopAndResetAudio()
        // Echo effect
        var echoNode = AVAudioUnitDelay()
        echoNode.delayTime = delayTime
        playAudioWithNode(echoNode)
    }
    
    func playAudioWithReverb() {
        stopAndResetAudio()
        // Reverb effect
        var reverbNode = AVAudioUnitReverb()
        reverbNode.wetDryMix = reverbValue
        playAudioWithNode(reverbNode)
    }
    
    func playSoundWithRate(rate: Float) {
        stopAndResetAudio()
        audioPlayer.rate = rate
        // Start from the begining
        audioPlayer.currentTime = 0
        audioPlayer.play()
    }
    
    // MARK: Actions
    
    @IBAction func stopSound(sender: UIButton) {
        stopAndResetAudio()
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(darthvaderPitch)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(chipmunkPitch)
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        playSoundWithRate(fastAudioRate)
    }

    @IBAction func playSlowlyAudio(sender: UIButton) {
        playSoundWithRate(slowAudioRate)
    }
    
    @IBAction func playEchoAudio(sender: UIButton) {
        playAudioWithEcho()
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
        playAudioWithReverb()
    }
    
}
