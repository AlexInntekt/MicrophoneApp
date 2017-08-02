//
//  ViewController.swift
//  MicrophoneApp
//
//  Created by Manolescu Mihai Alexandru on 31/07/2017.
//  Copyright © 2017 Manolescu Mihai Alexandru. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{

    @IBOutlet weak var tableView: UITableView!
    
    var soundsList : [Sound] = []
    var audioPlayer : AVAudioPlayer?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do
        {
            soundsList = try context.fetch(Sound.fetchRequest())
            tableView.reloadData()
        } catch {}
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return soundsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
        
        let sound = soundsList[indexPath.row]
        
        cell.textLabel?.text = sound.name
        
        
        return cell;
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let sound = soundsList[indexPath.row]
        let audio = AVAudioPlayer()
        
        do
        {
        audioPlayer = try AVAudioPlayer(data: sound.audio as! Data)
        audioPlayer?.play()
        } catch {}
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            print("\n Deleting cell \n")
            let sound = soundsList[indexPath.row]
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            context.delete(sound)
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do
            {
                soundsList = try context.fetch(Sound.fetchRequest())
                tableView.reloadData()
            } catch {}
        }
    }



}

