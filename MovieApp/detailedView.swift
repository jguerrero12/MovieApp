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
    
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let title = movie["title"] as? String
        let overviewTxt = movie["overview"] as? String
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height:
            infoView.frame.origin.y + infoView.frame.size.height)
        movieTitle.text = title
        overview.text = overviewTxt
        overview.sizeToFit()
        
        let baseUrl = "https://image.tmdb.org/t/p/w500"
        
        if let posterPath = movie["poster_path"] as? String{
            let imageUrl = NSURL(string: baseUrl + posterPath)
            posterImage.setImageWith(imageUrl as! URL)
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
