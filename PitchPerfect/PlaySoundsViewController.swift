//
//  PlaySoundViewController.swift
//  PitchPerfect
//
//  Created by Dongyoon Kang on 2017. 1. 9..
//  Copyright © 2017년 Dongyoon Kang. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var rabbitButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
   
    @IBOutlet weak var seekSlider: UISlider!
    
    var recordedAudioURL : URL!
    var audioFile : AVAudioFile!
    var audioEngine : AVAudioEngine!
    var audioPlayerNode : AVAudioPlayerNode!
    var stopTimer: Timer!
    
    var sliderTimer : Timer!
    
    var audioDuration : Double = 0.0
    
    var length : Float = 0.0

    
    enum ButtonType : Int { case slow = 0, fast, chipmunk, vader, echo, reverb }
    
    @IBAction func playSoundForButton(_ sender: UIButton) {
        switch (ButtonType(rawValue: sender.tag)!) {
        case .slow:
            playSound(rate: 0.5)
        case .fast:
            playSound(rate: 1.5)
        case .chipmunk:
            playSound(pitch: 1000)
        case .vader:
            playSound(pitch: -1000)
        case .echo:
            playSound(echo: true)
        case .reverb:
            playSound(reverb: true)
        }
        
        configureUI(.playing)
    }
    
    @IBAction func stopButtonPressed(_ sender: AnyObject) {
        stopAudio()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(.notPlaying)
    }
    
    @IBAction func sliderTouchDown(_ sender: AnyObject) {
        sliderTimer.invalidate()
        if let stopTimer = stopTimer {
            stopTimer.invalidate()
        }
        audioPlayerNode.pause()
        

    }
    
    @IBAction func sliderTouchUp(_ sender: AnyObject) {
        changeAudioTime(self);
        self.sliderTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(PlaySoundsViewController.updateSeekSlider), userInfo: nil, repeats: true)
    }
    

    @IBAction func changeAudioTime(_ sender: AnyObject) {

        let newsampleTime = AVAudioFramePosition(audioFile.processingFormat.sampleRate * Double(seekSlider.value))
        let length = Float(audioDuration) - seekSlider.value
        let framesToPlay = AVAudioFrameCount(Float(audioFile.processingFormat.sampleRate) * length)
        
        audioPlayerNode.stop()
        
        if framesToPlay > 100 {
            audioPlayerNode.scheduleSegment(audioFile, startingFrame: newsampleTime, frameCount: framesToPlay, at: nil,completionHandler: nil)
        }
        
        if let stopTimer = stopTimer {
            stopTimer.invalidate()
        }
        stopTimerInitialize(Double(length))
        audioPlayerNode.play()
    }
}
