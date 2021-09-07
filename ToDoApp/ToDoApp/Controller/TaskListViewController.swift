//
//  TaskListViewController.swift
//  ToDoApp
//
//  Created by Oleksandr Kurtsev on 10/07/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import UIKit

class TaskListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var dataProvider: DataProvider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addNewTask(_ sender: UIBarButtonItem) {
        
    }
}

