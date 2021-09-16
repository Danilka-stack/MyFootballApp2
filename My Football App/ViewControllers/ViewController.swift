//
//  ViewController.swift
//  My Football App
//
//  Created by Daniil Reshetnyak on 7/14/20.
//  Copyright © 2020 Daniil Reshetnyak. All rights reserved.
//

import UIKit
import SVProgressHUD
import Foundation
import CoreData

//import SwiftSoup

class ViewController: UIViewController, ModelDelegate, UITableViewDataSource, AppDelegateProtocol {
    

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var dataModel = DataModel()
    var matches = [FMatch]()
    
    @IBOutlet weak var tabelView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        SVProgressHUD.show()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.delegate = self
        
        dataModel.delegate = self
        tabelView.dataSource = self
        
        self.internetTestAndConnection()
        
        tabelView.reloadData()

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return matches.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell

        guard self.matches.count > 0 else {
            
            let cell = UITableViewCell()
            return cell
            
        }
       
        let match = matches[indexPath.row]

        cell.Title.text = match.title
        cell.Date.text = match.date
        cell.CompetitionName.text = match.competitionName
        cell.playButton.tag = indexPath.row
        cell.delegate = self
        cell.dataSource = match
    
        return cell
        
    }
    
    
    func matchesFetched(matches: [FMatch]) {
        
        self.matches = matches
        
        DispatchQueue.main.async {
            
            self.tabelView.reloadData()
            
        }
        
        SVProgressHUD.dismiss()
        
        print("data is fetched from dataModel")
    }
    
    func internetTestAndConnection() {
        
        if ReachabilityTest.isConnectedToNetwork() {
            // If there is Internet connection

            SVProgressHUD.show()
            dataModel.downloadData()
            self.tabelView.reloadData()
            
        }
        else {
            //If there isnt Internet connection
            SVProgressHUD.dismiss()
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FMatch")
            var count = Int()
            
            do {
                count = try context.count(for: request)
            }
            catch {
                print("Error")
            }
        
            if count == 0 {
                
                let alert = UIAlertController(title: "No Internet connection", message: "Connect and try again", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Try", style: .default) { (action) in
                    
                    self.internetTestAndConnection()
                    
                }
                
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                
            }
            
            if count > 0 {
                
                SVProgressHUD.dismiss()
                
                let alert2 = UIAlertController(title: "No Internet connection", message: "Display unactual data or connect to the Internet ", preferredStyle: .alert)
                let display = UIAlertAction(title: "Display unactual data", style: .default) { (action) in
                    
                    do {
                        
                        self.matches = try self.context.fetch(FMatch.fetchRequest())
                        
                    }
                    catch {
                        
                        print("Error")
                        
                    }
                    
                    self.tabelView.reloadData()
                }
                
                let reconnect = UIAlertAction(title: "Reconnect", style: .default) { (action) in
                    
                    self.internetTestAndConnection()
                    
                }
                
                alert2.addAction(reconnect)
                alert2.addAction(display)
                
                self.present(alert2, animated: true, completion: nil)
                
            }
        }
    }

}


