//
//  Binding+Externsions.swift
//  StreamTrack
//
//  Created by Michael Knych on 12/5/24.
//

import Foundation
import SwiftUI

extension Binding {
    func bindUnwrap<T>(defaultVal: T) -> Binding<T> where Value == T? {
        Binding<T>(
            get: {
                self.wrappedValue ?? defaultVal
            }, set: {
                self.wrappedValue = $0
            }
        )
    }
}
