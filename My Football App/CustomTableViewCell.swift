//
//  CustomTableViewCell.swift
//  My Football App
//
//  Created by Daniil Reshetnyak on 7/15/20.
//  Copyright © 2020 Daniil Reshetnyak. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import WebKit
import Foundation
import CoreData

class CustomTableViewCell: UITableViewCell, WKUIDelegate {

    var delegate: ViewController!
    var dataSource: FMatch?
    
    var webView: WKWebView!
    
    @IBOutlet weak var CompetitionName: UILabel!
   
    @IBOutlet weak var Date: UILabel!
    
    @IBOutlet weak var Title: UILabel!
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBAction func playVideo(_ sender: UIButton ) {
        

        if ReachabilityTest.isConnectedToNetwork() {
           
            let webVC = self.delegate.storyboard!.instantiateViewController(withIdentifier: "WebContentVC") as! WebContentViewController
            webVC.id = sender.tag
            self.delegate.navigationController?.pushViewController(webVC, animated: true)
            webVC.dataSourse = self.delegate
            
            
        }
        else{
            
            let alert = UIAlertController(title: "No Internet connection", message: "Connect and try again", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
            alert.addAction(ok)
            self.delegate.present(alert, animated: true, completion: nil)
            
            
            
        }
        
        
    }
    @IBOutlet weak var thumbnailImageView: UIImageView!
}
