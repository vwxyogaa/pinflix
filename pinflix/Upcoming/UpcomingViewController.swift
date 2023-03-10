//
//  UpcomingViewController.swift
//  pinflix
//
//  Created by Panji Yoga on 10/03/23.
//

import UIKit

class UpcomingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Upcoming"
    }
}
