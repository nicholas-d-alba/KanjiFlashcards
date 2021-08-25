//
//  InstallationViewController.swift
//  Kanji Kitsune
//
//  Created by Nicholas Alba on 8/14/21.
//

import CoreData
import UIKit

class InstallationViewController: UIViewController {

    // MARK: ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpNotificationObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func setUpNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(enterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc private func enterForeground() {
        animatePulsatingLayer()
    }
    
    // MARK: UI Set-Up
    
    private func setUpUI() {
        view.backgroundColor = backgroundColor
        
        pulsatingLayer = circularPathShapeLayer(withStrokeColor: .clear, fillColor: contentBackgroundColor)
        view.layer.addSublayer(pulsatingLayer)
        
        trackLayer = circularPathShapeLayer(withStrokeColor: .gray, fillColor: .clear)
        view.layer.addSublayer(trackLayer)
        
        progressLayer = circularPathShapeLayer(withStrokeColor: textColor, fillColor: backgroundColor)
        progressLayer.strokeEnd = 0
        view.layer.addSublayer(progressLayer)
        
        view.addSubview(percentageLabel)
        percentageLabel.textColor = textColor
        NSLayoutConstraint.activate([
            percentageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            percentageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        view.addSubview(installationLabel)
        NSLayoutConstraint.activate([
            installationLabel.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 150),
            installationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            installationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
        installationLabel.textColor = textColor
        
        view.addSubview(installationButton)
        NSLayoutConstraint.activate([
            installationButton.topAnchor.constraint(equalTo: installationLabel.bottomAnchor, constant: 16),
            installationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        installationButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 5, right: 10)
        setAppearance(forButton: installationButton)
        installationButton.addTarget(self, action: #selector(installationButtonPressed), for: .touchUpInside)
    }
    
    private func circularPathShapeLayer(withStrokeColor strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer {
        let circularShapeLayer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: -(CGFloat.pi / 2), endAngle: 3 * (CGFloat.pi / 2), clockwise: true)
        circularShapeLayer.path = circularPath.cgPath
        circularShapeLayer.strokeColor = strokeColor.cgColor
        circularShapeLayer.fillColor = fillColor.cgColor
        circularShapeLayer.lineWidth = 20
        circularShapeLayer.position = view.center
        return circularShapeLayer
    }
    
    private func setColors(forLabel label: UILabel) {
        label.textColor = textColor
    }
    
    private func setAppearance(forButton button: UIButton) {
        if let label = button.titleLabel {
            label.textColor = textColor
            button.layer.cornerRadius = label.frame.height / 2
        }
        button.backgroundColor = contentBackgroundColor
        button.layer.borderColor = borderColor.cgColor
    }
    
    private func animatePulsatingLayer() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.3
        animation.duration = 1
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        pulsatingLayer.add(animation, forKey: "pulsing")
    }
    
    // MARK: Interactivity
    
    @objc private func installationButtonPressed() {
        DispatchQueue.main.async {
            self.installationButton.removeFromSuperview()
            self.installationLabel.text = "Installing kanji data..."
            self.installationLabel.textAlignment = .center
            self.animatePulsatingLayer()
        }
        beginInstallation()
    }
    
    @objc private func removalButtonPressed() {
        if let delegate = delegate {
            delegate.removeChild()
        }
    }
    
    private func beginInstallation() {
        guard !UserDefaults.standard.bool(forKey: "Saved") else {return}
        
        let child = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        child.parent = context

        child.perform {
            let dataManager = PersistentDataManager(context: self.context)
            dataManager.setUpKanjiIfNeeded()
            print("Kanji have been set up.")
            guard let kanjiResources = dataManager.deserializeKanjiResourcesFromJSON() else {return}
            for (i, resourceCodable) in kanjiResources.enumerated() {
                _ = KanjiResources.instantiate(from: resourceCodable, withContext: child)
                DispatchQueue.main.async {
                    let progressIndicator = ProgressIndicator(tasksCompleted: i+1, totalTasks: kanjiResources.count)
                    self.percentageLabel.text = "\(progressIndicator.completionPercentage)%"
                    self.progressLayer.strokeEnd = CGFloat(progressIndicator.tasksCompleted) / CGFloat(progressIndicator.totalTasks)
                }
                
                do {
                    try child.save()
                    child.reset()
                    self.context.performAndWait {
                        do {
                            try self.context.save()
                            self.context.reset()
                        } catch {
                            fatalError("Failure to save context: \(error)")
                        }
                    }
                    
                } catch{
                    fatalError("Failure to save context: \(error)")
                }
            }
            
            self.installationComplete()
         }
    }
    
    private func installationComplete() {
        print("Kanji Resources have been set up.")
        UserDefaults.standard.set(true, forKey: "Saved")
        DispatchQueue.main.async {
            self.pulsatingLayer.removeAllAnimations()
            self.installationLabel.text = "Installation complete."
            
            self.view.addSubview(self.removalButton)
            NSLayoutConstraint.activate([
                self.removalButton.topAnchor.constraint(equalTo: self.installationLabel.bottomAnchor, constant: 16),
                self.removalButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            ])
            self.removalButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            self.setAppearance(forButton: self.removalButton)
            self.removalButton.addTarget(self, action: #selector(self.removalButtonPressed), for: .touchUpInside)
        }
    }
    
    // MARK: Properties
    
    private let installationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        label.lineBreakMode = .byWordWrapping
        label.text = installationAdvisory
        label.numberOfLines = 0
        return label
    }()
    
    private let installationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let attributedTitle = NSAttributedString(string: "Begin Installation", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .bold)])
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.layer.borderWidth = 2.0
        return button
    }()
    
    private let removalButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let attributedTitle = NSAttributedString(string: "Start Kanji Kitsune", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .bold)])
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.layer.borderWidth = 2.0
        return button
    }()
    
    private let percentageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.text = "0%"
        return label
    }()
    
    var delegate: ChildRemover? = nil
    
    private var progressLayer = CAShapeLayer()
    private var trackLayer = CAShapeLayer()
    private var pulsatingLayer = CAShapeLayer()
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
}

private let installationAdvisory = "Kanji Kitsune needs to install 16 MB of data into the device's storage in order to work. This process only needs to be completed once."
