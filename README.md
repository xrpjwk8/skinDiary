# AI Skin Diary

시계열 피부 사진을 기반으로 피부 변화를 기록하고, AI 분석 결과를 개인 맞춤 케어 추천과 전문가용 리포트로 연결하는 iOS 데모 프로젝트입니다. 이 저장소는 심사용 데모를 목적으로 하며, `ysai_f4_발표자료.pdf`와 `ysai_f4_skin_workflow_v2.json`에 정리된 서비스 흐름을 SwiftUI 앱 화면으로 구현한 결과물입니다.

## 프로젝트 개요

피부 관리는 하루의 상태만 보는 것보다 같은 조건에서 누적된 변화를 보는 것이 중요합니다. AI Skin Diary는 사용자가 주기적으로 촬영한 피부 사진을 일기처럼 쌓고, 붉은기, 트러블, 피부결, 수분도 같은 지표를 시계열로 비교해 현재 루틴이 실제로 개선 효과를 내고 있는지 보여주는 것을 목표로 합니다.

발표자료의 전체 서비스 컨셉은 다음 흐름입니다.

1. 사용자가 피부 사진과 선택적으로 처방전/소견서 파일을 업로드합니다.
2. 피부 사진 분석 API가 주요 피부 지표를 추출합니다.
3. 최근 기록과 기준값을 비교해 7일 이동평균, 변화율, 악화 지표를 계산합니다.
4. 처방전이 있는 경우 Upstage Document Parse로 약품, 진단명, 시술 정보를 구조화합니다.
5. 사용자의 피부 지표와 의료 맥락을 바탕으로 후기/뉴스 레퍼런스를 검색하고 광고성 콘텐츠를 필터링합니다.
6. Upstage Solar LLM이 오늘의 액션, 추천/회피 성분, 유사 사례, 병원 상담 시그널을 생성합니다.
7. 결과를 앱 화면과 이메일 리포트 형태로 제공합니다.

현재 SwiftUI 앱은 위 흐름 중 사용자가 심사 과정에서 직접 확인할 수 있는 모바일 UX를 중심으로 구현되어 있습니다.

## 핵심 기능

### 1. 피부 일기와 타임랩스

- 날짜별 피부 사진을 타임라인 형태로 확인
- 선택한 날짜의 붉은기, 트러블, 피부결, 수분도 표시
- 여러 날짜 사진을 순차 재생하는 타임랩스 모드
- 같은 조도와 같은 시간대 촬영을 유도하는 업로드 가이드

### 2. AI 분석 대시보드

- 붉은기, 트러블, 피부결, 수분도 요약 카드
- Swift Charts 기반 변화 추이 차트
- 개선/악화 방향을 지표별로 다르게 해석
  - 붉은기, 트러블은 낮아질수록 개선
  - 피부결, 수분도는 높아질수록 개선
- 사용자에게 바로 이해되는 한국어 AI 인사이트 제공

### 3. 전문가 진료 리포트

- 병원 방문 시 참고할 수 있는 피부 변화 요약
- 분석 기간, 기록 일수, 촬영 조건, 주요 변화 수치 표시
- 날짜별 사진 기록과 전문가 참고사항 제공
- JSON 내보내기 데모 구현
- PDF 내보내기는 데모 알림 형태로 표시

### 4. 유사 사례 기반 케어 추천

- 비슷한 피부 고민을 가진 사례와 유사도 표시
- Before/After 이미지 기반 개선 결과 확인
- 루틴, 병행 시술, 사용 제품 추천
- 화장품과 시술 추천을 별도 섹션으로 구분

### 5. 사진 업로드 및 분석 진입점

- iOS PhotosPicker 기반 이미지 업로드
- 플로팅 카메라 버튼으로 빠른 기록 시작
- 현재 데모에서는 실제 모델 호출 대신 모의 분석값을 사용
- 실제 서비스에서는 `CameraCaptureView.runAnalysis()`가 피부 분석 API 호출부로 교체됩니다.

## 기술 구성

| 영역 | 사용 기술 |
| --- | --- |
| iOS 앱 | SwiftUI, PhotosUI |
| 차트 | Swift Charts |
| 디자인 시스템 | SF Symbols, SwiftUI Gradient, 공용 Card Style |
| 데모 데이터 | `MockData` 기반 시계열 피부 기록 |
| 자동화 워크플로우 | n8n (`ysai_f4_skin_workflow_v2.json`) |
| 문서 파싱 설계 | Upstage Document Parse |
| LLM 솔루션 생성 설계 | Upstage Solar |
| 결과 전달 설계 | HTML 이메일 / Gmail SMTP |

## 저장소 구조

```text
skinDiary/
├── README.md
├── ysai_f4_발표자료.pdf
├── ysai_f4_skin_workflow_v2.json
├── SkinDiary.xcodeproj/
└── SkinDiary/
    ├── SkinDiaryApp.swift
    ├── ContentView.swift
    ├── Models/
    │   └── SkinModels.swift
    ├── Views/
    │   ├── DiaryTimelineView.swift
    │   ├── AnalysisDashboardView.swift
    │   ├── ExpertReportView.swift
    │   ├── CaseStudiesView.swift
    │   └── CameraCaptureView.swift
    └── Assets.xcassets/
```

## 심사 시 확인 포인트

- 이 프로젝트는 완성된 상용 앱이 아니라, 발표자료의 서비스 아이디어를 검증하기 위한 iOS 데모입니다.
- 앱 내부 데이터는 심사용 샘플 이미지와 MockData를 사용합니다.
- 피부 사진 분석, 처방전 파싱, 신뢰도 필터, Solar 기반 리포트 생성은 `ysai_f4_skin_workflow_v2.json`에 n8n 워크플로우 형태로 설계되어 있습니다.
- SwiftUI 앱은 사용자가 실제로 보게 될 핵심 화면인 기록, 분석, 리포트, 추천 UX를 구현합니다.
- 의료 진단을 대체하는 서비스가 아니라, 사용자의 피부 변화 기록과 병원 상담 준비를 돕는 보조 도구로 설계했습니다.

## 실행 방법

1. Xcode 15 이상에서 `SkinDiary.xcodeproj`를 엽니다.
2. 실행 타깃을 iOS Simulator 또는 실제 iPhone으로 선택합니다.
3. `SkinDiary` scheme을 실행합니다.
4. 하단 탭에서 `피부 일기`, `분석`, `리포트`, `케어` 화면을 확인합니다.

사진 업로드 데모를 실제 기기에서 확인하려면 사진 보관함 접근 권한이 필요합니다.

## 구현 상태와 다음 단계

현재 구현된 부분:

- SwiftUI 기반 4개 주요 탭 화면
- 샘플 피부 사진과 시계열 MockData
- 타임랩스 재생
- 차트 기반 분석 대시보드
- 전문가 리포트 미리보기와 JSON 내보내기
- 유사 사례, 제품, 시술 추천 UI
- n8n 기반 전체 AI 워크플로우 설계 파일

다음 단계:

- 실제 피부 분석 API 또는 CoreML/Vision 모델 연동
- 사용자별 기록 저장을 위한 SwiftData/CoreData 적용
- n8n 워크플로우와 iOS 앱 API 연결
- Upstage Document Parse 결과를 앱 리포트에 반영
- PDF 리포트 실제 생성 기능 구현
- 신뢰도 필터와 유사 사례 추천 로직 고도화

## 참고 파일

- `ysai_f4_발표자료.pdf`: 프로젝트 발표자료
- `ysai_f4_skin_workflow_v2.json`: 피부 분석, 문서 파싱, 레퍼런스 필터링, Solar 리포트 생성, 이메일 발송까지의 n8n 워크플로우
