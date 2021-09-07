//
//  ToDoAppTests.swift
//  ToDoAppTests
//
//  Created by Oleksandr Kurtsev on 10/07/2020.
//  Copyright © 2020 Oleksandr Kurtsev. All rights reserved.
//

import XCTest
@testable import ToDoApp

class ToDoAppTests: XCTestCase {

    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    func testInitialViewControllerIsTaskListViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        let rootViewController = navigationController.viewControllers.first
        XCTAssertTrue(rootViewController is TaskListViewController)
    }
}
