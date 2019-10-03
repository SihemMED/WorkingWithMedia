//
//  ViewController.swift
//  WorkingWithMedia
//
//  Created by Sihem Mohamed on 10/2/19.
//  Copyright © 2019 Simo. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation
import AVKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var playBtn: UIButton!
    
    let playerViewController = AVPlayerViewController()
    var videoUrl : URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playBtn.isHidden = true
        // Do any additional setup after loading the view.
    }

    @IBAction func takePhotoButtonTapped(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePickerCtrl = UIImagePickerController()
            imagePickerCtrl.delegate = self
            imagePickerCtrl.sourceType = .camera
            imagePickerCtrl.mediaTypes = [kUTTypeMovie as String, kUTTypeImage as String]
            imagePickerCtrl.modalPresentationStyle = .popover
            self.present(imagePickerCtrl, animated: true, completion: nil)
        }else{
            print("Camera not available")
        }
    }
    
    @IBAction func getPhotoLibraryButtonTapped(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePickerCtrl = UIImagePickerController()
            imagePickerCtrl.delegate = self
            imagePickerCtrl.sourceType = .photoLibrary
            imagePickerCtrl.mediaTypes = [kUTTypeMovie as String, kUTTypeImage as String]
            imagePickerCtrl.modalPresentationStyle = .popover
            self.present(imagePickerCtrl, animated: true, completion: nil)
            
        }else{
            print("Photo Library not available")
        }
    }
    
    @IBAction func playBtnTapped(_ sender: Any) {
        playVideo()
    }
    
    @IBAction func showRecordAudioVC(_ sender: Any) {
        self.performSegue(withIdentifier: "audioVCSegue", sender: self)
    }
    
    func playVideo() {
        let asset = AVAsset(url: videoUrl)
        let playerItem = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: playerItem)
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            self.playerViewController.player?.play()
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let mediaType = info[.mediaType] as! String
        if mediaType == kUTTypeImage as String {
            guard let image: UIImage = info[.originalImage] as? UIImage else {
                print("Error Image picker finished ")
                return
            }
            imageView.image = image
            playBtn.isHidden = true
            picker.dismiss(animated: true, completion: nil)
        }else if mediaType == kUTTypeMovie as String {
            if let url = info[.mediaURL] as? URL {
                if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path) {
                    UISaveVideoAtPathToSavedPhotosAlbum(url.path, self, #selector(video(_:didFinishSavingWithError:contextInfo:)), nil)
                    print("video url saved")
                    picker.dismiss(animated: true, completion: nil)
                    videoUrl = url
                    playBtn.isHidden = false
                    imageView.image = UIImage(named: "video")
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Image picker controller cancelled")
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func video(_ video: String, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error == nil {
            print("video Saved")
            if let path = Bundle.main.path(forResource: video, ofType: "MOV") {
                videoUrl = URL(fileURLWithPath: path)
            }
        }
    }
    
}
