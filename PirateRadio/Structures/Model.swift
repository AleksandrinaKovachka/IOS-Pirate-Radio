//
//  Model.swift
//  PirateRadio
//
//  Created by A-Team Intern on 28.06.21.
//

import Foundation

class Model {
    func getVideos() {
        let url = URL(string: Constants.URL)
        
        guard url != nil else {
            return
        }
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url!) {
            (data, response, error) in
            
            if error != nil || data != nil {
                return
            }
        }
    }
}
