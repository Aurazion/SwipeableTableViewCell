//
//  SwipeableScrollView.swift
//  SwipeableTableViewCell
//
//  Created by Julien PIERRE-LOUIS on 31/01/2017.
//  Copyright © 2017 Julien PIERRE-LOUIS. All rights reserved.
//

import UIKit

class SwipeableScrollView: UIScrollView {

    var customDelegate : UIResponder?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        customDelegate?.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        customDelegate?.touchesEnded(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        customDelegate?.touchesMoved(touches, with: event)
    }

}
