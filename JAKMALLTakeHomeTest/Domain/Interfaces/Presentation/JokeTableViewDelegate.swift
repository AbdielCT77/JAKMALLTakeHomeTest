//
//  JokeTableViewDelegate.swift
//  JAKMALLTakeHomeTest
//
//  Created by Abdiel CT MNC on 03/03/23.
//

import Foundation

protocol JokeTableViewDelegate {
    func arrowClicked(category: String)
    func goTopClicked(index: Int)
}
