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
    
    private let cellReuseId = "episodeCell"
    var episode: Episode?
    var deadChars: [RMCharacter] = []
    var aliveChars: [RMCharacter] = []
    
    var apiService: APIService = {
       return APIServiceClient()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        segmentedControl.addTarget(self, action: #selector(updateTable), for: .valueChanged)
        tableView.dataSource = self
        tableView.delegate = self
        
        guard let episode = self.episode else {
            return
        }
        
        let ids = getCharacterIds(episode: episode)
        self.apiService.fetchCharacters(ids: ids) { (characterList) in
            DispatchQueue.main.async {
                guard let characterList = characterList else { return }
                
                let alive = characterList.filter{ $0.status == "Alive" }
                self.aliveChars.append(contentsOf: alive)
                let dead = characterList.filter{ $0.status == "Dead"}
                self.deadChars.append(contentsOf: dead)
                
                self.tableView.reloadData()
            }
        }
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
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId) 
        
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellReuseId)
        }
        
        let character = self.getCharacter(at: indexPath.row)
        cell?.textLabel?.text = "\(character.name)"
        cell?.detailTextLabel?.text = "\(character.species)"
        
        return cell!
    }
    
    
}

extension CharacterListViewController: UITableViewDelegate {

}
