//
//  ViewController.swift
//  PirateRadio
//
//  Created by A-Team Intern on 17.06.21.
//

import UIKit
import Toast_Swift
import YoutubePlayer_in_WKWebView

class ViewController: UIViewController, UISearchBarDelegate
{
//    @IBOutlet weak var playerView: WKYTPlayerView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.playerView.load(withVideoId: "mqxJx05S3HY")
//    }

    var searchController: UISearchController!
    override func viewDidLoad() {
        self.searchController = UISearchController.init(searchResultsController: nil)
        self.searchController.searchBar.delegate = self
        self.navigationItem.searchController = searchController
    }
}

