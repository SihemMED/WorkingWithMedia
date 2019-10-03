//
//  AudioRecordViewController.swift
//  WorkingWithMedia
//
//  Created by Sihem Mohamed on 10/2/19.
//  Copyright © 2019 Simo. All rights reserved.
//

import UIKit
import AVFoundation

class AudioRecordViewController: UIViewController{

    @IBOutlet weak var startRecordingBtn: UIButton!
    @IBOutlet weak var stopRecordingBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var audioRecordStatus: UILabel!
    @IBOutlet weak var playerStatus: UILabel!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var recorderView: UIView!
    
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerView.isHidden = true
        settingUpAudioRecorder()
    }
    
    @IBAction func startRecording(_ sender: Any) {
        guard !audioRecorder!.isRecording else {
            print("cannot record audio while playing")
            playerStatus.text = "cannot record audio while playing"
            return
        }
        if !audioRecorder!.isRecording {
            audioRecorder?.record()
            audioRecordStatus.text = "Recording ...."
        }
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        if audioRecorder!.isRecording {
            audioRecorder?.stop()
            audioRecordStatus.text = "Stopped"
            playerView.isHidden = false
            settingUpPlayer()
        } else {
            audioRecordStatus.text = "Already Stopped"
        }
    }
    
    @IBAction func play(_ sender: Any) {
        guard !audioRecorder!.isRecording else {
            print("cannot play audio while recording")
            playerStatus.text = "cannot play audio while recording"
            return
        }
        if audioPlayer!.isPlaying {
            audioPlayer?.stop()
        }
        audioPlayer?.play()
        playerStatus.text = "Playing ...."
    }

    @IBAction func stopPlayer(_ sender: Any) {
        if audioPlayer!.isPlaying {
            audioPlayer?.stop()
            playerStatus.text = "Stopped"
        }
    }
    private func settingUpAudioRecorder() {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDirectory = paths[0] as String
        let audioPath = docsDirectory.appending("/test.m4a")
        let audioFileUrl = URL(fileURLWithPath: audioPath)
        
        
        let recorderSettings: [String : Any] = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000.0, AVNumberOfChannelsKey: 1,
                                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord)
            audioSession.requestRecordPermission { (allowed) in
                print(allowed)
            }
            audioRecorder = try AVAudioRecorder(url: audioFileUrl, settings: recorderSettings)
            audioRecorder?.delegate = self
            audioRecorder?.prepareToRecord()
        } catch {
            print("An Error has occured")
        }
    }
    
    private func settingUpPlayer() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioRecorder!.url)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            playerStatus.text = "Player status"
        } catch  {
            print("Error while creating player file")
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AudioRecordViewController: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            print("Recording successful")
            audioRecordStatus.text = "Finish recording"
        } else {
            print("Recording failed")
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("error occured during recording")
    }
}

extension AudioRecordViewController: AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        if flag {
            print("player successful")
            playerStatus.text = "Finish playing"
        } else {
            print("player failed")
        }
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("error occured during playing a record")
    }
}
