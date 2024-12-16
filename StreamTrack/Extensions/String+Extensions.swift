//
//  String+Extensions.swift
//  StreamTrack
//
//  Created by Michael Knych on 12/4/24.
//

import Foundation

extension String {
    
    var isEmptyOrWhitespace: Bool {
        self.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
}


