//
//  PersistenceResponse.swift
//  SportApp
//
//  Created by Roman on 14/09/2025.
//

import Foundation

public enum PersistenceResponse: Error, Equatable {
    case success(Event)
    case failed(String)
}

public enum DeleteResponse: Equatable {
    case success(UUID)
    case failure(String)
}
