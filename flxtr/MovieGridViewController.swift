//
//  MovieGridViewController.swift
//  flxtr
//
//  Created by user160656 on 12/6/19.
//  Copyright © 2019 Daniel. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieGridViewController: UIViewController,
    UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    var movies = [[String: Any]]()
    private let sectionInsets = UIEdgeInsets(top: 10,
                                         left: 20.0,
                                         bottom: 10,
                                         right: 20.0)
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/297762/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
              let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            self.movies = dataDictionary["results"] as! [[String: Any]]
            self.collectionView.reloadData()
           }
        }
        task.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding = sectionInsets.left * 3
        let width = (view.frame.size.width - padding)/2
        return CGSize(width: width, height: width * 3/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCell
        
        let movie = movies[indexPath.item]
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let url = URL(string: baseUrl + posterPath)
        cell.posterView.af_setImage(withURL: url!)
        //cell.layoutIfNeeded()
        return cell
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //         Get the new view controller using segue.destination.
    //         Pass the selected object to the new view controller.
        let cell = sender as! MovieGridCell
        let indexPath = collectionView.indexPath(for: cell)!
        let movie = movies[indexPath.row]
        let detailsViewController = segue.destination as! MovieDetailsViewController
        detailsViewController.movie = movie
        collectionView.deselectItem(at: indexPath, animated: false)
    }
}
