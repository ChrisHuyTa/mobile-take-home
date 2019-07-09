//
//  EpisodeViewController.swift
//  GuestlogixTest
//
//  Created by Chris Ta on 2019-07-08.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit

class CharacterListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    private let cellReuseId = "characterList"
    var episode: Episode?
    var deadChars: [RMCharacter] = []
    var aliveChars: [RMCharacter] = []
    
    var apiService: APIService = {
       return APIServiceClient()
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SZ"
        return formatter
    }()
    
    private lazy var niceDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = episode!.name
            
        segmentedControl.addTarget(self, action: #selector(updateTable), for: .valueChanged)
        
        tableView.register(UINib(nibName: "CharacterListTableCell", bundle: nil), forCellReuseIdentifier: cellReuseId)

        tableView.dataSource = self
        tableView.delegate = self
        
        guard let episode = self.episode else {
            return
        }
        
        let ids = getCharacterIds(episode: episode)
        self.apiService.fetchCharacters(ids: ids) { (characterList, httpError) in
            
            if httpError != nil {
                return
            }
            
            DispatchQueue.main.async {
                guard let characterList = characterList else { return }
                
                let alive = characterList.filter{ $0.status == "Alive" }
                self.aliveChars.append(contentsOf: alive)
                self.aliveChars.sort(by: { (v1, v2) -> Bool in
                    return self.compare(target1: v1, with: v2)
                })
                
                let dead = characterList.filter{ $0.status == "Dead"}
                self.deadChars.append(contentsOf: dead)
                self.deadChars.sort(by: { (v1, v2) -> Bool in
                    return self.compare(target1: v1, with: v2)
                })
                
                self.tableView.reloadData()
            }
        }
    }
    
    func compare(target1: RMCharacter,with target2: RMCharacter) -> Bool {

        let date1 = self.dateFormatter.date(from: target1.created)
        let date2 = self.dateFormatter.date(from: target2.created)
        

        return (date1?.compare(date2!)) == ComparisonResult.orderedAscending
    }
    
    private func getCharacterIds(episode: Episode) -> [String] {
        
        var result = [String]()
        
        for characterUrl in episode.characters {
            let comp = characterUrl.components(separatedBy: "/")
            let id = comp.last!
            if Int(id) != nil {
                result.append(id)
            }
        }
        return result
    }

    private func getCharacter(at index: Int) -> RMCharacter {
        return self.segmentedControl.selectedSegmentIndex == 0 ? aliveChars[index] : deadChars[index]
    }
    
    @objc func updateTable() {
        self.tableView.reloadData()
    }
}

extension CharacterListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            return aliveChars.count
        } else {
            return deadChars.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath) as! CharacterListTableCell
        
        let character = self.getCharacter(at: indexPath.row)
        cell.characterImage.loadImage(from: URL(string: character.image)!)
        cell.nameLabel.text = character.name
        let niceDate = niceDateFormatter.string(from: self.dateFormatter.date(from: character.created)!)
        cell.createdLabel.text = "Created on: \(niceDate)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension CharacterListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell = tableView.cellForRow(at: indexPath)
        selectedCell?.isSelected = false
        
        let selectedCharacter = segmentedControl.selectedSegmentIndex == 0 ? aliveChars[indexPath.row] : deadChars[indexPath.row]
        
        let profileVC = ProfileViewController()
        profileVC.character = selectedCharacter
        profileVC.delegate = self
        
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
}

extension CharacterListViewController: ProfileViewDelegate {
    
    func didKillCharacter(target: RMCharacter) {
        
        let index = self.aliveChars.firstIndex { $0.id == target.id }
        self.deadChars.append(self.aliveChars.remove(at: index!))
        self.deadChars.sort { (v1, v2) -> Bool in
            return self.compare(target1: v1, with: v2)
        }
        self.tableView.reloadData()
    }
}
