//
//  Detail.swift
//  yxA2
//
//  Created by zhananhua on 2019/4/12.
//  Copyright © 2019 xin.yan. All rights reserved.
//

import UIKit

class Detail: UIViewController {

    @IBOutlet weak var P2Artist: UILabel!
    @IBOutlet weak var P2Image: UIImageView!
    @IBOutlet weak var P2ImageDetail: UILabel!
    @IBOutlet weak var P2Year: UILabel!
    @IBOutlet weak var P2Content: UILabel!
    
    var jdata : ArtWork?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //----set the title, which is the artist's name
        P2Artist.text = jdata?.artist
        //----set imageview of artwork
        let imageCache = NSCache<NSString, UIImage>()
        var UrlWithoutSpace = ""
        var imgURL = ""
        if let UrlWithSpace = jdata?.fileName{
            UrlWithoutSpace = UrlWithSpace.replacingOccurrences(of: " ", with: "%20")
            imgURL = "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP228/artwork_images/\(String(describing: UrlWithoutSpace))"
        }
        if let imgurl = URL(string: imgURL){
            do{
                let imgdata = try Data(contentsOf: imgurl)
                let NSimgdata = NSString(string: imgURL)
                if let image = imageCache.object(forKey: NSimgdata){
                    self.P2Image.image = image
                }else{
                    let image = UIImage(data: imgdata)
                    imageCache.setObject(image!, forKey: NSimgdata)
                    self.P2Image.image = image
                }
            }catch let error{
                print("Error: \(error.localizedDescription)")
            }
        }
        //----set the describe text, which is the artwork's title
        P2ImageDetail.text = jdata?.title
        //----set the describe of year
        if var yearofwork = jdata?.yearOfWork{
            if yearofwork.isEmpty == true{
                yearofwork = yearofwork + "*** No info about year of work ***"
                P2Year.text = yearofwork
            }else{
                P2Year.text = yearofwork
            }
        }
        //----set the artwork's detail information
        P2Content.text = jdata?.Information
        
        
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
