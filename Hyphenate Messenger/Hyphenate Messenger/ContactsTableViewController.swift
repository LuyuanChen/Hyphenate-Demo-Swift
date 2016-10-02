//
//  ContactsTableViewController.swift
//  Hyphenate Messenger
//
//  Created by peng wan on 9/27/16.
//  Copyright © 2016 Hyphenate Inc. All rights reserved.
//

import UIKit
import HyphenateFullSDK


class ContactsTableViewController:UITableViewController,EMGroupManagerDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {

    var dataSource = [AnyObject]()
    var searchController : UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        EMClient.sharedClient().groupManager.removeDelegate(self)
//        EMClient.sharedClient().groupManager.addDelegate(self)
        
        self.tableView.registerNib(UINib(nibName: "ContactTableViewCell", bundle: nil), forCellReuseIdentifier: ContactTableViewCell.reuseIdentifier())
        
        searchController = UISearchController(searchResultsController:  nil)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.delegate = self
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = true
        navigationItem.titleView = searchController.searchBar
        definesPresentationContext = true
        
        let image = UIImage(named: "iconAdd")
        let imageFrame = CGRectMake(0, 0, (image?.size.width)!, (image?.size.height)!)
        let addButton = UIButton(frame: imageFrame)
        addButton.setBackgroundImage(image, forState: .Normal)
        addButton.addTarget(self, action: Selector(addContactAction()), forControlEvents: .TouchUpInside)
        addButton.showsTouchWhenHighlighted = true
        let rightButtonItem = UIBarButtonItem(customView: addButton)
        navigationItem.rightBarButtonItem = rightButtonItem
        
        self.reloadDataSource()
    }
    
    func addContactAction() {
        
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
    }
    
    func reloadDataSource(){
        self.dataSource.removeAll()
//        self.dataSource = EMClient.sharedClient().groupManager.getJoinedGroups()
        EMClient.sharedClient().contactManager.getContactsFromServerWithCompletion({ (array, error) in
            self.dataSource = array
            dispatch_async(dispatch_get_main_queue(), { 
                self.tableView.reloadData()
            })
        })
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ContactTableViewCell.reuseIdentifier()) as! ContactTableViewCell
        cell.displayNameLabel.text = self.dataSource[indexPath.row] as? String
        return cell
    }
 
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
}