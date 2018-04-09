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
    var taskMode: TaskWorkMode = .undefined
    
    override func viewDidLoad() {
        super.viewDidLoad()

        switch self.taskMode {
            case .new: self.saveButton.isEnabled = true
                self.editButton.isEnabled = false
                self.modifiedDateLabel.isHidden = true
                self.statusLabel.isHidden = true
                self.setBorderFor(textView: self.titleTextView, color: UIColor.gray)
                self.setBorderFor(textView: self.descriptionTextView, color:UIColor.gray)
            case .view: if let taskToDispl = self.taskToDisplay {
                if let taskToDisplModDate = taskToDispl.modifiedDate {
                    self.modifiedDateLabel.text = taskToDisplModDate
                }
                if let taskToDisplStatus = taskToDispl.status {
                    switch taskToDisplStatus {
                        case TaskStatus.active.rawValue: self.statusLabel.text = TaskStatusStr.active
                        case TaskStatus.completed.rawValue: self.statusLabel.text = TaskStatusStr.completed
                            self.editButton.isEnabled = false
                        default: break
                    }
                }
                if let taskToDisplTitle = taskToDispl.title {
                    self.titleTextView.text = taskToDisplTitle
                }
                if let taskToDisplDescrText = taskToDispl.descriptionText {
                    self.descriptionTextView.text = taskToDisplDescrText
                }
                    }
                self.titleTextView.isEditable = false
                self.descriptionTextView.isEditable = false
            case .undefined, .edit: break
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
            return
        }
        switch self.taskMode {
            case .new: let newTask = Task()
                newTask.title = self.titleTextView.text
                newTask.descriptionText = self.descriptionTextView.text
                newTask.createdDate = Date().getformatString(fromDate: Date(), formatPlace: DateFormatPlace.taskDetail)
                newTask.modifiedDate = newTask.createdDate
                newTask.status = TaskStatus.active.rawValue
                DBWorkerCoreData.shared.add(newTask: newTask)
        case .edit: guard let taskToDispl = self.taskToDisplay else{
                    break
                }
                taskToDispl.title = self.titleTextView.text
                taskToDispl.descriptionText = self.descriptionTextView.text
                taskToDispl.modifiedDate = Date().getformatString(fromDate: Date(), formatPlace: DateFormatPlace.taskDetail)
                DBWorkerCoreData.shared.update(existingTask: taskToDispl)
            case .undefined, .view: break
        }
        if let selfNavigationContr = self.navigationController {
            selfNavigationContr.popToRootViewController(animated: true)
        }
    }

    @IBAction func editButtonTouched(_ sender: Any) {
        self.taskMode = .edit
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
