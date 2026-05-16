//
//  ExpertReportView.swift
//  AI 피부 일기
//
//  전문가 진료용 리포트 (PDF/JSON 내보내기 + 미리보기)
//  (React 원본의 ExpertReport.tsx 대응)
//

import SwiftUI
import UIKit

struct ExpertReportView: View {

    @State private var showShareSheet = false
    @State private var exportedURL: URL? = nil
    @State private var alertMessage: String? = nil

    var body: some View {
        VStack(spacing: 20) {
            exportCard
            reportPreviewCard
        }
        .sheet(isPresented: $showShareSheet) {
            if let url = exportedURL {
                ActivityView(items: [url])
            }
        }
        .alert("리포트", isPresented: Binding(
            get: { alertMessage != nil },
            set: { if !$0 { alertMessage = nil } }
        )) {
            Button("확인", role: .cancel) { }
        } message: {
            Text(alertMessage ?? "")
        }
    }

    // MARK: 내보내기 카드

    private var exportCard: some View {
        VStack(spacing: 16) {
            VStack(spacing: 6) {
                Text("전문가 진료 리포트")
                    .font(.system(size: 20, weight: .bold))
                Text("병원 방문 시 제출할 수 있는 피부 데이터 요약 리포트")
                    .font(.system(size: 13))
                    .foregroundColor(.mutedText)
                    .multilineTextAlignment(.center)
            }

            VStack(spacing: 10) {
                Button(action: exportPDF) {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.down.doc.fill")
                        Text("PDF 다운로드").fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(LinearGradient.primaryGradient)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                Button(action: exportJSON) {
                    HStack(spacing: 8) {
                        Image(systemName: "doc.text")
                        Text("데이터 내보내기").fontWeight(.semibold)
                    }
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                }
            }
        }
        .cardStyle()
    }

    // MARK: 리포트 미리보기

    private var reportPreviewCard: some View {
        VStack(alignment: .leading, spacing: 20) {

            // 타이틀
            VStack(spacing: 6) {
                Text("피부 상태 분석 리포트")
                    .font(.system(size: 22, weight: .bold))
                Text("분석 기간: 2026년 5월 8일 ~ 2026년 5월 12일")
                    .font(.system(size: 12))
                    .foregroundColor(.mutedText)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
            .overlay(alignment: .bottom) {
                Divider()
            }

            // 기본 정보
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 6) {
                    Image(systemName: "calendar")
                    Text("기본 정보").fontWeight(.bold)
                }
                infoRow("기록 시작일", "2026년 5월 8일")
                infoRow("총 기록 일수", "5일")
                infoRow("분석 항목", "붉은기, 트러블, 피부결, 수분도")
                infoRow("촬영 조건", "자연광, 동일 장소")
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.gray.opacity(0.06))
            .clipShape(RoundedRectangle(cornerRadius: 12))

            // 주요 분석 결과
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 6) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("주요 분석 결과").fontWeight(.bold)
                }

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    FindingBox(label: "붉은기", before: "65%", after: "45%",
                               change: "30.8% 감소", positive: true, accent: .green)
                    FindingBox(label: "트러블 개수", before: "15개", after: "8개",
                               change: "46.7% 감소", positive: true, accent: .green)
                    FindingBox(label: "피부결", before: "60점", after: "72점",
                               change: "20.0% 증가", positive: true, accent: .blue)
                    FindingBox(label: "수분도", before: "55%", after: "65%",
                               change: "18.2% 증가", positive: true, accent: .blue)
                }
            }

            // 시각적 변화 기록
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 6) {
                    Image(systemName: "photo.on.rectangle.angled")
                    Text("시각적 변화 기록").fontWeight(.bold)
                }

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(Array(MockData.entries.reversed().enumerated()), id: \.offset) { idx, entry in
                            VStack(spacing: 4) {
                                SkinPhotoView(name: entry.imageName)
                                    .aspectRatio(1, contentMode: .fill)
                                    .frame(width: 90, height: 90)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                Text("Day \(idx + 1)")
                                    .font(.system(size: 11))
                                    .foregroundColor(.mutedText)
                            }
                        }
                    }
                    .padding(8)
                }
                .background(Color.gray.opacity(0.06))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            // 전문가 참고사항
            VStack(alignment: .leading, spacing: 8) {
                Text("전문가 참고사항").fontWeight(.bold)
                VStack(alignment: .leading, spacing: 4) {
                    bullet("지난 5일간 전반적인 피부 상태가 개선되는 추세를 보임")
                    bullet("특히 염증성 병변(붉은기, 트러블)의 감소가 두드러짐")
                    bullet("피부 장벽 기능 개선 가능성 시사 (피부결 및 수분도 상승)")
                    bullet("현재 수분도(65%)는 개선되었으나 최적 수준에는 미달")
                    bullet("지속적인 관찰 및 보습 강화 필요")
                }
                .font(.system(size: 12))
                .foregroundColor(.primary)
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.yellow.opacity(0.12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.yellow.opacity(0.4), lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            // 면책
            VStack(spacing: 2) {
                Text("본 리포트는 AI 기반 이미지 분석 결과로, 의학적 진단을 대체할 수 없습니다.")
                Text("정확한 진단과 치료는 전문 의료진과 상담하시기 바랍니다.")
            }
            .font(.system(size: 11))
            .foregroundColor(.mutedText)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .padding(.top, 8)
            .overlay(alignment: .top) {
                Divider().offset(y: 0)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.cardBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray.opacity(0.2), lineWidth: 2)
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.06), radius: 10, y: 4)
    }

    // MARK: 헬퍼

    private func infoRow(_ key: String, _ value: String) -> some View {
        HStack(alignment: .top) {
            Text("\(key):")
                .foregroundColor(.mutedText)
                .frame(width: 100, alignment: .leading)
            Text(value).fontWeight(.medium)
            Spacer(minLength: 0)
        }
        .font(.system(size: 13))
    }

    private func bullet(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 6) {
            Text("•")
            Text(text)
            Spacer(minLength: 0)
        }
    }

    // MARK: 내보내기 동작

    private func exportPDF() {
        alertMessage = """
        PDF 리포트가 생성됩니다.

        포함 내용:
        • 5일간 피부 변화 사진
        • AI 분석 수치 그래프
        • 개선/악화 추이 분석
        • 주요 증상 요약
        """
    }

    private func exportJSON() {
        let payload: [String: Any] = [
            "period": "2026-05-08 ~ 2026-05-12",
            "summary": [
                "redness":   ["start": 65, "end": 45, "change": -30.8],
                "blemishes": ["start": 15, "end": 8,  "change": -46.7],
                "texture":   ["start": 60, "end": 72, "change": 20.0],
                "hydration": ["start": 55, "end": 65, "change": 18.2]
            ],
            "entries": 5
        ]
        guard let data = try? JSONSerialization.data(withJSONObject: payload,
                                                     options: [.prettyPrinted]) else { return }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let filename = "skin-report-\(formatter.string(from: Date())).json"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
        do {
            try data.write(to: url)
            exportedURL = url
            showShareSheet = true
        } catch {
            alertMessage = "내보내기에 실패했습니다: \(error.localizedDescription)"
        }
    }
}

// MARK: - 주요 분석 결과 박스

struct FindingBox: View {
    let label: String
    let before: String
    let after: String
    let change: String
    let positive: Bool
    let accent: Color   // .green / .blue 톤

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(label)
                    .font(.system(size: 12, weight: .semibold))
                Spacer()
                Text(positive ? "개선" : "악화")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(accent)
            }
            Text("\(before) → \(after)")
                .font(.system(size: 18, weight: .bold))
            Text(change)
                .font(.system(size: 12))
                .foregroundColor(accent)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(accent.opacity(0.08))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(accent.opacity(0.3), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - UIActivityViewController 래퍼

struct ActivityView: UIViewControllerRepresentable {
    let items: [Any]
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    func updateUIViewController(_ vc: UIActivityViewController, context: Context) {}
}

#Preview {
    ScrollView { ExpertReportView().padding() }
        .background(LinearGradient.appBackground)
}
