//
//  VideoViewController.swift
//  My Football App
//
//  Created by Daniil Reshetnyak on 7/22/20.
//  Copyright © 2020 Daniil Reshetnyak. All rights reserved.
//

import UIKit
import WebKit

class WebContentViewController: UIViewController, WKUIDelegate {

    var dataSourse: ViewController?
    var id: Int?
    @IBOutlet weak var webView: WKWebView!
    
    override func loadView() {
        
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // open a match preview with a specific link
        guard let id = id else { return }
        
        let match = dataSourse?.matches[id]
        
        guard (match?.videosURL) != nil else { return }
        guard let videosURL = (match?.videosURL) else { return }
        
        let url = URL(string: videosURL)

        let myRequest = URLRequest(url: url!)
        
        webView.load(myRequest)

    }
}
