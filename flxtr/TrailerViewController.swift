//
//  TrailerViewController.swift
//  flxtr
//
//  Created by user160656 on 2/4/20.
//  Copyright © 2020 Daniel. All rights reserved.
//

import UIKit
import WebKit

class TrailerViewController: UIViewController, WKUIDelegate {

    @IBOutlet weak var webView: WKWebView!
    var trailerUrlString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: trailerUrlString)
        let myRequest = URLRequest(url: url!)
        webView.load(myRequest)
        // Do any additional setup after loading the view.
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
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
