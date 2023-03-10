//
//  DashboardViewController.swift
//  pinflix
//
//  Created by Panji Yoga on 10/03/23.
//

import UIKit

class DashboardViewController: UIViewController {
    @IBOutlet weak var searchMovieTextField: UITextField!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Helpers
    private func configureViews() {
        configureSearchTextField()
    }
    
    private func configureSearchTextField() {
        guard let grayTabBarColor = UIColor(named: "GrayTabBarColor") else { return }
        searchMovieTextField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [NSAttributedString.Key.foregroundColor: grayTabBarColor]
        )
    }
}
