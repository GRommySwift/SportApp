//
//  PersistenceResponse.swift
//  SportApp
//
//  Created by Roman on 14/09/2025.
//

import Foundation

public enum PersistenceResponse: Error, Equatable {
    case success
    case failed(String)
}
