//
//  DataModel.swift
//  My Football App
//
//  Created by Daniil Reshetnyak on 7/14/20.
//  Copyright © 2020 Daniil Reshetnyak. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol ModelDelegate {
    
    func matchesFetched(matches: [FMatch])
    
}

struct DataModel {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var delegate: ModelDelegate?
    
    func downloadData() {

        // Download data
        let jsonUrlStrig = "https://www.scorebat.com/video-api/v1/"
        let url = URL(string: jsonUrlStrig)
        
        let session = URLSession.shared
            
           let dataTask = session.dataTask(with: url!) { (data, response, error) in

            if error != nil || data == nil {
                
                return
                
            }
            
            do {
                
                print(data!)
                //Parsing the data into match object
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let matches = try decoder.decode([Match].self, from: data!)
                
                // Expand array with FMatch elements
    
                var finalMatches = [FMatch]()
               
                 DispatchQueue.main.async{
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let contex = appDelegate.persistentContainer.viewContext
                    
                    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "FMatch")
                    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                    
                    do {
                        
                        try contex.execute(deleteRequest)
                        
                    } catch let error as NSError {
                        
                        print("\(error)")
                    }
                    
                    for i in matches {
                    
                        let fMatch = FMatch(context: self.context)
                        fMatch.side1 = i.side1
                        fMatch.side2 = i.side2
                        fMatch.competitionName = i.competitionName
                        fMatch.title = i.title
                        fMatch.videosURL = "\(i.videos)"
                        fMatch.date = i.date
                        
                        finalMatches.append(fMatch)
                        
                        do {
                            try self.context.save()
                            
                        }
                        catch let error as NSError {
                            print("Could not save. \(error), \(error.userInfo)")
                        }
                        
                    }
                    
                    self.delegate?.matchesFetched(matches: finalMatches)
                }
                
                print("do something")

                dump(matches)
                
            } catch let jsonError {

                print("Error serializing json:", jsonError)
            
            }
        
        }

        dataTask.resume()

    }

}

