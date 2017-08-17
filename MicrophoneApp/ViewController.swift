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
    
    //this array contain the m4a files fetched from CoreData:
    var soundsList : [Sound] = []
    
    //AudioPlayer controller:
    var audioPlayer : AVAudioPlayer?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    //this function is called every each time the viewController is shown:
    override func viewWillAppear(_ animated: Bool)
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do
        {
            //fetch audios from coredata and assign them to this local array:
            soundsList = try context.fetch(Sound.fetchRequest())
            
            //update the table view with the new m4a files:
            tableView.reloadData()
        } catch {}
        
    }
    
    //this function sets the number of cells:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return soundsList.count
    }
    
    
    //defining the cell:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
        
        let soundName = soundsList[indexPath.row]
        
        cell.textLabel?.text = soundName.name
        
        
        return cell;
    }
    
    
    //this function runs each time a cell is tapped:
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let sound = soundsList[indexPath.row]
        _ = AVAudioPlayer()
        
        //play the specific audio:
        do
        {
        audioPlayer = try AVAudioPlayer(data: sound.audio! as Data)
        audioPlayer?.play()
        } catch {}
        
        //visually deselect the row after tapping it, 'cause it's annoying:
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //this function allows the user to delete a cell in the table view. In the same time, it deletes that object from coredata:
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            print("\n Deleting cell \n")
            let sound = soundsList[indexPath.row]
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            //delete that specific sound from coredata:
            context.delete(sound)
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do
            {
                //reupdate local array and the tableview:
                soundsList = try context.fetch(Sound.fetchRequest())
                tableView.reloadData()
            } catch {}
        }
    }



}

