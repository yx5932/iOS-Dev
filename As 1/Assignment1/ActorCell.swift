//
//  Actor.swift
//  Assignment1
//
//  Created by Yan, Xin [sgxyan2] on 12/03/2019.
//  Copyright © 2019 Yan, Xin [sgxyan2]. All rights reserved.
//

import UIKit

class ActorCell: UITableViewCell {
    
    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var Subtitle: UILabel!
    @IBOutlet weak var SetFav: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
