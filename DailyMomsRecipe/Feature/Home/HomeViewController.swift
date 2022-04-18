//
//  HomeViewController.swift
//  DailyMomsRecipe
//
//  Created by Achmad Fathullah on 14/04/22.
//

import UIKit


class HomeViewController: UIViewController {

    @IBOutlet weak var customSegmentedView: UIView!
    @IBOutlet weak var headerImgView: UIImageView!
    var buttonBar : UIView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        headerImgView.image = UIImage(named: "dining")
        customSegmentedControl()

        // Do any additional setup after loading the view.
    }
    
    private func customSegmentedControl(){
        let segmentedControl = UISegmentedControl()
        customSegmentedView.backgroundColor = .clear
        customSegmentedView.translatesAutoresizingMaskIntoConstraints = false
        // Add segments
        segmentedControl.insertSegment(withTitle: "One", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "Two", at: 1, animated: true)
        segmentedControl.insertSegment(withTitle: "Three", at: 2, animated: true)
        // First segment is selected by default
        segmentedControl.selectedSegmentIndex = 0
        // This needs to be false since we are using auto layout constraints
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        // This needs to be false since we are using auto layout constraints
        buttonBar.translatesAutoresizingMaskIntoConstraints = false
        buttonBar.backgroundColor = UIColor.blue
        customSegmentedView.addSubview(segmentedControl)
        customSegmentedView.addSubview(buttonBar)
        // Constrain the segmented control width to be equal to the container view width
        segmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        // Constraining the height of the segmented control to an arbitrarily chosen value
        segmentedControl.heightAnchor.constraint(equalToConstant: 40).isActive = true
        if #available(iOS 13.0, *) {
          let image = UIImage()
          let size = CGSize(width: 1, height: segmentedControl.intrinsicContentSize.height)
          UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
          image.draw(in: CGRect(origin: .zero, size: size))
          let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
          UIGraphicsEndImageContext()
          segmentedControl.setBackgroundImage(scaledImage, for: .normal, barMetrics: .default)
          segmentedControl.setDividerImage(scaledImage, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        }
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular)], for: .normal)
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular)], for: .selected)
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        // Constrain the top of the button bar to the bottom of the segmented control
        buttonBar.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor).isActive = true
        buttonBar.heightAnchor.constraint(equalToConstant: 5).isActive = true
        // Constrain the button bar to the left side of the segmented control
        buttonBar.leftAnchor.constraint(equalTo: segmentedControl.leftAnchor).isActive = true
        // Constrain the button bar to the width of the segmented control divided by the number of segments
        buttonBar.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor, multiplier: 0.98 / CGFloat(segmentedControl.numberOfSegments)).isActive = true
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        UIView.animate(withDuration: 0.1) {
            self.buttonBar.frame.origin.x = (sender.frame.width / CGFloat(sender.numberOfSegments)) * CGFloat(sender.selectedSegmentIndex)
          }
    }

}
