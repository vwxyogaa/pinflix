//
//  TabBarViewController.swift
//  pinflix
//
//  Created by Panji Yoga on 10/03/23.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func makeTabBar() -> TabBarViewController {
        self.viewControllers = [
            makeNavigation(viewController: createDashboardTab()),
            makeNavigation(viewController: createUpcomingTab()),
            makeNavigation(viewController: createMyMovieTab())
        ]
        return self
    }
    
    private func makeNavigation(viewController: UIViewController) -> UINavigationController {
        let navigation = UINavigationController(rootViewController: viewController)
        navigation.delegate = self
        navigation.navigationBar.prefersLargeTitles = false
        return navigation
    }
    
    private func createDashboardTab() -> UIViewController {
        let dashboardController = DashboardViewController(nibName: "DashboardViewController", bundle: nil)
        dashboardController.tabBarItem.title = "Dashboard"
        dashboardController.tabBarItem.image = UIImage(systemName: "house")
        dashboardController.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        let dashboardViewModel = DashboardViewModel(dashboardUseCase: Injection().provideDashboardUseCase())
        dashboardController.viewModel = dashboardViewModel
        return dashboardController
    }
    
    private func createUpcomingTab() -> UIViewController {
        let upcomingController = UpcomingViewController(nibName: "UpcomingViewController", bundle: nil)
        upcomingController.tabBarItem.title = "Upcoming"
        upcomingController.tabBarItem.image = UIImage(systemName: "play.rectangle.on.rectangle")
        upcomingController.tabBarItem.selectedImage = UIImage(systemName: "play.rectangle.on.rectangle.fill")
        let upcomingViewModel = UpcomingViewModel(upcomingUseCase: Injection().provideUpcomingUseCase(), detailUseCase: Injection().provideDetailUseCase())
        upcomingController.viewModel = upcomingViewModel
        return upcomingController
    }
    
    private func createMyMovieTab() -> UIViewController {
        let myMovieController = MyMovieViewController(nibName: "MyMovieViewController", bundle: nil)
        myMovieController.tabBarItem.title = "MyMovie"
        myMovieController.tabBarItem.image = UIImage(systemName: "bookmark")
        myMovieController.tabBarItem.selectedImage = UIImage(systemName: "bookmark.fill")
        let myMovieViewModel = MyMovieViewModel(myMovieUseCase: Injection().provideMyMovieUseCase())
        myMovieController.viewModel = myMovieViewModel
        return myMovieController
    }
}

// MARK: - UINavigationControllerDelegate
extension UIViewController: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if #available(iOS 14.0, *) {
            viewController.navigationItem.backButtonDisplayMode = .minimal
        } else {
            // Fallback on earlier versions
            viewController.navigationItem.backButtonTitle = ""
        }
        viewController.navigationController?.navigationBar.tintColor = .white
    }
}
