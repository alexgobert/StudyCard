//
//  StudyViewController.swift
//  StudyCard
//
//  Created by Sam Song on 10/19/22.
//


import UIKit

class StudyViewController: UIViewController {
    
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Right swipe Gesture
    @IBAction func rightGesture(_ sender: UISwipeGestureRecognizer) {
        print("Right")
    }
    
    // Left swipe Gesture
    @IBAction func leftGesture(_ sender: UISwipeGestureRecognizer) {
        print("Left")
    }
    
    
    
}
