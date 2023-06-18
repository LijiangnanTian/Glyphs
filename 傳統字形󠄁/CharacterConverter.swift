//
//  CharacterConverter.swift
//  傳統字形󠄁
//
//  Created by Tian on 2023-06-18.
//

import Foundation

struct CharacterMapping: Codable {
    let modern: String
    let kyujitai: String
}

struct CharacterConverter {
    static func loadJSON(from url: URL, completion: @escaping ([CharacterMapping]?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Error loading JSON:", error.localizedDescription)
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received.")
                completion(nil)
                return
            }
            
            do {
                //let decoder = JSONDecoder()
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                
                if let dictionary = jsonObject as? [String: String] {
                    let mappings = dictionary.map { CharacterMapping(modern: $0.key, kyujitai: $0.value) }
                    completion(mappings)
                } else {
                    print("Invalid JSON format.")
                    completion(nil)
                }
            } catch {
                print("Error decoding JSON:", error.localizedDescription)
                completion(nil)
            }
        }
        
        task.resume()
    }


    
    static func convertToKyujitai(input: String, mappings: [CharacterMapping]) -> String {
        var convertedText = ""
        
        for character in input {
            let characterString = String(character)
            
            if let mapping = mappings.first(where: { $0.modern == characterString }) {
                convertedText.append(mapping.kyujitai)
            } else {
                convertedText.append(character)
            }
        }
        
        return convertedText
    }
}
