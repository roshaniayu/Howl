//
//  AmbianceViewController.swift
//  Howl
//
//  Created by Roshani Ayu Pranasti on 03/05/21.
//

import UIKit

class AmbianceViewController: UIViewController {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var characterImage: UIImageView!
    
    var ambiances: [Song] = []
    var selectedAmbiance: [Song] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("test")
        
        adjustBackground()
    }
    
    func adjustBackground() {
        let ambiance = selectedAmbiance[0]
        backgroundImage.image = UIImage(named: ambiance.background!)
        characterImage.image = UIImage(named: ambiance.character!)
        
        if ambiance.title == "Merry Go Round of Life" {
            backgroundImage.frame = CGRect(x: -1, y: 589, width: 392, height: 528)
            characterImage.frame = CGRect(x: -1, y: 617, width: 392, height: 518)
        } else if ambiance.title == "Path of the Wind" {
            backgroundImage.frame = CGRect(x: -1, y: 470, width: 392, height: 528)
            characterImage.frame = CGRect(x: -1, y: 570, width: 392, height: 518)
        } else if ambiance.title == "The Name of Life" {
            backgroundImage.frame = CGRect(x: -1, y: 530, width: 392, height: 528)
            characterImage.frame = CGRect(x: -1, y: 565, width: 392, height: 518)
        }
    }

    @IBAction func closeSetAmbiance(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? ViewController else { return }
        destinationVC.newSongs = ambiances
        destinationVC.newSelectedSong = selectedAmbiance
    }
}

extension AmbianceViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ambiances.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ambianceCell", for: indexPath) as! AmbianceTableViewCell
        let ambiance = ambiances[indexPath.row]
        cell.titleLabel.text = ambiance.title
        tableView.separatorColor = UIColor(red: 0.68, green: 0.69, blue: 0.65, alpha: 1.0)
        tableView.tableFooterView = UIView()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let ambiance = ambiances[indexPath.row]
        if selectedAmbiance[0].title == ambiance.title {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for i in 0 ... ambiances.count-1 {
            if i == indexPath.row {
                ambiances[indexPath.row].selected = true
            } else {
                ambiances[i].selected = false
            }
        }
        
        let ambiance = ambiances[indexPath.row]
        selectedAmbiance[0] = ambiance
        
        adjustBackground()
    }
}
