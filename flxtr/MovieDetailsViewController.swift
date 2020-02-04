//
//  MovieDetailsViewController.swift
//  flxtr
//
//  Created by user160656 on 12/6/19.
//  Copyright © 2019 Daniel. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieDetailsViewController: UIViewController {
    @IBOutlet weak var backdrop: UIImageView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    var movie: [String:Any]!
    var movieKey: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let movieId = movie["id"] as! Int
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
              let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            let result = dataDictionary["results"] as! [[String: Any]]
            let video = result[0]
            self.movieKey = video["key"] as? String
           }
        }
        task.resume()

        // Do any additional setup after loading the view.
        titleLabel.text = movie["title"] as? String
        titleLabel.sizeToFit()
        synopsisLabel.text = movie["overview"] as? String
        synopsisLabel.sizeToFit()
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        posterView.isUserInteractionEnabled = true
        posterView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
        )
        posterView.af_setImage(withURL: posterUrl!)
        
        let backdropPath = movie["backdrop_path"] as! String
        let backdropUrl = URL(string: "https://image.tmdb.org/t/p/w780" + backdropPath)
        backdrop.af_setImage(withURL: backdropUrl!)
    }
    
    @objc func imageTapped() {
        self.performSegue(withIdentifier: "trailerSegue", sender: nil)
    }
 

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "trailerSegue") {
            let trailerViewController = segue.destination as! TrailerViewController
            trailerViewController.trailerUrlString = "https://www.youtube.com/watch?v=\(movieKey!)"
        }
    }
}
