//
//  SessionFinishedViewController.swift
//  Howl
//
//  Created by Roshani Ayu Pranasti on 03/05/21.
//

import UIKit

class SessionFinishedViewController: UIViewController {

    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    var durationTime: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        durationLabel.text = durationTime
        doneButton.layer.cornerRadius = 6
    }
    
    @IBAction func closeSessionFinished(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickDoneButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
