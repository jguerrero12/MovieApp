//
//  detailedView.swift
//  Movies
//
//  Created by Jose Guerrero on 2/5/17.
//  Copyright © 2017 Jose Guerrero. All rights reserved.
//

import UIKit

class detailedView: UIViewController {

    @IBOutlet weak var overview: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var infoView: UIVisualEffectView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var genreHead: UILabel!
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var rDHead: UILabel!
    
    var movie: NSDictionary!
    var movieDetail: NSDictionary?
    var genreDict: [Int:String] = [28:  "Action",
        12: "Adventure",
        16: "Animation",
        35: "Comedy",
        80: "Crime",
        99: "Documentary",
        18: "Drama",
        10751: "Family",
        14: "Fantasy",
        36: "History",
        27: "Horror",
        10402: "Music",
        9648: "Mystery",
        10749: "Romance",
        878: "Science Fiction",
        10770: "TV Movie",
        53: "Thriller",
        10752: "War",
        37 : "Western"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title = movie["title"] as? String
        let overviewTxt = movie["overview"] as? String
        let genreId = movie["genre_ids"] as? [Int]
        
        movieTitle.text = title
        overview.text = overviewTxt
        overview.sizeToFit()
        
        releaseDateLabel.frame = CGRect(x: 121  , y: 100 + overview.bounds.height, width: 191, height: 18)
        genreLabel.frame = CGRect(x: 121, y: 119 + overview.bounds.height, width: 191, height: 18)
        genreHead.frame = CGRect(x: 8, y: 119 + overview.bounds.height, width: 42, height: 18)
        informationLabel.frame = CGRect(x: 8, y: 71 + overview.bounds.height, width: 103, height: 21)
        rDHead.frame = CGRect(x: 8, y: 100 + overview.bounds.height, width: 90, height: 18)
        
        releaseDateLabel.text = movie.object(forKey: "release_date") as! String?
        genreLabel.text = genreDict[genreId![0]] ?? "N/A"
            
        infoView.frame.size.height = genreLabel.frame.origin.y + genreLabel.frame.height + 5
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height:
        infoView.frame.origin.y + infoView.frame.size.height)
        
        let lowResolutionBaseURL = "https://image.tmdb.org/t/p/w45"
        let highResolutionBaseURL = "https://image.tmdb.org/t/p/original"
        
        if let posterPath = movie["poster_path"] as? String {
            let smallImageRequest = NSURLRequest(url: URL(string: lowResolutionBaseURL + posterPath)!)
            let largeImageRequest = NSURLRequest(url: URL(string: highResolutionBaseURL + posterPath)!)
            
            posterImage.setImageWith(smallImageRequest as URLRequest, placeholderImage: nil,
                                     success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                                        
                                        self.posterImage.alpha = 0.0
                                        self.posterImage.image = smallImage;
                                        
                                        UIView.animate(withDuration: 0.05, animations: { () -> Void in
                                            
                                            self.posterImage.alpha = 1.0
                                            
                                        }, completion: { (sucess) -> Void in
                                            
                                            // The AFNetworking ImageView Category only allows one request to be sent at a time
                                            // per ImageView. This code must be in the completion block.
                                            self.posterImage.setImageWith(
                                                largeImageRequest as URLRequest,
                                                placeholderImage: smallImage,
                                                success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                                                    
                                                    self.posterImage.image = largeImage;
                                                    
                                            },
                                                failure: { (request, response, error) -> Void in
                                                    self.posterImage.backgroundColor = UIColor.gray
                                                    self.posterImage.image = UIImage(named: "iconmonstr-video-3-240")
                                            })
                                        })
            },
                                     failure: { (request, response, error) -> Void in
                                        self.posterImage.setImageWith(
                                            largeImageRequest as URLRequest,
                                            placeholderImage: nil,
                                            success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                                                
                                                self.posterImage.image = largeImage;
                                                
                                        },
                                            failure: { (request, response, error) -> Void in
                                                self.posterImage.backgroundColor = UIColor.gray
                                                self.posterImage.image = UIImage(named: "iconmonstr-video-3-240")
                                        })
            })
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
