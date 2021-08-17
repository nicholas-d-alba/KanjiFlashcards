//
//  ContainerViewController.swift
//  Kanji Kitsune
//
//  Created by Nicholas Alba on 8/14/21.
//

import UIKit

class ContainerViewController: UIViewController, ChildRemover {

    // MARK: ViewController Lifecycle
    
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
        
//        let start = DispatchTime.now()
//
//        let dataManager = PersistentDataManager(context: context)
//        dataManager.setUpCoreDataIfNeeded()
//
//        print("Data has been set up.")
//
//        // print(dataManager.loadKanji().count)
//        // print(dataManager.loadKanjiResources().count)
//
//        let end = DispatchTime.now()
//        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
//        let timeInterval = Double(nanoTime) / 1_000_000_000
//        print(timeInterval)
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
