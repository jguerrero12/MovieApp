//
//  MoviesViewController.swift
//  MovieApp
//
//  Created by ALBA DEMICHAEL on 1/29/17.
//  Copyright © 2017 Jose Guerrero. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {

   
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var NetworkEffectView: networkErrorView!
    
    var searchBar = UISearchBar()
    var endPoint: String = ""
    var movies: [NSDictionary]?
    var filteredData: [NSDictionary]?
    
    @IBAction func tappedNewtorkError(_ sender: Any) {
        refreshControlAction(refreshControl: UIRefreshControl())

    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.placeholder = "Search"
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        
        // add refresh control to collection View
        collectionView.insertSubview(refreshControl, at: 0)
        
        self.navigationItem.titleView = searchBar
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endPoint)?api_key=\(apiKey)&language=en-US&page=1")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        MBProgressHUD.showAdded(to: self.view, animated: true) // Begin load animation
        
        let task: URLSessionDataTask = session.dataTask(with: request) {
            (data: Data?, response: URLResponse?, error: Error?) in
            
            
            if let data = data {
                self.NetworkEffectView.isHidden = true
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    self.movies = dataDictionary["results"] as? [NSDictionary]
                    self.filteredData = self.movies
                    self.collectionView.reloadData()
                }
            }
            else{
                self.NetworkEffectView.isHidden = false
                
            }
        }
        MBProgressHUD.hide(for: self.view, animated: true) // End load animation
        
        task.resume()
    }
    
    // Makes a network request to get updated data
    // Updates the collectionView with the new data
    // Hides the RefreshControl
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endPoint)?api_key=\(apiKey)&language=en-US&page=1")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
    
        MBProgressHUD.showAdded(to: self.view, animated: true) // Begin load animation
        let task: URLSessionDataTask = session.dataTask(with: request) {
            (data: Data?, response: URLResponse?, error: Error?) in
            
            if let data = data {
                self.NetworkEffectView.isHidden = true
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    self.movies = dataDictionary["results"] as? [NSDictionary]
                    self.filteredData = self.movies
                    self.collectionView.reloadData()
                    
                }
            }
            else {
                self.NetworkEffectView.isHidden = false
            }
            
            // Reload the collectionView now that there is new data
            self.collectionView.reloadData()
            
            // Tell the refreshControl to stop spinning
            refreshControl.endRefreshing()
        }
        MBProgressHUD.hide(for: self.view, animated: true) // End load animation
        task.resume()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if let filteredData = filteredData {
            return filteredData.count
        }
        else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "posterCell", for: indexPath) as! PosterCollectionViewCell
        let movie = filteredData![indexPath.row]
        let movieTitle = movie["title"] as! String
        let baseUrl = "https://image.tmdb.org/t/p/w500"
        
        if let posterPath = movie["poster_path"] as? String{
            let imageUrl = NSURL(string: baseUrl + posterPath)
            let imageRequest = NSURLRequest(url: imageUrl! as URL)
            cell.movieTitleLabel.text = movieTitle
            cell.posterImageView.setImageWith( imageRequest as URLRequest, placeholderImage: nil, success: {
                (imageRequest, imageResponse, image) -> Void in
                
                // imageResponse will be nil if the image is cached
                if imageResponse != nil {
                    //image was not cached so fade
                    cell.posterImageView.alpha = 0.0
                    cell.posterImageView.image = image
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        cell.posterImageView.alpha = 1.0
                    })
                } else {
                    // image was cached so just update image
                    cell.posterImageView.image = image
                }
            },
            failure: { (imageRequest, imageResponse, error) -> Void in
                    
            })
            
        }
        
        
        return cell
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    // This method updates filteredData based on the text in the Search Box
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // When there is no text, filteredData is the same as the original data
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        
        filteredData = searchText.isEmpty ? movies : movies!.filter({(dataString: NSDictionary) -> Bool in
            // If dataItem matches the searchText, return true to include it
            let title = dataString["title"] as! String
            return title.range(of: searchText, options: .caseInsensitive) != nil
        })
        
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        collectionView.deselectItem(at: indexPath, animated: true)
        collectionView.reloadItems(at: [indexPath])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UICollectionViewCell
        let indexPath = collectionView.indexPath(for: cell)
        let movie = filteredData![indexPath!.row]
        let detailedViewController = segue.destination as! detailedView
        detailedViewController.movie = movie
    }

}
