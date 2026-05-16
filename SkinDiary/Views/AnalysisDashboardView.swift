//
//  AnalysisDashboardView.swift
//  AI 피부 일기
//
//  요약 카드 + 차트(Swift Charts) + AI 인사이트
//  (React 원본의 AnalysisDashboard.tsx 대응)
//

import SwiftUI
import Charts

struct AnalysisDashboardView: View {

    private let data: [TrendPoint] = MockData.trend

    var body: some View {
        VStack(spacing: 20) {
            summaryCards
            rednessBlemishChart
            textureHydrationChart
            insightsCard
        }
    }

    // MARK: 요약 카드 4종

    private var summaryCards: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            SummaryCard(title: "붉은기",
                        value: "45%",
                        trend: trend(for: \.redness),
                        higherIsWorse: true)
            SummaryCard(title: "트러블",
                        value: "8개",
                        trend: trend(for: \.blemishes),
                        higherIsWorse: true)
            SummaryCard(title: "피부결",
                        value: "72점",
                        trend: trend(for: \.texture),
                        higherIsWorse: false)
            SummaryCard(title: "수분도",
                        value: "65%",
                        trend: trend(for: \.hydration),
                        higherIsWorse: false)
        }
    }

    // MARK: 붉은기 & 트러블 (Area)

    private var rednessBlemishChart: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("붉은기 & 트러블 변화 추이")
                .font(.system(size: 17, weight: .bold))

            Chart {
                ForEach(data) { p in
                    AreaMark(
                        x: .value("Date", p.dateLabel),
                        y: .value("붉은기", p.redness)
                    )
                    .foregroundStyle(by: .value("Series", "붉은기 (%)"))
                    .interpolationMethod(.monotone)

                    AreaMark(
                        x: .value("Date", p.dateLabel),
                        y: .value("트러블", p.blemishes)
                    )
                    .foregroundStyle(by: .value("Series", "트러블 (개)"))
                    .interpolationMethod(.monotone)
                }
            }
            .chartForegroundStyleScale([
                "붉은기 (%)": Color.red.opacity(0.6),
                "트러블 (개)": Color.orange.opacity(0.6)
            ])
            .frame(height: 240)
        }
        .cardStyle()
    }

    // MARK: 피부결 & 수분도 (Line)

    private var textureHydrationChart: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("피부결 & 수분도 변화 추이")
                .font(.system(size: 17, weight: .bold))

            Chart {
                ForEach(data) { p in
                    LineMark(
                        x: .value("Date", p.dateLabel),
                        y: .value("피부결", p.texture)
                    )
                    .foregroundStyle(by: .value("Series", "피부결 (점)"))
                    .interpolationMethod(.monotone)
                    .symbol(by: .value("Series", "피부결 (점)"))

                    LineMark(
                        x: .value("Date", p.dateLabel),
                        y: .value("수분도", p.hydration)
                    )
                    .foregroundStyle(by: .value("Series", "수분도 (%)"))
                    .interpolationMethod(.monotone)
                    .symbol(by: .value("Series", "수분도 (%)"))
                }
            }
            .chartForegroundStyleScale([
                "피부결 (점)": Color.blue,
                "수분도 (%)": Color.cyan
            ])
            .frame(height: 240)
        }
        .cardStyle()
    }

    // MARK: AI 인사이트

    private var insightsCard: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color(red: 0.23, green: 0.43, blue: 0.97))
                    .frame(width: 32, height: 32)
                Image(systemName: "sparkles")
                    .foregroundColor(.white)
                    .font(.system(size: 14, weight: .bold))
            }

            VStack(alignment: .leading, spacing: 10) {
                Text("AI 분석 인사이트")
                    .font(.system(size: 15, weight: .bold))

                insightLine(emoji: "✅", text: "지난 5일간 붉은기가 30.8% 감소했어요. 현재 사용 중인 진정 제품이 효과적입니다.")
                insightLine(emoji: "✅", text: "트러블이 꾸준히 줄어들고 있어요. 46.7% 개선되었습니다.")
                insightLine(emoji: "✅", text: "피부결과 수분도가 모두 상승 중이에요. 꾸준한 보습 관리를 유지하세요.")
                insightLine(emoji: "⚠️", text: "수분도가 65%로 아직 최적 수준(80% 이상)에 미치지 못해요. 수분 크림을 추가해보세요.")
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                colors: [Color.blue.opacity(0.08), Color.purple.opacity(0.08)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.blue.opacity(0.25), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.05), radius: 8, y: 3)
    }

    private func insightLine(emoji: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text(emoji)
            Text(text)
                .font(.system(size: 13))
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    // MARK: 추이 계산

    private func trend(for keyPath: KeyPath<TrendPoint, Double>) -> Double {
        guard let first = data.first?[keyPath: keyPath],
              let last  = data.last?[keyPath: keyPath],
              first != 0 else { return 0 }
        return (last - first) / first * 100
    }
}

// MARK: - 요약 카드 컴포넌트

struct SummaryCard: View {
    let title: String
    let value: String
    let trend: Double
    let higherIsWorse: Bool

    private var improved: Bool {
        higherIsWorse ? trend < 0 : trend > 0
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(title)
                    .font(.system(size: 13))
                    .foregroundColor(.mutedText)
                Spacer()
                Image(systemName: improved
                      ? "arrow.down.right"
                      : "arrow.up.right")
                .foregroundColor(improved ? .successGreen : .warningRed)
                .font(.system(size: 14, weight: .bold))
            }

            Text(value)
                .font(.system(size: 22, weight: .bold))

            Text(String(format: "%.1f%% %@",
                        abs(trend),
                        improved ? "개선" : "악화"))
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(improved ? .successGreen : .warningRed)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.06), radius: 8, y: 3)
    }
}

#Preview {
    ScrollView { AnalysisDashboardView().padding() }
        .background(LinearGradient.appBackground)
}
