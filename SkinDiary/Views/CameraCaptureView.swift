//
//  CameraCaptureView.swift
//  AI 피부 일기
//
//  플로팅 카메라 버튼 + 사진 촬영/업로드 + AI 분석 결과 알림
//  (React 원본의 CameraCapture.tsx 대응)
//

import SwiftUI
import PhotosUI

// MARK: - 플로팅 카메라 버튼

struct FloatingCameraButton: View {
    let action: () -> Void
    @State private var pressed = false

    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: "camera.fill")
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background(LinearGradient.primaryGradient)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.25), radius: 10, y: 4)
                .scaleEffect(pressed ? 0.9 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: pressed)
        }
        .buttonStyle(.plain)
        .onLongPressGesture(minimumDuration: 0,
                             pressing: { pressed = $0 },
                             perform: {})
    }
}

// MARK: - 카메라 / 갤러리 모달 시트

struct CameraCaptureView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var pickerItem: PhotosPickerItem? = nil
    @State private var capturedImage: UIImage? = nil

    @State private var analysisAlert: SkinAnalysisResult? = nil

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {

                if let img = capturedImage {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 260)
                        .clipShape(RoundedRectangle(cornerRadius: 16))

                    HStack(spacing: 10) {
                        Button {
                            capturedImage = nil
                            pickerItem = nil
                        } label: {
                            Text("다시 찍기")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.cardBackground)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                                .foregroundColor(.primary)
                        }

                        Button {
                            runAnalysis()
                        } label: {
                            Text("저장 및 분석")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(LinearGradient.primaryGradient)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }

                } else {

                    PhotosPicker(selection: $pickerItem,
                                 matching: .images,
                                 photoLibrary: .shared()) {
                        VStack(spacing: 10) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 36))
                                .foregroundColor(.gray)
                            Text("사진을 업로드하세요")
                                .font(.system(size: 14))
                                .foregroundColor(.mutedText)
                            Text("같은 조도에서 촬영해주세요")
                                .font(.system(size: 11))
                                .foregroundColor(.mutedText.opacity(0.7))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 48)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(style: StrokeStyle(lineWidth: 2, dash: [6]))
                                .foregroundColor(.gray.opacity(0.4))
                        )
                    }
                }

                // 촬영 팁
                VStack(alignment: .leading, spacing: 6) {
                    Text("📸 촬영 팁")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.blue)
                    bullet("자연광이 들어오는 같은 장소에서 촬영하세요")
                    bullet("매일 같은 시간대에 기록하면 더 정확해요")
                    bullet("화장을 지운 맨얼굴 상태로 촬영해주세요")
                }
                .font(.system(size: 12))
                .foregroundColor(.blue.opacity(0.85))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(14)
                .background(Color.blue.opacity(0.07))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.blue.opacity(0.25), lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))

                Spacer()
            }
            .padding(20)
            .navigationTitle("오늘의 피부 기록")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.primary)
                    }
                }
            }
        }
        .onChange(of: pickerItem) { newItem in
            Task { await loadImage(from: newItem) }
        }
        .alert(item: $analysisAlert) { result in
            Alert(
                title: Text("AI 분석 완료!"),
                message: Text("""
                붉은기: \(result.redness)%
                트러블: \(result.blemishes)개
                피부결: \(result.texture)점
                수분도: \(result.hydration)%
                """),
                dismissButton: .default(Text("확인")) {
                    dismiss()
                }
            )
        }
    }

    private func bullet(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 6) {
            Text("•")
            Text(text)
        }
    }

    @MainActor
    private func loadImage(from item: PhotosPickerItem?) async {
        guard let item = item else { return }
        if let data = try? await item.loadTransferable(type: Data.self),
           let img  = UIImage(data: data) {
            capturedImage = img
        }
    }

    /// 실제 모델 연동 자리. 지금은 무작위 값으로 모의 분석.
    private func runAnalysis() {
        analysisAlert = SkinAnalysisResult(
            redness:   Int.random(in: 0...100),
            blemishes: Int.random(in: 0...15),
            texture:   Int.random(in: 0...100),
            hydration: Int.random(in: 0...100)
        )
    }
}

// MARK: - 분석 결과 모델 (alert(item:) 호환)

struct SkinAnalysisResult: Identifiable {
    let id = UUID()
    let redness: Int
    let blemishes: Int
    let texture: Int
    let hydration: Int
}

#Preview {
    CameraCaptureView()
}
