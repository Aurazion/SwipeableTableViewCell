//
//  TableViewController.swift
//  SwipeableTableViewCell
//
//  Created by Julien PIERRE-LOUIS on 31/01/2017.
//  Copyright © 2017 Julien PIERRE-LOUIS. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    
    let labels:[String] = ["Pippi Longstocking", "Austin Powers", "Spider-Man", "James Bond",
                           "Lisbeth Salander", "Donald Duck", "Luke Skywalker", "Lara Croft",
                           "Frodo Baggins", "Hermione Granger", "Dexter Morgan", "Ted Mosby",
                           "Homer Simpson", "John Connor", "Arya Stark", "Captain Kirk"]
    let blue:UIColor = UIColor(red: 0.23, green: 0.34, blue: 0.58, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Private
    
    private func showAlertWithTitle(title:String,msg:String) {
        //        let alert = UIAlertController(title: "Tee-hee", message: "Stop it!", preferredStyle: .Alert)
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay 😀", style: .default,handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: UIScrollVieDelegate
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        SwipeableTableViewCell.closeAllCells()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labels.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIndentifier = "randomCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIndentifier, for: indexPath) as! SwipeableTableViewCell
        
        let tickleAction = SwipeRowAction(title: "Tickle", image: nil, backgroundColor: blue, width: 100) { _ in
            cell.close(complete: nil)
            self.showAlertWithTitle(title: "Tee-hee",msg:"Stop it!")
        }
        
        let moreAction = SwipeRowAction(title: "More", image: nil, backgroundColor: UIColor.lightGray, width: 80) { _ in
            cell.close(complete: nil)
            self.showAlertWithTitle(title: "You want MORE?!",msg:"no")
            print("More button tapped")
        }
        
        let deleteAction = SwipeRowAction(title: nil, image: UIImage(named: "trash"), backgroundColor: UIColor.red, width: 80) { _ in
            cell.close(complete: nil)
            self.showAlertWithTitle(title: "NOOoo",msg:"don't delete me")
            print("Delete button tapped")
        }
        
        cell.leftActions = [tickleAction]
        cell.rightActions = [moreAction,deleteAction]
        cell.textLabel?.text = labels[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showAlertWithTitle(title: "I've been selected!", msg: "I'm the chosen one!")
        print("selected \(indexPath.row)")
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
