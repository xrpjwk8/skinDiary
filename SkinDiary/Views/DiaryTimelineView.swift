//
//  DiaryTimelineView.swift
//  AI 피부 일기
//
//  타임랩스 뷰 + 메트릭 + 타임라인 그리드
//  (React 원본의 DiaryTimeline.tsx 대응)
//

import SwiftUI

struct DiaryTimelineView: View {

    @State private var selectedEntry: SkinEntry = MockData.entries[0]
    @State private var isTimelapseMode: Bool = false
    @State private var timelapseTask: Task<Void, Never>? = nil

    private let entries: [SkinEntry] = MockData.entries

    var body: some View {
        VStack(spacing: 24) {
            timelapseCard
            timelineGridCard
        }
    }

    // MARK: 타임랩스 카드

    private var timelapseCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("타임랩스 뷰")
                    .font(.system(size: 18, weight: .bold))
                Spacer()
                Button(action: startTimelapse) {
                    HStack(spacing: 6) {
                        Image(systemName: "play.fill")
                            .font(.system(size: 12))
                        Text(isTimelapseMode ? "재생 중..." : "타임랩스 재생")
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(LinearGradient.primaryGradient)
                    .clipShape(Capsule())
                    .opacity(isTimelapseMode ? 0.5 : 1.0)
                }
                .disabled(isTimelapseMode)
            }

            // 이미지 + 날짜 배지
            ZStack(alignment: .topLeading) {
                SkinPhotoView(name: selectedEntry.imageName)
//                    .aspectRatio(1, contentMode: .fit)
//                    .frame(maxWidth: .infinity)
                    .frame(width: 330, height: 350)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .id(selectedEntry.id) // transition trigger

                Text(formattedDate(selectedEntry.date))
                    .font(.system(size: 12, weight: .semibold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(.ultraThinMaterial, in: Capsule())
                    .padding(12)
            }
            .animation(.easeInOut(duration: 0.3), value: selectedEntry.id)

            // 메트릭 4종
            VStack(spacing: 14) {
                metricRow(label: "붉은기",
                          value: "\(selectedEntry.redness)%",
                          progress: Double(selectedEntry.redness) / 100,
                          gradient: [.red.opacity(0.7), .red],
                          improvement: improvementText(
                            current: Double(selectedEntry.redness),
                            previous: Double(entries[1].redness),
                            higherIsWorse: true))

                blemishRow

                metricRow(label: "피부결",
                          value: "\(selectedEntry.texture)점",
                          progress: Double(selectedEntry.texture) / 100,
                          gradient: [.blue.opacity(0.7), .blue],
                          improvement: improvementText(
                            current: Double(selectedEntry.texture),
                            previous: Double(entries[1].texture),
                            higherIsWorse: false))

                metricRow(label: "수분도",
                          value: "\(selectedEntry.hydration)%",
                          progress: Double(selectedEntry.hydration) / 100,
                          gradient: [.cyan.opacity(0.7), .cyan],
                          improvement: improvementText(
                            current: Double(selectedEntry.hydration),
                            previous: Double(entries[1].hydration),
                            higherIsWorse: false))
            }
        }
        .cardStyle()
    }

    // MARK: 타임라인 그리드

    private var timelineGridCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("일기 타임라인")
                .font(.system(size: 18, weight: .bold))

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3),
                      spacing: 10) {
                ForEach(entries) { entry in
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedEntry = entry
                        }
                    } label: {
                        ZStack(alignment: .bottomLeading) {
                            SkinPhotoView(name: entry.imageName)
                                .frame(maxWidth: .infinity, maxHeight: .infinity) // 영역 꽉 채우기
                                .clipped()

                            // 하단 날짜 그라데이션
                            LinearGradient(
                                colors: [.black.opacity(0.7), .clear],
                                startPoint: .bottom, endPoint: .top
                            )
                            .frame(height: 30)
                            .overlay(alignment: .bottomLeading) {
                                Text(shortDate(entry.date))
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.leading, 6)
                                    .padding(.bottom, 4)
                            }
                        }
                        .aspectRatio(1, contentMode: .fit) // <- 셀을 정사각형으로 고정
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(selectedEntry.id == entry.id
                                        ? Color(red: 0.23, green: 0.43, blue: 0.97)
                                        : Color.gray.opacity(0.2),
                                        lineWidth: 2)
                        )
                        .scaleEffect(selectedEntry.id == entry.id ? 1.0 : 1.0)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .cardStyle()
    }

    // MARK: 메트릭 행 (붉은기/피부결/수분도 공용)

    private func metricRow(label: String,
                           value: String,
                           progress: Double,
                           gradient: [Color],
                           improvement: (text: String, color: Color)?) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(label)
                    .font(.system(size: 13))
                    .foregroundColor(.mutedText)
                Spacer()
                Text(value)
                    .font(.system(size: 17, weight: .bold))
                if let imp = improvement {
                    Text(imp.text)
                        .font(.system(size: 11))
                        .foregroundColor(imp.color)
                }
            }

            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.gray.opacity(0.18))
                    Capsule()
                        .fill(LinearGradient(colors: gradient,
                                             startPoint: .leading,
                                             endPoint: .trailing))
                        .frame(width: proxy.size.width * progress)
                        .animation(.easeOut(duration: 0.4), value: progress)
                }
            }
            .frame(height: 8)
        }
    }

    // MARK: 트러블 행 (15칸짜리 막대)

    private var blemishRow: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("트러블 개수")
                    .font(.system(size: 13))
                    .foregroundColor(.mutedText)
                Spacer()
                Text("\(selectedEntry.blemishes)개")
                    .font(.system(size: 17, weight: .bold))
                if let imp = improvementText(current: Double(selectedEntry.blemishes),
                                              previous: Double(entries[1].blemishes),
                                              higherIsWorse: true) {
                    Text(imp.text)
                        .font(.system(size: 11))
                        .foregroundColor(imp.color)
                }
            }

            HStack(spacing: 3) {
                ForEach(0..<15, id: \.self) { i in
                    Capsule()
                        .fill(i < selectedEntry.blemishes
                              ? AnyShapeStyle(LinearGradient(
                                colors: [.orange.opacity(0.7), .orange],
                                startPoint: .leading, endPoint: .trailing))
                              : AnyShapeStyle(Color.gray.opacity(0.18)))
                        .frame(height: 8)
                }
            }
        }
    }

    // MARK: 헬퍼

    private func improvementText(current: Double,
                                  previous: Double,
                                  higherIsWorse: Bool) -> (text: String, color: Color)? {
        guard previous != 0 else { return nil }
        let diff = previous - current   // 양수 => 감소
        let pct = Int(abs(diff))
        if higherIsWorse {
            return diff > 0
            ? ("\(pct)% 개선", .successGreen)
            : ("\(pct)% 악화", .warningRed)
        } else {
            return diff < 0
            ? ("\(pct)% 개선", .successGreen)
            : ("\(pct)% 악화", .warningRed)
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ko_KR")
        f.dateFormat = "M월 d일 (EEE)"
        return f.string(from: date)
    }

    private func shortDate(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "M/d"
        return f.string(from: date)
    }

    private func startTimelapse() {
        guard !isTimelapseMode else { return }
        isTimelapseMode = true

        timelapseTask?.cancel()
        timelapseTask = Task {
            for i in 0..<entries.count {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                if Task.isCancelled { break }
                await MainActor.run {
                    selectedEntry = entries[(i + 1) % entries.count]
                }
            }
            await MainActor.run {
                isTimelapseMode = false
            }
        }
    }
}

// MARK: - 카드 스타일 modifier

extension View {
    func cardStyle() -> some View {
        self
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: .black.opacity(0.06), radius: 10, y: 4)
    }
}

// MARK: - 사진 표시 (원격 URL or 에셋명 자동 분기)

struct SkinPhotoView: View {
    let name: String

    var body: some View {
        Group {
            if name.hasPrefix("http"), let url = URL(string: name) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.gray.opacity(0.1))
                    case .success(let img):
                        img.resizable().scaledToFill()
                    case .failure:
                        placeholder
                    @unknown default:
                        placeholder
                    }
                }
            } else if UIImage(named: name) != nil {
                Image(name).resizable().scaledToFill()
            } else {
                placeholder
            }
        }
    }

    private var placeholder: some View {
        ZStack {
            LinearGradient(
                colors: [Color.pink.opacity(0.15), Color.purple.opacity(0.15)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            Image(systemName: "face.smiling")
                .font(.system(size: 36))
                .foregroundColor(.gray.opacity(0.5))
        }
    }
}

#Preview {
    ScrollView { DiaryTimelineView().padding() }
        .background(LinearGradient.appBackground)
}
