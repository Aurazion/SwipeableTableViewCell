//
//  SwipeRowAction.swift
//  SwipeableTableViewCell
//
//  Created by Julien PIERRE-LOUIS on 31/01/2017.
//  Copyright © 2017 Julien PIERRE-LOUIS. All rights reserved.
//

import UIKit

private let DefaultWidth:CGFloat = 80.0

public struct SwipeRowAction {
    
    public var title: String?
    public var image: UIImage?
    public var backgroundColor: UIColor?
    public var width: CGFloat = DefaultWidth
    public var action: (Void) -> Void
    
}
