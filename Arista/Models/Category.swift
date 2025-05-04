//
//  Category.swift
//  Arista
//
//  Created by Thibault Giraudon on 04/05/2025.
//

import Foundation

enum Category: String, CaseIterable, Identifiable {
    case running = "Course à pied"
    case cycling = "Vélo"
    case swimming = "Natation"
    case walking = "Marche"
    case fitness = "Fitness"
    case yoga = "Yoga"
    case strengthTraining = "Musculation"
    case hiking = "Randonnée"
    case boxing = "Boxe"
    case pilates = "Pilates"
    case crossfit = "CrossFit"
    case tennis = "Tennis"
    case badminon = "Badminton"
    case climbing = "Escalade"
    case skiing = "Ski"
    case dance = "Danse"
    case jumprope = "Corde a sauter"

    var id: String { rawValue }
    
    var icon: String {
        switch self {
            case .running: return "figure.run"
            case .cycling: return "bicycle"
            case .swimming: return "figure.pool.swim"
            case .walking: return "figure.walk"
            case .fitness: return "dumbbell"
            case .yoga: return "figure.cooldown"
            case .strengthTraining: return "figure.strengthtraining.traditional"
            case .hiking: return "figure.hiking"
            case .boxing: return "figure.boxing"
            case .pilates: return "figure.flexibility"
            case .crossfit: return "flame"
            case .tennis: return "tennis.racket"
            case .badminon: return "figure.badminton"
            case .climbing: return "figure.climbing"
            case .skiing: return "figure.skiing.downhill"
            case .dance: return "figure.dance"
            case .jumprope: return "figure.jumprope"
        }
    }
}
