//
//  ContainerViewController.swift
//  Kanji Kitsune
//
//  Created by Nicholas Alba on 8/14/21.
//

import UIKit

class ContainerViewController: UIViewController, ChildRemover {

    // MARK: ViewController Lifecycle
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !UserDefaults.standard.bool(forKey: "Saved") {
            let installationViewController = InstallationViewController()
            installationViewController.delegate = self
            childViewController = installationViewController
        } else {
            childViewController = HomeViewController()
        }
        setUpChildViewController()
    }

    // MARK: UI Set-Up
    
    private func setUpChildViewController() {
        guard let childView = childViewController.view else {return}
        childView.translatesAutoresizingMaskIntoConstraints = false
        addChild(childViewController)
        view.addSubview(childView)
        childViewController.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            childView.topAnchor.constraint(equalTo: view.topAnchor),
            childView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            childView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            childView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func replaceViewControllers() {
        childViewController.willMove(toParent: nil)
        childViewController.view.removeFromSuperview()
        childViewController.removeFromParent()
        
        childViewController = HomeViewController()
        setUpChildViewController()
    }
    
    func removeChild() {
        replaceViewControllers()
    }
    
    // MARK: Properties
    
    private var childViewController = UIViewController()
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
}

protocol ChildRemover {
    func removeChild()
}
