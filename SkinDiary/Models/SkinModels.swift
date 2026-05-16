//
//  SkinModels.swift
//  AI 피부 일기
//
//  데이터 모델 및 샘플(Mock) 데이터
//

import Foundation
import SwiftUI

// MARK: - 피부 일기 엔트리

struct SkinEntry: Identifiable, Equatable {
    let id: Int
    let date: Date
    let imageName: String      // 에셋 이름 또는 원격 URL 문자열
    let redness: Int           // 0~100 (%)
    let blemishes: Int         // 트러블 개수
    let texture: Int           // 0~100 (점)
    let hydration: Int         // 0~100 (%)
}

// MARK: - 분석 추이 데이터

struct TrendPoint: Identifiable {
    let id = UUID()
    let dateLabel: String
    let redness: Double
    let blemishes: Double
    let texture: Double
    let hydration: Double
}

// MARK: - 유사 사례

struct CaseImprovement {
    var redness: Int? = nil
    var blemishes: Int? = nil
    var texture: Int? = nil
    var hydration: Int? = nil
    var oilControl: Int? = nil
    var pores: Int? = nil
}

struct SimilarCase: Identifiable {
    let id: Int
    let profile: String        // "26세 여성, 복합성 피부"
    let concern: String        // 주요 고민
    let similarity: Int        // 0~100%
    let beforeImage: String
    let afterImage: String
    let duration: String       // "6주"
    let improvements: CaseImprovement
    let routine: [String]
    let treatments: [String]
    let products: [String]
}

// MARK: - 추천 화장품

struct RecommendedProduct: Identifiable {
    let id = UUID()
    let name: String
    let category: String
    let reason: String
    let rating: Double
}

// MARK: - 추천 시술

struct RecommendedTreatment: Identifiable {
    let id = UUID()
    let name: String
    let type: String
    let frequency: String
    let benefit: String
}

// MARK: - 샘플 데이터

enum MockData {

    static let entries: [SkinEntry] = [
        SkinEntry(id: 1, date: makeDate(2026, 4, 18), imageName: "st5",
                  redness: 45, blemishes: 8,  texture: 72, hydration: 65),
        SkinEntry(id: 2, date: makeDate(2026, 4, 25), imageName: "st4",
                  redness: 52, blemishes: 10, texture: 68, hydration: 62),
        SkinEntry(id: 3, date: makeDate(2026, 5, 2), imageName: "st6",
                  redness: 58, blemishes: 12, texture: 65, hydration: 60),
        SkinEntry(id: 4, date: makeDate(2026, 5, 9),  imageName: "st2",
                  redness: 61, blemishes: 13, texture: 63, hydration: 58),
        SkinEntry(id: 5, date: makeDate(2026, 5, 16),  imageName: "st1",
                  redness: 65, blemishes: 15, texture: 60, hydration: 55)
    ]

    static let trend: [TrendPoint] = [
        .init(dateLabel: "4/18",  redness: 65, blemishes: 15, texture: 60, hydration: 55),
        .init(dateLabel: "4/25",  redness: 61, blemishes: 13, texture: 63, hydration: 58),
        .init(dateLabel: "5/2", redness: 58, blemishes: 12, texture: 65, hydration: 60),
        .init(dateLabel: "5/9", redness: 52, blemishes: 10, texture: 68, hydration: 62),
        .init(dateLabel: "5/16", redness: 45, blemishes: 8,  texture: 72, hydration: 65)
    ]

    static let similarCases: [SimilarCase] = [
        SimilarCase(
            id: 1,
            profile: "26세 여성, 복합성 피부",
            concern: "붉은기 & 트러블",
            similarity: 94,
            beforeImage: "winter1",
            afterImage: "winter2",
            duration: "6주",
            improvements: CaseImprovement(redness: -45, blemishes: -60),
            routine: ["센텔라 에센스 (아침/저녁)", "약산성 클렌저", "저자극 수분 크림"],
            treatments: ["LED 광치료 (주 2회)", "진정 관리"],
            products: ["토리든 다이브인 수딩 크림", "닥터자르트 시카페어 세럼"]
        ),
        SimilarCase(
            id: 2,
            profile: "23세 여성, 민감성 피부",
            concern: "수분 부족 & 피부결",
            similarity: 88,
            beforeImage: "rei1",
            afterImage: "rei2",
            duration: "4주",
            improvements: CaseImprovement(texture: 28, hydration: 35),
            routine: ["히알루론산 토너", "세라마이드 앰플", "수분 크림 (두껍게)"],
            treatments: ["수분 앰플 관리 (주 1회)"],
            products: ["라로슈포제 시카플라스트 밤", "일리윤 세라마이드 크림"]
        ),
        SimilarCase(
            id: 3,
            profile: "25세 여성, 지성 피부",
            concern: "과도한 피지 & 모공",
            similarity: 82,
            beforeImage: "cy1",
            afterImage: "cy2",
            duration: "8주",
            improvements: CaseImprovement(oilControl: 50, pores: -30),
            routine: ["BHA 토너 (격일)", "나이아신아마이드 세럼", "젤 타입 크림"],
            treatments: ["아쿠아필 (월 1회)", "스케일링 관리"],
            products: ["코스알엑스 BHA 토너", "미샤 나이아신아마이드 세럼"]
        )
    ]

    static let recommendedProducts: [RecommendedProduct] = [
        .init(name: "토리든 다이브인 수딩 크림",
              category: "진정 크림",
              reason: "현재 붉은기 개선에 효과적",
              rating: 4.8),
        .init(name: "닥터자르트 시카페어 세럼",
              category: "진정 세럼",
              reason: "트러블 흔적 완화",
              rating: 4.7),
        .init(name: "일리윤 세라마이드 크림",
              category: "보습 크림",
              reason: "수분도 개선 필요",
              rating: 4.9)
    ]

    static let recommendedTreatments: [RecommendedTreatment] = [
        .init(name: "LED 광치료",
              type: "피부과 시술",
              frequency: "주 2회",
              benefit: "염증 완화 및 재생 촉진"),
        .init(name: "아쿠아필",
              type: "피부과 시술",
              frequency: "월 1회",
              benefit: "각질 제거 및 수분 공급"),
        .init(name: "진정 관리",
              type: "피부관리실",
              frequency: "주 1회",
              benefit: "붉은기 완화")
    ]

    private static func makeDate(_ y: Int, _ m: Int, _ d: Int) -> Date {
        var c = DateComponents()
        c.year = y; c.month = m; c.day = d
        return Calendar.current.date(from: c) ?? Date()
    }
}

// MARK: - 공용 컬러 / 그라데이션

extension LinearGradient {
    static let primaryGradient = LinearGradient(
        colors: [Color(red: 0.23, green: 0.43, blue: 0.97),    // blue-600
                 Color(red: 0.58, green: 0.27, blue: 0.96)],   // purple-600
        startPoint: .leading, endPoint: .trailing)

    static let appBackground = LinearGradient(
        colors: [Color(red: 0.94, green: 0.96, blue: 1.0),
                 Color(red: 0.96, green: 0.94, blue: 1.0)],
        startPoint: .topLeading, endPoint: .bottomTrailing)
}

extension Color {
    static let cardBackground = Color(.systemBackground)
    static let mutedText = Color.secondary
    static let successGreen = Color(red: 0.13, green: 0.55, blue: 0.27)
    static let warningRed   = Color(red: 0.86, green: 0.20, blue: 0.27)
}
