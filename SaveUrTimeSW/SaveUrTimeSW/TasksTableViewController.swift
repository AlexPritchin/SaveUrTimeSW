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
    
    private let TASK_CELL_REUSABLE_IDENTIFIER = "TaskCell"
    private let SEGUE_IDENTIFIER_FROM_TASK_TABLE_TO_TASK_DETAIL = "ToTaskDetails"
    private var tasksArray : [Task]?
    private var taskMode: TaskWorkMode = .undefined
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tasksArray = [Task]()
        self.tableViewOutlet.tableFooterView = UIView()
        self.tableViewOutlet.rowHeight = UITableViewAutomaticDimension
        self.tableViewOutlet.estimatedRowHeight = 57
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        let rightSwipeRecognizer = UISwipeGestureRecognizer.init(target: self, action: #selector(rightSwipe))
        rightSwipeRecognizer.delegate = self
        rightSwipeRecognizer.direction = UISwipeGestureRecognizerDirection.right
        self.tableViewOutlet.addGestureRecognizer(rightSwipeRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tasksArray = DBWorkerCoreData.shared.selectTasksForTable()
        self.tableViewOutlet.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let tasksArr = tasksArray else {
            return 0
        }
        return tasksArr.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : TaskTableViewCell? = tableView.dequeueReusableCell(withIdentifier: TASK_CELL_REUSABLE_IDENTIFIER, for: indexPath) as? TaskTableViewCell
        
        guard let notNullCell = cell else {
            return UITableViewCell()
        }
        
        if let tasksArr = tasksArray {
            notNullCell.loadData(taskForLoadData: tasksArr[indexPath.row])
        }

        return notNullCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        taskMode = .view
        self.performSegue(withIdentifier: SEGUE_IDENTIFIER_FROM_TASK_TABLE_TO_TASK_DETAIL, sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SEGUE_IDENTIFIER_FROM_TASK_TABLE_TO_TASK_DETAIL {
            let nTaskViewContr : TasksDetailViewController = segue.destination as! TasksDetailViewController
            switch taskMode {
                case .view: if let tasksArr = tasksArray, let indPath = (sender as? IndexPath) {
                    nTaskViewContr.taskToDisplay = tasksArr[indPath.row]
                }
                case .undefined, .new, .edit: nTaskViewContr.taskToDisplay = nil
            }
            nTaskViewContr.taskMode = taskMode
        }
    }
    
    @IBAction func newTaskButtonTouched(_ sender: Any) {
        taskMode = .new
        self.performSegue(withIdentifier: SEGUE_IDENTIFIER_FROM_TASK_TABLE_TO_TASK_DETAIL, sender: sender)
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if var tasksArr = tasksArray {
                if let taskCreatedDate = tasksArr[indexPath.row].createdDate {
                    DBWorkerCoreData.shared.remove(existingTaskCreatedDate: taskCreatedDate)
                }
                tasksArr.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            }
        }
    }
    
    func rightSwipe(gestureRecognizer: UISwipeGestureRecognizer){
        let location = gestureRecognizer.location(in: self.tableViewOutlet)
        let indexPath = self.tableViewOutlet.indexPathForRow(at: location)
        if let indPath = indexPath, let tasksArr = tasksArray {
            tasksArr[indPath.row].status = TaskStatus.completed.rawValue
            DBWorkerCoreData.shared.update(existingTask: tasksArr[indPath.row])
            self.tableViewOutlet.reloadData()
        }
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
