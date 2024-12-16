//
//  View+Extensions.swift
//  StreamTrack
//
//  Created by Michael Knych on 12/8/24.
//

import SwiftUI

public extension View {
    
    func onMultilineSubmit(
        for text: Binding<String>,
        submitLabel: SubmitLabel = .done,
        action: @escaping () -> Void
    ) -> some View {
        self.modifier(
            MultilineSubmitViewModifier(
                text: text,
                submitLabel: submitLabel,
                onSubmit: action
            )
        )
    }
}

public extension View {
    
    func multilineSubmit(
        for text: Binding<String>,
        submitLabel: SubmitLabel = .done
    ) -> some View {
        self.modifier(
            MultilineSubmitViewModifier(
                text: text,
                submitLabel: submitLabel,
                onSubmit: {}
            )
        )
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


