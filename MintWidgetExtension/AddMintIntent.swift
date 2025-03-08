//
//  AddMintIntent.swift
//  MintTrackerDemo
//
//  Created by Suraj Barthy on 3/5/25.
//

import AppIntents

struct AddMintIntent: AppIntent {
    static var title: LocalizedStringResource = "Add Mint"
    static var description = IntentDescription("Increment the mint counter in the widget.")

    // You could define parameters here if you like (e.g., how many mints to add).
    // We'll keep it simple and always add 1.

    func perform() async throws -> some IntentResult {
        // Read the current mint count from UserDefaults
        let current = UserDefaults.standard.integer(forKey: "mintCount")
        // Increment by 1
        let newTotal = current + 1
        // Save it back to UserDefaults
        UserDefaults.standard.set(newTotal, forKey: "mintCount")

        // Return success
        return .result()
    }
}
