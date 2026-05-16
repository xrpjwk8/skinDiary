//
//  ContentView.swift
//  AI 피부 일기
//
//  메인 컨테이너: 상단 헤더 + 하단 탭바 + 플로팅 카메라 버튼
//  (React 원본의 App.tsx 대응)
//

import SwiftUI

enum AppTab: String, CaseIterable, Identifiable {
    case diary    = "피부 일기"
    case analysis = "분석"
    case report   = "리포트"
    case cases    = "케어"

    var id: String { rawValue }

    var iconName: String {
        switch self {
        case .diary:    return "calendar"
        case .analysis: return "chart.line.uptrend.xyaxis"
        case .report:   return "doc.text"
        case .cases:    return "person.2"
        }
    }
}

struct ContentView: View {

    @State private var activeTab: AppTab = .diary
        @State private var showCamera: Bool = false

        var body: some View {
            TabView(selection: $activeTab) {

                tabScreen { DiaryTimelineView() }
                    .tabItem {
                        Label(AppTab.diary.rawValue,
                              systemImage: AppTab.diary.iconName)
                    }
                    .tag(AppTab.diary)

                tabScreen { AnalysisDashboardView() }
                    .tabItem {
                        Label(AppTab.analysis.rawValue,
                              systemImage: AppTab.analysis.iconName)
                    }
                    .tag(AppTab.analysis)

                tabScreen { ExpertReportView() }
                    .tabItem {
                        Label(AppTab.report.rawValue,
                              systemImage: AppTab.report.iconName)
                    }
                    .tag(AppTab.report)

                tabScreen { CaseStudiesView() }
                    .tabItem {
                        Label(AppTab.cases.rawValue,
                              systemImage: AppTab.cases.iconName)
                    }
                    .tag(AppTab.cases)
            }
            .tabBarMinimizeBehavior(.onScrollDown)   // 스크롤 시 탭바가 캡슐로 축소
            .tint(Color(red: 0.23, green: 0.43, blue: 0.97))
            .overlay(alignment: .bottomTrailing) {
                // 플로팅 카메라 버튼은 일기 탭에서만
                if activeTab == .diary {
                    FloatingCameraButton { showCamera = true }
                        .padding(.trailing, 24)
                        .padding(.bottom, 90)   // 탭바 위로
                }
            }
            .sheet(isPresented: $showCamera) {
                CameraCaptureView()
            }
        }

        // 각 탭 공통: 헤더 + 스크롤 본문
        @ViewBuilder
        private func tabScreen<Content: View>(@ViewBuilder _ content: () -> Content) -> some View {
            VStack(spacing: 0) {
                headerView
                ScrollView {
                    content()
                        .padding(.horizontal, 16)
                        .padding(.vertical, 20)
                        .padding(.bottom, 40)
                }
            }
            .background(LinearGradient.appBackground.ignoresSafeArea())
        }

    // MARK: 헤더

    private var headerView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("AI 피부 일기")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(LinearGradient.primaryGradient)

            Text("당신의 피부 변화를 AI가 기록합니다")
                .font(.system(size: 13))
                .foregroundColor(.mutedText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            Color.cardBackground
                .ignoresSafeArea(edges: .top)
//                .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
        )
        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
    }

    // MARK: 하단 탭바

    private var bottomTabBar: some View {
        HStack {
            ForEach(AppTab.allCases) { tab in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        activeTab = tab
                    }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: tab.iconName)
                            .font(.system(size: 22, weight: .regular))
                        Text(tab.rawValue)
                            .font(.system(size: 11))
                    }
                    .foregroundColor(activeTab == tab
                                     ? Color(red: 0.23, green: 0.43, blue: 0.97)
                                     : .secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 8)
        .background(
            Color.cardBackground
                .shadow(color: .black.opacity(0.08), radius: 8, y: -2)
        )
    }
}

#Preview {
    ContentView()
}
