//
//  CaseStudiesView.swift
//  AI 피부 일기
//
//  유사 사례 + 추천 화장품/시술
//  (React 원본의 CaseStudies.tsx 대응)
//

import SwiftUI

struct CaseStudiesView: View {

    private let cases       = MockData.similarCases
    private let products    = MockData.recommendedProducts
    private let treatments  = MockData.recommendedTreatments

    var body: some View {
        VStack(spacing: 20) {
            headerCard

            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 6) {
                    Image(systemName: "person.2.fill")
                    Text("유사 사례 분석 (\(cases.count)건)")
                        .font(.system(size: 17, weight: .bold))
                }

                ForEach(cases) { c in
                    SimilarCaseCard(item: c)
                }
            }

            productsCard
            treatmentsCard
        }
    }

    private var headerCard: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color(red: 0.58, green: 0.27, blue: 0.96))
                    .frame(width: 36, height: 36)
                Image(systemName: "sparkles")
                    .foregroundColor(.white)
            }
            VStack(alignment: .leading, spacing: 6) {
                Text("맞춤형 케어 추천")
                    .font(.system(size: 19, weight: .bold))
                Text("당신과 비슷한 피부 고민을 가졌던 사람들의 성공 사례를 분석하여 맞춤형 솔루션을 제안합니다.")
                    .font(.system(size: 13))
                    .foregroundColor(.mutedText)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .cardStyle()
    }

    private var productsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: "bag.fill")
                Text("추천 화장품")
                    .font(.system(size: 17, weight: .bold))
            }

            VStack(spacing: 10) {
                ForEach(products) { p in
                    ProductRow(product: p)
                }
            }
        }
        .cardStyle()
    }

    private var treatmentsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: "stethoscope")
                Text("추천 시술")
                    .font(.system(size: 17, weight: .bold))
            }

            VStack(spacing: 10) {
                ForEach(treatments) { t in
                    TreatmentRow(treatment: t)
                }
            }
        }
        .cardStyle()
    }
}

// MARK: - 유사 사례 카드

struct SimilarCaseCard: View {

    let item: SimilarCase

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 헤더 (프로필 + 유사도)
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(item.profile)
                        .font(.system(size: 16, weight: .bold))
                    Text("\(item.similarity)% 유사")
                        .font(.system(size: 11, weight: .semibold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.purple.opacity(0.15))
                        .foregroundColor(Color.purple)
                        .clipShape(Capsule())
                }
                Text("주요 고민: \(item.concern)")
                    .font(.system(size: 12))
                    .foregroundColor(.mutedText)
                Text("개선 기간: \(item.duration)")
                    .font(.system(size: 12))
                    .foregroundColor(.mutedText)
            }

            // Before / After
            VStack(alignment: .leading, spacing: 8) {
                Text("개선 결과")
                    .font(.system(size: 13, weight: .bold))

                HStack(spacing: 10) {
                    beforeAfterTile(name: item.beforeImage, label: "Before")
                    beforeAfterTile(name: item.afterImage,  label: "After")
                }

                VStack(alignment: .leading, spacing: 3) {
                    if let v = item.improvements.redness {
                        improvementLine("붉은기 \(abs(v))% 감소")
                    }
                    if let v = item.improvements.blemishes {
                        improvementLine("트러블 \(abs(v))% 감소")
                    }
                    if let v = item.improvements.hydration {
                        improvementLine("수분도 \(v)% 증가")
                    }
                    if let v = item.improvements.texture {
                        improvementLine("피부결 \(v)% 개선")
                    }
                    if let v = item.improvements.oilControl {
                        improvementLine("피지 조절 \(v)% 향상")
                    }
                    if let v = item.improvements.pores {
                        improvementLine("모공 \(abs(v))% 감소")
                    }
                }
            }

            // 일일 루틴 / 시술 / 제품
            VStack(alignment: .leading, spacing: 12) {
                routineSection(title: "일일 케어 루틴",
                                items: item.routine,
                                accent: Color(red: 0.23, green: 0.43, blue: 0.97))
                routineSection(title: "병행 시술",
                                items: item.treatments,
                                accent: Color(red: 0.58, green: 0.27, blue: 0.96))
                routineSection(title: "사용 제품",
                                items: item.products,
                                accent: .green)
            }
        }
        .cardStyle()
    }

    private func beforeAfterTile(name: String, label: String) -> some View {
        VStack(spacing: 4) {
            SkinPhotoView(name: name)
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .clipped()
//                .aspectRatio(1, contentMode: .fit)
                .frame(width: 160, height: 170)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 10))
            Text(label)
                .font(.system(size: 11))
                .bold()
                .foregroundColor(.mutedText)
        }
    }

    private func improvementLine(_ text: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: "checkmark")
                .font(.system(size: 11, weight: .bold))
            Text(text)
                .font(.system(size: 12))
        }
        .foregroundColor(.successGreen)
    }

    private func routineSection(title: String, items: [String], accent: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 13, weight: .bold))

            ForEach(items, id: \.self) { line in
                HStack(alignment: .top, spacing: 6) {
                    Text("•").foregroundColor(accent)
                    Text(line)
                        .font(.system(size: 12))
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer(minLength: 0)
                }
            }
        }
    }
}

// MARK: - 제품 / 시술 행

struct ProductRow: View {
    let product: RecommendedProduct
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(product.category)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(Color.purple)
                Spacer()
                HStack(spacing: 3) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: 10))
                    Text(String(format: "%.1f", product.rating))
                        .font(.system(size: 12, weight: .bold))
                }
            }
            Text(product.name)
                .font(.system(size: 15, weight: .bold))
            Text(product.reason)
                .font(.system(size: 12))
                .foregroundColor(.mutedText)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
}

struct TreatmentRow: View {
    let treatment: RecommendedTreatment
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(treatment.type)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(Color(red: 0.23, green: 0.43, blue: 0.97))
                Spacer()
                Text(treatment.frequency)
                    .font(.system(size: 11))
                    .foregroundColor(.mutedText)
            }
            Text(treatment.name)
                .font(.system(size: 15, weight: .bold))
            Text(treatment.benefit)
                .font(.system(size: 12))
                .foregroundColor(.mutedText)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
}

#Preview {
    ScrollView { CaseStudiesView().padding() }
        .background(LinearGradient.appBackground)
}
