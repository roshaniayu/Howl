//
//  ViewController.swift
//  Howl
//
//  Created by Roshani Ayu Pranasti on 29/04/21.
//

import AVFoundation
import CoreData
import UIKit

class ViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var timerPicker: UIPickerView!
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var setButton: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var countdownView: UIView!
    @IBOutlet weak var countdownLabel: UILabel!
    
    var rotationAngle: CGFloat!
    var pickerWidth: CGFloat!
    var pickerHeight: CGFloat!
    var timer: Timer!
    var player: AVAudioPlayer!
    var progressLayer: CAShapeLayer!
    var trackLayer: CAShapeLayer!
    var userDefaultsValue = UserDefaults.standard.getValueLoad()
    var initialTime: Time = Time(timeName: "5 mins", timeDuration: 299)
    var times: [Time] = []
    var songs: [Song] = []
    var selectedSong: [Song] = []
    var countdownTime: Int = 299
    var lastTime: Int = 299
    var isPlaying: Bool = false
    var newSongs: [Song] = []
    var newSelectedSong: [Song] = []
    var durationTime: Int = 0
    var songPlayedDate: String = ""
    var songPlayedTime: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        configurePickerView()
        generateTime()
        loadSongsData()
    }
    
    func configurePickerView() {
        rotationAngle = -90 * (.pi/180)
        pickerWidth = 62
        pickerHeight = 80
        timerPicker.transform = CGAffineTransform(rotationAngle: rotationAngle)
        timerPicker.frame = CGRect(x: 64, y: 300, width: 260, height: pickerWidth)
        self.view.addSubview(timerPicker)
        
        timerView.layer.cornerRadius = 22
    }
    
    func generateTime() {
        times.append(initialTime)
        times.append(Time(timeName: "10 mins", timeDuration: 599))
        times.append(Time(timeName: "15 mins", timeDuration: 899))
        times.append(Time(timeName: "30 mins", timeDuration: 1799))
        times.append(Time(timeName: "45 mins", timeDuration: 2699))
        times.append(Time(timeName: "1 hour", timeDuration: 3599))
    }
    
    func getCoreDataContainer() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return appDelegate.persistentContainer.viewContext
    }
    
    func saveItem(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print("Error saving content: \(error)")
        }
    }
    
    func insertItem(audio: String, background: String, character: String, selected: Bool, title: String) {
        let context = getCoreDataContainer()
        let newSong = Song(context: context)
        newSong.audio = audio
        newSong.background = background
        newSong.character = character
        newSong.selected = selected
        newSong.title = title
        
        songs.append(newSong)
        saveItem(context: context)
    }
    
    func adjustBackground() {
        let song = selectedSong[0]
        backgroundImage.image = UIImage(named: song.background!)
        characterImage.image = UIImage(named: song.character!)
        backgroundImage.layer.removeAllAnimations()
        characterImage.layer.removeAllAnimations()
        
        if song.title == "Merry Go Round of Life" {
            backgroundImage.frame = CGRect(x: -1, y: 466, width: 392, height: 528)
            characterImage.frame = CGRect(x: -1, y: 567, width: 392, height: 518)
        } else if song.title == "Path of the Wind" {
            backgroundImage.frame = CGRect(x: -1, y: 370, width: 392, height: 528)
            characterImage.frame = CGRect(x: -1, y: 480, width: 392, height: 518)
        } else if song.title == "The Name of Life" {
            backgroundImage.frame = CGRect(x: -1, y: 410, width: 392, height: 528)
            characterImage.frame = CGRect(x: -1, y: 445, width: 392, height: 518)
        }
        
        playButton.layer.zPosition = 1
        historyButton.layer.zPosition = 1
        setButton.layer.zPosition = 1
    }
    
    func fetchSongs() {
        let context = getCoreDataContainer()
        let fetchRequest: NSFetchRequest<Song> = Song.fetchRequest()
        
        do {
            songs = try context.fetch(fetchRequest)
        } catch {
            print("Error fetching data from context: \(error)")
        }
    }
    
    func loadAmbiance() {
        let context = getCoreDataContainer()
        let fetchRequest: NSFetchRequest<Song> = Song.fetchRequest()
        let filterSong = NSPredicate(format: "selected == %d", true)
        fetchRequest.predicate = filterSong
        
        do {
            selectedSong = try context.fetch(fetchRequest)
            adjustBackground()
        } catch {
            print("Error fetching data from context: \(error)")
        }
    }
    
    func loadSongsData() {
        if userDefaultsValue == nil {
            insertItem(audio: "merry_go_round_of_life", background: "mountain", character: "howl_and_sophie", selected: true, title: "Merry Go Round of Life")
            insertItem(audio: "kaze_no_toori_michi", background: "rain", character: "totoro", selected: false, title: "Path of the Wind")
            insertItem(audio: "inochi_no_namae", background: "clouds", character: "spirited_away", selected: false, title: "The Name of Life")
            
            UserDefaults.standard.setValueLoad(value: true)
        } else {
            fetchSongs()
        }
        
        loadAmbiance()
    }
    
    func formatTimer(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds/60) % 60
        
        return String(format: "-%02d:%02d", minutes, seconds)
    }
    
    func formatDuration(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds/60) % 60
        
        if minutes == 0 {
            return String(format: "%2d secs", seconds)
        }
        
        return String(format: "%2d mins %2d secs", minutes, seconds)
    }
    
    func configureStopInterface() {
        adjustBackground()
        headerLabel.text = "Sleep better"
        descriptionLabel.text = "This soothing relaxing instrumental sound helps you deal with insomnia and fall asleep within minutes."
        descriptionLabel.frame = CGRect(x: 40, y: 223, width: 310, height: 70)
        timerPicker.isHidden = false
        timerView.isHidden = false
        historyButton.isHidden = false
        setButton.isHidden = false
        playButton.setImage(UIImage(named: "icon_play"), for: .normal)
        countdownView.isHidden = true
        countdownTime = lastTime
        trackLayer.removeFromSuperlayer()
        progressLayer.removeFromSuperlayer()
    }
    
    func configurePlayInterface() {
        headerLabel.text = "Have a great sleep"
        descriptionLabel.text = "Once upon a time th..e.... a.. zzzzzzzzz..."
        descriptionLabel.frame = CGRect(x: 97, y: 223, width: 197, height: 48)
        timerPicker.isHidden = true
        timerView.isHidden = true
        historyButton.isHidden = true
        setButton.isHidden = true
        playButton.setImage(UIImage(named: "icon_stop"), for: .normal)
        countdownView.layer.cornerRadius = 19
        countdownView.isHidden = false
        countdownLabel.text = formatTimer(countdownTime)
    }
    
    func animateCircle() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = Double(lastTime) + 80.0
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        progressLayer.add(basicAnimation, forKey: "circleMovement")
    }
    
    func configureCircleTime() {
        // Track layer
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: 195, y: 754), radius: 42, startAngle: -CGFloat.pi/2, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackLayer = CAShapeLayer()
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = HowlColor.grayTrack?.cgColor
        trackLayer.lineWidth = 6
        trackLayer.fillColor = UIColor.clear.cgColor
        self.view.layer.addSublayer(trackLayer)
        
        // Progress layer
        progressLayer = CAShapeLayer()
        progressLayer.path = circularPath.cgPath
        progressLayer.strokeColor = #colorLiteral(red: 0.8138257861, green: 0.8239135146, blue: 0.8020212054, alpha: 1).cgColor
        progressLayer.lineWidth = 6
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = CAShapeLayerLineCap.round
        progressLayer.strokeEnd = 0
        self.view.layer.addSublayer(progressLayer)
    }
    
    func stopSong() {
        if let timer = timer {
            timer.invalidate()
            self.timer = nil
        }
        if let player = player {
            player.stop()
            self.player = nil
        }
        isPlaying = false
    }
    
    func insertHistory() {
        let context = getCoreDataContainer()
        let newHistory = History(context: context)
        newHistory.activity = "Sleep better"
        newHistory.date = songPlayedDate
        newHistory.duration = "\(formatDuration(durationTime))"
        newHistory.time = songPlayedTime
        
        saveItem(context: context)
    }
    
    @objc func updateTimer() {
        countdownLabel.text = formatTimer(countdownTime)
        
        if countdownTime != 0 {
            countdownTime -= 1
        } else {
            stopSong()
            performSegue(withIdentifier: "sessionFinished", sender: self)
            configureStopInterface()
            insertHistory()
        }
    }
    
    func configureTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        lastTime = countdownTime
        configureCircleTime()
        animateCircle()
    }
    
    func configureSong() {
        let song = selectedSong[0]
        let urlString = Bundle.main.path(forResource: song.audio, ofType: "m4a")
        
        do {
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            
            guard let urlString = urlString else { return }
            player = try AVAudioPlayer(contentsOf: URL(string: urlString)!)
            guard let player = player else { return }
            player.delegate = self
            player.play()
        } catch {
            print("Error playing the song: \(error)")
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if countdownTime != 0 && flag == true {
            player.play()
        }
    }
    
    func configureAnimation() {
        let song = selectedSong[0]
        
        if song.title == "Merry Go Round of Life" {
            UIView.animate(withDuration: 12, delay: 0.0, options: [.repeat, .autoreverse], animations: {
                self.backgroundImage.frame.origin.y -= 138
                self.characterImage.frame.origin.y -= 220
            }, completion: nil)
        } else if song.title == "Path of the Wind" {
            UIView.animate(withDuration: 10, delay: 0.0, options: [.repeat, .autoreverse], animations: {
                self.backgroundImage.frame.origin.y -= 180
                self.characterImage.frame.origin.y -= 150
            }, completion: nil)
        } else if song.title == "The Name of Life" {
            UIView.animate(withDuration: 8, delay: 0.0, options: [.repeat, .autoreverse], animations: {
                self.backgroundImage.frame.origin.y -= 80
                self.characterImage.frame.origin.y -= 118
            }, completion: nil)
        }
    }
    
    func formatDate() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"

        return formatter
    }
    
    func formatTime() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"

        return formatter
    }
    
    @IBAction func playSong(_ sender: UIButton) {
        if isPlaying {
            stopSong()
            performSegue(withIdentifier: "sessionFinished", sender: self)
            configureStopInterface()
            insertHistory()
        } else {
            configurePlayInterface()
            configureTimer()
            configureSong()
            configureAnimation()
            isPlaying = true
            let date = Date()
            let dateFormatter = formatDate()
            let timeFormatter = formatTime()
            songPlayedDate = dateFormatter.string(from: date)
            songPlayedTime = timeFormatter.string(from: date)
        }
    }
    
    @IBAction func setAmbiance(_ sender: UIButton) {
        performSegue(withIdentifier: "setAmbiance", sender: self)
    }
    
    @IBAction func sessionHistory(_ sender: UIButton) {
        performSegue(withIdentifier: "sessionHistory", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sessionFinished" {
            guard let destinationVC = segue.destination as? SessionFinishedViewController else {
                return }
            
            if countdownTime != 0 {
                durationTime = initialTime.duration! - countdownTime
                destinationVC.durationTime = "\(formatDuration(durationTime))"
            } else {
                destinationVC.durationTime = "\(initialTime.name!)."
            }
        } else if segue.identifier == "setAmbiance" {
            guard let destinationVC = segue.destination as? AmbianceViewController else {
                return }
            destinationVC.ambiances = songs
            destinationVC.selectedAmbiance = selectedSong
        }  else if segue.identifier == "sessionHistory" {
            print("masuk session history")
//            guard let destinationVC = segue.destination as? HistoryViewController else {
//                return }
        }
    }
    
    func loadChangedAmbiance() {
        let context = getCoreDataContainer()
        let fetchRequest: NSFetchRequest<Song> = Song.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title = %@", selectedSong[0].title!)
        
        do {
            let ambianceToChange = try context.fetch(fetchRequest)
            ambianceToChange[0].setValue(true, forKey: "selected")
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        saveItem(context: context)
        fetchSongs()
        adjustBackground()
    }
    
    @IBAction func performUnwindSegueOperation(_ sender: UIStoryboardSegue) {
        guard let sourceVC = sender.source as? AmbianceViewController else { return }
        sourceVC.ambiances = newSongs
        sourceVC.selectedAmbiance = newSelectedSong
        songs = newSongs
        selectedSong = newSelectedSong
        
        loadChangedAmbiance()
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return times.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return pickerHeight
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerWidth
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: pickerWidth, height: pickerHeight)
        
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: pickerWidth, height: pickerHeight)
        label.textAlignment = .center
        label.font = UIFont(name: "NunitoSans-Regular", size: 17)
        label.textColor = #colorLiteral(red: 0.8138257861, green: 0.8239135146, blue: 0.8020212054, alpha: 1)
        label.text = times[row].name
        view.addSubview(label)
        
        rotationAngle = 90 * (.pi/180)
        view.transform = CGAffineTransform(rotationAngle: rotationAngle)
        
        return view
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        initialTime = times[row]
        countdownTime = initialTime.duration!
    }
}
