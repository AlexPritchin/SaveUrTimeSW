//
//  NewsTableViewController.swift
//  SaveUrTimeSW
//
//  Created by Alex Pritchin on 24/03/18.
//  Copyright © 2018 Alex Pritchin. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController, NewsDataWorkerDelegate {

    @IBOutlet var tableViewOutlet: UITableView!
    
    private var dataDownldActInd : UIActivityIndicatorView?
    private var newsArticlesArray : [NewsArticle]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataDownldActInd = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        self.tableViewOutlet.backgroundView = dataDownldActInd
        self.tableViewOutlet.tableFooterView = UIView()
        self.tableViewOutlet.rowHeight = UITableViewAutomaticDimension
        self.tableViewOutlet.estimatedRowHeight = 57

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if newsArticlesArray == nil {
            dataDownldActInd!.startAnimating()
            let rssWorker = NewsDataWorker()
            rssWorker.delegate = self;
            rssWorker.initializeData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let newsArtArr = newsArticlesArray {
            return newsArtArr.count
        }
        else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : NewsTableViewCell? = tableView.dequeueReusableCell(withIdentifier: NEWS_CELL_REUSABLE_IDENTIFIER, for: indexPath) as? NewsTableViewCell
        
        if cell == nil {
            return UITableViewCell()
        }
        
        cell!.loadData(articleForLoadData: newsArticlesArray![indexPath.row])

        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier:SEGUE_IDENTIFIER_FROM_NEWS_TABLE_TO_NEWS_ARTICLE, sender:indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SEGUE_IDENTIFIER_FROM_NEWS_TABLE_TO_NEWS_ARTICLE {
            let nArtViewContr : NewsArticleViewController = segue.destination as! NewsArticleViewController
            nArtViewContr.articleToDisplay = newsArticlesArray![(sender as? IndexPath)!.row]
        }
    }
    
    func didFinishDataInitialization(rssDataArray : [NewsArticle]){
        newsArticlesArray = [NewsArticle]()
        newsArticlesArray = rssDataArray
        dataDownldActInd!.stopAnimating()
        self.tableViewOutlet.reloadData()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


}
