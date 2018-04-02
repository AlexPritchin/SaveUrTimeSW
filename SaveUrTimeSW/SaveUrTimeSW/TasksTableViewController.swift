//
//  TasksTableViewController.swift
//  SaveUrTimeSW
//
//  Created by Alex Pritchin on 27/03/18.
//  Copyright © 2018 Alex Pritchin. All rights reserved.
//

import UIKit

class TasksTableViewController: UITableViewController, UIGestureRecognizerDelegate {

    @IBOutlet var tableViewOutlet: UITableView!
    
    private var tasksArray : [Task]?
    private var dataBase: DBWorkerCoreData?
    private var taskMode: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tasksArray = [Task]()
        dataBase = DBWorkerCoreData()
        taskMode = -1
        self.tableViewOutlet.tableFooterView = UIView()
        self.tableViewOutlet.rowHeight = UITableViewAutomaticDimension
        self.tableViewOutlet.estimatedRowHeight = 57;
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        let rightSwipeRecognizer = UISwipeGestureRecognizer.init(target: self, action: #selector(rightSwipe))
        rightSwipeRecognizer.delegate = self;
        rightSwipeRecognizer.direction = UISwipeGestureRecognizerDirection.right
        self.tableViewOutlet.addGestureRecognizer(rightSwipeRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tasksArray = dataBase!.selectTasksForTable()
        self.tableViewOutlet.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasksArray!.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : TaskTableViewCell? = tableView.dequeueReusableCell(withIdentifier: TASK_CELL_REUSABLE_IDENTIFIER, for: indexPath) as? TaskTableViewCell
        
        if cell == nil {
            return UITableViewCell()
        }
        
        cell!.loadData(taskForLoadData: tasksArray![indexPath.row])

        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        taskMode = TaskWorkMode.TASK_WORK_MODE_VIEW.rawValue
        self.performSegue(withIdentifier: SEGUE_IDENTIFIER_FROM_TASK_TABLE_TO_TASK_DETAIL, sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SEGUE_IDENTIFIER_FROM_TASK_TABLE_TO_TASK_DETAIL {
            let nTaskViewContr : TasksDetailViewController = segue.destination as! TasksDetailViewController
            if (taskMode == TaskWorkMode.TASK_WORK_MODE_VIEW.rawValue) {
                nTaskViewContr.taskToDisplay = tasksArray![(sender as? IndexPath)!.row]
            }
            else {
                nTaskViewContr.taskToDisplay = nil;
            }
            nTaskViewContr.dbWork = dataBase
            nTaskViewContr.taskMode = taskMode
        }
    }
    
    @IBAction func newTaskButtonTouched(_ sender: Any) {
        taskMode = TaskWorkMode.TASK_WORK_MODE_NEW.rawValue
        self.performSegue(withIdentifier: SEGUE_IDENTIFIER_FROM_TASK_TABLE_TO_TASK_DETAIL, sender: sender)
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dataBase!.remove(existingTaskCreatedDate: tasksArray![indexPath.row].createdDate!)
            tasksArray!.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        }
    }
    
    func rightSwipe(gestureRecognizer: UISwipeGestureRecognizer){
        let location = gestureRecognizer.location(in: self.tableViewOutlet)
        var indexPath = self.tableViewOutlet.indexPathForRow(at: location)
        tasksArray![indexPath!.row].status = TaskStatus.TASK_STATUS_COMPLETED.rawValue
        dataBase!.update(existingTask: tasksArray![indexPath!.row])
        self.tableViewOutlet.reloadData()
    }

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
