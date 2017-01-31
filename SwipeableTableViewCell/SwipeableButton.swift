//
//  SwipeableButton.swift
//  SwipeableTableViewCell
//
//  Created by Julien PIERRE-LOUIS on 31/01/2017.
//  Copyright © 2017 Julien PIERRE-LOUIS. All rights reserved.
//

import UIKit

class SwipeableButton: UIButton {

    var onTouchUpInside:((Void)->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action: #selector(SwipeableButton.didTouchUpInside(sender:)), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    func didTouchUpInside(sender:AnyObject) {
        self.onTouchUpInside?()
    }

}
