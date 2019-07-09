//
//  ProfileViewController.swift
//  GuestlogixTest
//
//  Created by Chris Ta on 2019-07-08.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit

protocol ProfileViewDelegate: class {
    func didKillCharacter(target: RMCharacter)
}

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var killBtn: UIButton!
    
    var character: RMCharacter!
    weak var delegate: ProfileViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = character.name
        profileImageView.loadImage(from: URL(string: character.image)!)

        populateLabels()
        setupBtn()
    }

    func populateLabels() {
        statusLabel.text = "Status: \(character.status)"
        speciesLabel.text = "Species: \(character.species)"
        typeLabel.text = "Type: \(character.type)"
        genderLabel.text = "Gender: \(character.gender)"
    }

    func setupBtn() {
        
        if character.status == "Dead" {
            killBtn.isHidden = true
            return
        }
        
        killBtn.layer.borderWidth = 1
        killBtn.layer.cornerRadius = 10
        killBtn.layer.borderColor = UIColor(displayP3Red: 0, green: 122/255, blue: 255/255, alpha: 1).cgColor
        killBtn.addTarget(self, action: #selector(killTapped), for: .touchUpInside)
        
    }
    
    @objc func killTapped() {
        self.delegate?.didKillCharacter(target: self.character)
        self.navigationController?.popViewController(animated: true)
    }
}
