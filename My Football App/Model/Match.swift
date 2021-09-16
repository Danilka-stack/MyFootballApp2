//
//  MatchInfo.swift
//  My Football App
//
//  Created by Daniil Reshetnyak on 7/14/20.
//  Copyright © 2020 Daniil Reshetnyak. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct Match: Decodable {
    
    let competitionName: String
    var date: String
    let side1: String
    let side2: String
    let title: String
    var videos: URL

    enum CodingKeys: String, CodingKey {
        
        case competition
        case name
        case date
        case side1
        case side2
        case title
        case videos
        case embed
      
    }
    

    init(from decoder: Decoder) throws{
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let competitionContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .competition)
        
        competitionName = try competitionContainer.decode(String.self, forKey: .name)
        date = try container.decode(String.self, forKey: .date)
       
        let arr = self.date.components(separatedBy: "T")
        
        date = arr[0]
       
        let side1Container = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .side1)
        
        side1 = try side1Container.decode(String.self, forKey: .name)
        
        let side2Container = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .side2)
        
        side2 = try side2Container.decode(String.self, forKey: .name)
        title = try container.decode(String.self, forKey: .title)
        
        let embed = try container.decode(String.self, forKey: .embed)
        
        let array = embed.components(separatedBy: "\'")
        
        //Download videos
        
        var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        
        url?.appendPathComponent("videosData")
        
        videos = url!
        videos = URL(string: array[5])!
   
    }
}




