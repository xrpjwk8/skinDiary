ㅓ# AI 피부 일기 — SwiftUI 변환본

기존 React/TypeScript 프로토타입을 iOS 16+ SwiftUI 앱으로 옮긴 결과물입니다.

## 폴더 구조

```
SwiftUI/
├── SkinDiaryApp.swift          # @main 엔트리
├── ContentView.swift           # 헤더 + 탭바 + 플로팅 카메라 (원본 App.tsx)
├── Models/
│   └── SkinModels.swift        # 데이터 모델 + Mock 데이터 + 컬러 토큰
└── Views/
    ├── DiaryTimelineView.swift     # 타임랩스 + 메트릭 + 타임라인 그리드
    ├── AnalysisDashboardView.swift # 요약 카드 + Swift Charts + AI 인사이트
    ├── ExpertReportView.swift      # 진료 리포트 + PDF/JSON 내보내기
    ├── CaseStudiesView.swift       # 유사 사례 + 추천 화장품/시술
    └── CameraCaptureView.swift     # PhotosPicker 기반 사진 등록 + 모의 분석
```

## React → SwiftUI 매핑

| 원본 (TSX) | SwiftUI |
| --- | --- |
| `App.tsx` 상하 레이아웃 / 탭 | `ContentView` + `AppTab` enum |
| `lucide-react` 아이콘 | SF Symbols (`camera.fill`, `chart.line.uptrend.xyaxis` 등) |
| `motion/react` 애니메이션 | `withAnimation`, `.animation(_, value:)`, `.transition` |
| Tailwind `bg-gradient-to-r from-blue-600 to-purple-600` | `LinearGradient.primaryGradient` (Models/SkinModels.swift) |
| `recharts` AreaChart / LineChart | `Charts.Chart { AreaMark / LineMark }` |
| `date-fns` 포맷팅 | `DateFormatter(locale: "ko_KR")` |
| `<input type="file" accept="image/*" capture="user">` | `PhotosPicker` (PhotosUI) |
| `URL.createObjectURL` + `<a download>` | `UIActivityViewController` (`ActivityView`) |

## 빌드 / 사용 방법

1. Xcode 14 이상에서 새 iOS App 프로젝트(Interface: SwiftUI, Language: Swift)를 만든다.
2. 자동 생성된 `App` 파일과 `ContentView` 파일을 지우고, 이 폴더의 8개 `.swift` 파일을 그대로 끌어넣는다.
   (`Models/`, `Views/` 폴더는 그룹으로 유지하면 좋습니다.)
3. 샘플 사진(`skin_day1`~`skin_day5`)을 Assets.xcassets에 추가하면 미리보기에 실제 이미지가 보입니다.
   추가하지 않아도 `SkinPhotoView`가 placeholder(스마일 SF Symbol)를 띄워줍니다.
4. 카메라/사진 권한이 필요하므로 Info.plist에 다음 키를 추가:
   - `NSPhotoLibraryUsageDescription`
   - `NSCameraUsageDescription` (실제 카메라 촬영을 더 붙일 경우)

## TODO / 다음 단계 아이디어

- [ ] `CameraCaptureView.runAnalysis()` 안의 무작위 값 자리를 실제 CoreML 또는 Vision + 백엔드 API 호출로 교체
- [ ] 데이터 영속화 — 현재 `MockData`를 SwiftData(또는 CoreData)로 옮겨 일기 추가/삭제/조회를 실제로 처리
- [ ] PDF 리포트 — `ExpertReportView.exportPDF()`에서 `ImageRenderer`로 미리보기 뷰를 그대로 PDF화
- [ ] 유사 사례 매칭 — 사용자 평균 메트릭과 케이스 메트릭 간 유사도를 계산하는 로직 추가
- [ ] 다국어 — 현재 한국어 하드코딩. `Localizable.strings` 전환 시 표현만 분리하면 간단합니다.
