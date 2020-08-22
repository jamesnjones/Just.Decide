//
//  PersistenceManager.swift
//  Just Decide
//
//  Created by James Jones on 20/07/2020.
//  Copyright © 2020 James Jones. All rights reserved.
//

import Foundation


enum PersistenceActionType {
    case add, remove
}

enum PersistenceManager {
    
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let slices = "Saved Slices"
    }
    
    static func updateWith(slice: CarnivalWheel, actionType: PersistenceActionType, completed: @escaping (Error?) -> Void) {
    
        retrieveSlices { result in
            switch result {
                
            case .success(let slices):
                var obtainedSlice = slices
                switch actionType {
                case .add:
                    guard !obtainedSlice.contains(slice) else {
                        print("already saved")
                        return
                    }
                    obtainedSlice.append(slice)
                case .remove:
                    obtainedSlice.removeAll {$0.title == slice.title}
                }
                
                completed(save(slices: obtainedSlice))
                
            case .failure(_):
                print("Did not update")
            }
        }
    
    
    
    }



    static func retrieveSlices(completed: @escaping (Result<[CarnivalWheel], Error>) -> Void) {
        guard let favouritesData = defaults.object(forKey: Keys.slices) as? Data else {
            completed(.success([]))
            return
        }
        
        do {
                       let decoder = JSONDecoder()
                       let slices = try decoder.decode([CarnivalWheel].self , from: favouritesData)
                       completed(.success(slices))
                       
                   } catch {
                    print(error)
                   }
    }
    

    static func save(slices: [CarnivalWheel]) -> Error? {
           do {
               let encoder = JSONEncoder()
               let encodedFavourites = try encoder.encode(slices)
               
            defaults.set(encodedFavourites, forKey: Keys.slices)
               return nil
               
           } catch {
            return print(error) as? Error
           }
           return nil
       }

}
