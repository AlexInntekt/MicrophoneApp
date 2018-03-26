//
//  RecorderVC.swift
//  MicrophoneApp
//
//  Created by Manolescu Mihai Alexandru on 01/08/2017.
//  Copyright © 2017 Manolescu Mihai Alexandru. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import CoreData


class RecorderVC: UIViewController, UITextFieldDelegate
{
    
    //OUTLETS SECTION:
    @IBOutlet weak var recordButton: UIButton!
    @IBAction func recordButton(_ sender: Any)
    {
        if audioRecorder!.isRecording
          {
            //stop the recording
            audioRecorder?.stop()
            
            //change the button's title to 'record'
            recordButton.setTitle("Record", for: .normal)
            playButton.isEnabled = true
          }
        else
        {
            //start recording
            audioRecorder?.record()
            addButton.isEnabled = true
            
            //change button's title to 'stop'
            recordButton.setTitle("Stop", for: .normal)
        }
    }
    
    //play the sound when the button is tapped:
    @IBOutlet weak var playButton: UIButton!
    @IBAction func playButton(_ sender: Any)
    {
        do {
         try audioPlayer = AVAudioPlayer(contentsOf: audioURL!)
             audioPlayer!.play()
        } catch {}
    }
    
    
    @IBOutlet weak var nameTextfield: UITextField!
    
    @IBOutlet weak var addButton: UIButton!
    @IBAction func addButton(_ sender: Any)
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let sound = Sound(context: context)
        sound.name = nameTextfield.text
        sound.audio = NSData(contentsOf: audioURL!)
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        navigationController!.popViewController(animated: true)
        
    }
    //END OF OUTLETS SECTION
    
    
    //GLOBAL VARIABLES SECTION:
    var audioRecorder : AVAudioRecorder? = nil
    var audioPlayer : AVAudioPlayer?
    var audioURL : URL?
    //END OF GLOBAL VARIABLES SECTION

    
    //dissmis the keyboard after tapping on 'return' from the textField:
    func textFieldShouldReturn(_ titleTextfield: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return true
    }
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        
        nameTextfield.delegate = self
        
        setupRecorder()
        playButton.isEnabled = false
        addButton.isEnabled = false
        print("\n\n Audio recording file URL adress: ", audioRecorder?.url as Any ,"\n\n")
        
        
    }
    
    func setupRecorder()
    {
        do {
        //create an audio session
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try session.overrideOutputAudioPort(.speaker)
        try session.setActive(true)
        
        
        //create URL for the audio file
            let basePath : String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath, "audio.m4a"]
                audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            
        // create settings for the audio recorder
            var settings : [String:AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject
            settings[AVSampleRateKey] = 44100.0 as AnyObject
            settings[AVNumberOfChannelsKey] = 2 as AnyObject
            
        
        // Create Audiorecorder Object
        audioRecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
        audioRecorder!.prepareToRecord()
        } catch let error as NSError {
             print("! Error coded by developer with 24g45h4qh. Default details: " , error)
        }
            
    }




}
