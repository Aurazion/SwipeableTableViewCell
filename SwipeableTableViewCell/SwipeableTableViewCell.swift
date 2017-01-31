//
//  SwipeableTableViewCell.swift
//  SwipeableTableViewCell
//
//  Created by Julien PIERRE-LOUIS on 31/01/2017.
//  Copyright © 2017 Julien PIERRE-LOUIS. All rights reserved.
//

import UIKit

class SwipeableTableViewCell: UITableViewCell, UIScrollViewDelegate {
    
    enum SwipeableTableViewCellSide:Int {
        case Left
        case Right
    }
    
    private var buttonViews:[UIView]!
    private static let CloseEvent:String = "SwipeableTableViewCellClose"
    private let OpenVelocityThreshold:CGFloat = 0.6;
    private let MaxCloseMilliseconds:CGFloat = 300
    private var tempCloseComplete:((Void)->(Void))?
    
    var scrollViewContentView:UIView = UIView()
    var scrollView:SwipeableScrollView!
    var leftInset:CGFloat {
        let view = self.buttonViews[SwipeableTableViewCellSide.Left.rawValue]
        return view.bounds.width
    }
    var rightInset:CGFloat {
        let view = self.buttonViews[SwipeableTableViewCellSide.Right.rawValue]
        return view.bounds.width
    }
    
    var rightActions: [SwipeRowAction]? {
        didSet{
            setupActions(actions: rightActions, forSide: .Right)
        }
    }
    
    var leftActions: [SwipeRowAction]? {
        didSet{
            setupActions(actions: leftActions, forSide: .Left)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self);
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Public class methods
    
    class func closeAllCells() {
        self.closeAllCellsExcept(cell: nil)
    }
    
    class func closeAllCellsExcept(cell:SwipeableTableViewCell?){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SwipeableTableViewCell.CloseEvent), object: cell)
    }
    
    // MARK: Public methods
    
    func close(complete:(()->Void)?) {
        guard self.scrollView.contentOffset != CGPoint.zero else {
            complete?()
            return
        }
        self.scrollView.setContentOffset(CGPoint.zero, animated: true)
        if let complete = complete {
            tempCloseComplete = complete
            Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(SwipeableTableViewCell.handleCloseComplete(timer:)), userInfo: nil, repeats: false)
        }
    }
    
    
    func openSide(side:SwipeableTableViewCellSide) {
        self.openSide(side: side,animated:true)
    }
    
    func openSide(side:SwipeableTableViewCellSide,animated:Bool) {
        SwipeableTableViewCell.closeAllCellsExcept(cell: self)
        switch side {
        case .Left:
            self.scrollView.setContentOffset(CGPoint(x: -self.leftInset,y: 0), animated: animated)
        case .Right:
            self.scrollView.setContentOffset(CGPoint(x: self.rightInset,y: 0), animated: animated)
            
        }
    }
    
    
    // MARK: Private func
    
    @objc
    private func handleCloseComplete(timer:Timer) {
        timer.invalidate()
        tempCloseComplete!()
        tempCloseComplete = nil
    }
    
    private func updateScrollContentInset(){
        // Update the scrollable areas outside the scroll view to fit the buttons.
        self.scrollView.contentInset = UIEdgeInsetsMake(0, self.leftInset, 0, self.rightInset)
    }
    
    private func setup() {
        // Create the scroll view which enables the horizontal swiping.
        let scrollView = SwipeableScrollView(frame: self.contentView.bounds)
        scrollView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
        scrollView.delegate = self
        scrollView.scrollsToTop = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        self.scrollView = scrollView
        self.scrollView.customDelegate = self
        self.addSubview(scrollView)
        
        var contentBouds = self.contentView.bounds.size
        contentBouds.height = 0
        self.scrollView.contentSize = contentBouds
        self.backgroundColor = self.contentView.backgroundColor
        
        // Create the containers which will contain buttons on the left and right sides.
        self.buttonViews = [self.createButtonsView(),self.createButtonsView()]
        
        // Set up main content area.
        let contentView = UIView(frame:scrollView.bounds)
        contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        contentView.backgroundColor = UIColor.white
        scrollView.addSubview(contentView)
        self.scrollViewContentView = contentView
        
        self.contentView.removeFromSuperview()
        self.scrollViewContentView.addSubview(self.contentView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleCloseEvent), name: NSNotification.Name(rawValue: SwipeableTableViewCell.CloseEvent), object: nil)
        
    }
    
    private func createButtonsView() -> UIView{
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: self.contentView.bounds.height))
        view.autoresizingMask = .flexibleHeight
        self.scrollView.addSubview(view)
        return view
    }
    
    @objc
    private func handleCloseEvent(notification:NSNotification) {
        if notification.object != nil && self == notification.object as? SwipeableTableViewCell {
            return
        }
        self.close(complete: nil)
    }
    
    private func setupActions(actions:[SwipeRowAction]?,forSide side:SwipeableTableViewCellSide){
        guard let actions = actions else {
            return
        }
        self.clearButtonsOnSide(side: side)
        for a in actions{
            let button = createButtonWithWidth(width: a.width, onSide: side)
            button.onTouchUpInside = a.action
            button.imageView?.contentMode = .scaleAspectFit
            button.setImage(a.image, for: .normal)
            button.setTitle(a.title, for: .normal)
            button.backgroundColor = a.backgroundColor
        }
    }
    
    private func createButtonWithWidth(width:CGFloat,onSide side:SwipeableTableViewCellSide) -> SwipeableButton{
        let container = self.buttonViews[side.rawValue]
        let size = container.bounds.size
        
        let button = SwipeableButton(type:.custom)
        button.autoresizingMask = .flexibleHeight
        button.frame = CGRect(x: size.width, y: 0, width: width, height: size.height)
        
        
        // Resize the container to fit the new button.
        var x:CGFloat!
        switch side {
        case .Left:
            x = -(size.width + width)
        case .Right:
            x = self.contentView.bounds.width
        }
        
        container.frame = CGRect(x: x, y: 0, width: size.width + width, height: size.height)
        container.addSubview(button)
        
        // Update the scrollable areas outside the scroll view to fit the buttons.
        self.updateScrollContentInset()
        
        return button
    }
    
    private func clearButtonsOnSide(side:SwipeableTableViewCellSide){
        let containter:UIView = self.buttonViews[side.rawValue]
        let size = containter.bounds.size
        
        // Reset container width based on which side is it
        var x:CGFloat!
        switch side {
        case .Left:
            x = 0
        case .Right:
            x = self.contentView.bounds.width - containter.frame.width
        }
        containter.frame = CGRect(x: x, y: 0, width: 0, height: size.height)
        
        self.updateScrollContentInset()
    }
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setHighlighted(false, animated: false)
        
        if ((self.leftInset == 0 && scrollView.contentOffset.x < 0) || (self.rightInset == 0 && scrollView.contentOffset.x > 0)) {
            scrollView.contentOffset = CGPoint.zero
        }
        
        let leftView = self.buttonViews[SwipeableTableViewCellSide.Left.rawValue]
        let rightView = self.buttonViews[SwipeableTableViewCellSide.Right.rawValue]
        if (scrollView.contentOffset.x < 0) {
            // Make the left buttons stay in place.
            leftView.frame = CGRect(x: scrollView.contentOffset.x, y: 0, width: self.leftInset, height: leftView.frame.size.height)
            leftView.isHidden = false
            // Hide the right buttons.
            rightView.isHidden = true
        } else if (scrollView.contentOffset.x > 0) {
            // Make the right buttons stay in place.
            rightView.frame = CGRect(x: self.contentView.bounds.size.width - self.rightInset + scrollView.contentOffset.x, y: 0,
                                     width: self.rightInset, height: rightView.frame.size.height)
            rightView.isHidden = false
            // Hide the left buttons.
            leftView.isHidden = true
        } else {
            leftView.isHidden = true
            rightView.isHidden = true
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        SwipeableTableViewCell.closeAllCellsExcept(cell: self)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        var targetContentOffset = targetContentOffset
        let x:CGFloat = scrollView.contentOffset.x
        let left = self.leftInset
        let right = self.rightInset
        if (left > 0 && (x < -left || (x < 0 && velocity.x < -OpenVelocityThreshold))) {
            targetContentOffset.pointee.x = -left;
        } else if (right > 0 && (x > right || (x > 0 && velocity.x > OpenVelocityThreshold))) {
            targetContentOffset.pointee.x = right;
        } else {
            targetContentOffset.pointee = CGPoint.zero;
            
            // If the scroll isn't on a fast path to zero, animate it instead.
            let ms:CGFloat = x / -velocity.x;
            if (velocity.x == 0 || ms < 0 || ms > MaxCloseMilliseconds) {
                DispatchQueue.main.async{
                    scrollView.setContentOffset(CGPoint.zero, animated: true)
                }
            }
        }
    }
    
    // MARK: UIView
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var contentBounds:CGSize = self.contentView.bounds.size;
        contentBounds.height = 0; // to be sure that there wont be no vertical scrolling
        self.scrollView.contentSize = contentBounds;
        self.scrollView.contentOffset = CGPoint.zero;
    }

}
