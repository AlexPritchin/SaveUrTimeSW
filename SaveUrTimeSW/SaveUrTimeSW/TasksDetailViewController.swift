//
//  TasksDetailViewController.swift
//  SaveUrTimeSW
//
//  Created by Alex Pritchin on 27/03/18.
//  Copyright © 2018 Alex Pritchin. All rights reserved.
//

import UIKit

class TasksDetailViewController: UIViewController {

    @IBOutlet weak var modifiedDateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var titleTextView: PlaceholderTextView!
    @IBOutlet weak var descriptionTextView: PlaceholderTextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    var taskToDisplay: Task?
    var taskMode: Int?
    var dbWork: DBWorkerCoreData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.taskMode == TaskWorkMode.TASK_WORK_MODE_NEW.rawValue {
            self.saveButton.isEnabled = true
            self.editButton.isEnabled = false
            self.modifiedDateLabel.isHidden = true
            self.statusLabel.isHidden = true
            self.setBorderFor(textView: self.titleTextView, color: UIColor.gray)
            self.setBorderFor(textView: self.descriptionTextView, color:UIColor.gray)
        }
        else if self.taskMode == TaskWorkMode.TASK_WORK_MODE_VIEW.rawValue {
            self.modifiedDateLabel.text = self.taskToDisplay!.modifiedDate
            switch self.taskToDisplay!.status! {
                case TaskStatus.TASK_STATUS_ACTIVE.rawValue: self.statusLabel.text = TASK_STATUS_ACTIVE_STR
                case TaskStatus.TASK_STATUS_COMPLETED.rawValue: self.statusLabel.text = TASK_STATUS_COMPLETED_STR
                    self.editButton.isEnabled = false
                default: break
            }
            self.titleTextView.text = self.taskToDisplay!.title
            self.descriptionTextView.text = self.taskToDisplay!.descriptionText
            self.titleTextView.isEditable = false;
            self.descriptionTextView.isEditable = false;
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButtonTouched(_ sender: Any) {
        self.setBorderFor(textView: self.titleTextView, color: UIColor.gray)
        self.setBorderFor(textView: self.descriptionTextView, color:UIColor.gray)
        if (self.titleTextView.text == "") || (self.descriptionTextView.text == ""){
            if self.titleTextView.text == "" {
                self.setBorderFor(textView: self.titleTextView, color: UIColor.red)
            }
            if self.descriptionTextView.text == "" {
                self.setBorderFor(textView: self.descriptionTextView, color:UIColor.red)
            }
            return;
        }
        if self.taskMode == TaskWorkMode.TASK_WORK_MODE_NEW.rawValue {
            let newTask = Task()
            newTask.title = self.titleTextView.text
            newTask.descriptionText = self.descriptionTextView.text
            let dtFormat = DateFormatter()
            dtFormat.dateFormat = TASK_DATETIME_FORMAT
            newTask.createdDate = dtFormat.string(from: Date())
            newTask.modifiedDate = newTask.createdDate
            newTask.status = TaskStatus.TASK_STATUS_ACTIVE.rawValue
            self.dbWork!.add(newTask: newTask)
        }
        else if self.taskMode == TaskWorkMode.TASK_WORK_MODE_EDIT.rawValue {
            self.taskToDisplay!.title = self.titleTextView.text;
            self.taskToDisplay!.descriptionText = self.descriptionTextView.text;
            let dtFormat = DateFormatter()
            dtFormat.dateFormat = TASK_DATETIME_FORMAT
            self.taskToDisplay!.modifiedDate = dtFormat.string(from: Date())
            self.dbWork!.update(existingTask: self.taskToDisplay!)
        }
        self.navigationController!.popToRootViewController(animated: true)
    }

    @IBAction func editButtonTouched(_ sender: Any) {
        self.taskMode = TaskWorkMode.TASK_WORK_MODE_EDIT.rawValue
        self.editButton.isEnabled = false
        self.saveButton.isEnabled = true
        self.titleTextView.isEditable = true
        self.descriptionTextView.isEditable = true
        self.setBorderFor(textView: self.titleTextView, color: UIColor.gray)
        self.setBorderFor(textView: self.descriptionTextView, color:UIColor.gray)
    }
    
    func setBorderFor(textView: UITextView, color: UIColor){
        textView.layer.borderColor = color.cgColor
        textView.layer.borderWidth = 1.0
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
