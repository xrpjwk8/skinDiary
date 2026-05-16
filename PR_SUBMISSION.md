# Upstage edu-usecase-hackathon PR 준비 메모

## 제출 대상 저장소

- Repository: `https://github.com/UpstageAI/edu-usecase-hackathon`
- 기본 브랜치: `main`
- 권한: 원본 저장소에는 직접 push 권한이 없으므로 fork 후 PR 생성 필요

## 권장 폴더 구조

원본 저장소 README 규칙에 맞춰 아래 구조로 추가하는 것을 권장합니다.

```text
edu-usecase-hackathon/
└── [YSAI-F4]_Solar-Document-Parse-Personalized-Skin-Care/
    ├── README.md
    └── ai-skin-diary/
        ├── README.md
        ├── SkinDiary.xcodeproj/
        ├── SkinDiary/
        ├── docs/
        │   ├── presentation/
        │   │   └── ysai_f4_presentation.pdf
        │   ├── sample-images/
        │   └── screenshots/
        └── workflows/
            └── ysai_f4_skin_workflow_v2.json
```

## 해커톤 폴더 README 초안

```md
# [YSAI-F4] Solar Document Parse Personalized Skin Care

> Upstage Document Parse와 Solar LLM을 활용해 피부 사진, 처방전/소견서, 후기 레퍼런스를 결합한 개인 맞춤 피부 관리 유즈케이스입니다.

## 개요

| 항목 | 내용 |
|---|---|
| 개최일 | 2026-05 |
| 주최/주관 | Upstage / YSAI |
| 장소 | Online / Korea |
| 참가 규모 | YSAI F4 |
| 공식 링크 | https://github.com/UpstageAI/edu-usecase-hackathon |

## 주제

시계열 피부 사진과 선택 입력한 처방전/소견서를 기반으로 피부 상태 변화를 분석하고, 신뢰도 필터를 통과한 레퍼런스와 Solar LLM을 활용해 사용자별 케어 액션과 리포트를 생성합니다.

## 활용된 Upstage API

- **Solar LLM** — 피부 지표, 의료 정보, 레퍼런스를 종합해 맞춤 솔루션 JSON 생성
- **Document Parse** — 처방전/소견서에서 약품, 진단명, 시술 정보 추출

## 프로젝트 목록

| 프로젝트 | 한줄 설명 | 주요 활용 API |
|---|---|---|
| [ai-skin-diary](./ai-skin-diary) | 시계열 피부 사진과 의료 문서를 분석해 맞춤 피부 케어 리포트를 제공하는 iOS 데모 | Solar LLM, Document Parse |
```

## PR 제목 초안

```text
Add YSAI F4 AI Skin Diary use case
```

## PR 본문 초안

```md
## Summary

- Add YSAI F4 `ai-skin-diary` use case
- Include SwiftUI iOS demo for skin diary, analysis dashboard, expert report, and care recommendation screens
- Include n8n workflow using Upstage Document Parse and Solar LLM for personalized skin-care report generation

## Included

- Project README following the repository template
- SwiftUI demo source code and sample assets
- Presentation PDF
- n8n workflow JSON

## Notes

- This is a judging/demo-oriented project.
- The iOS app currently uses mock skin data for UI demonstration.
- The end-to-end AI workflow is described in `workflows/ysai_f4_skin_workflow_v2.json`.
```

## 제출 전 체크리스트

- [ ] 팀원 이름과 GitHub 계정을 README에 추가
- [ ] 해커톤 개최일/공식 링크가 실제 정보와 맞는지 확인
- [ ] 발표자료 `docs/presentation/ysai_f4_presentation.pdf` 포함
- [ ] 워크플로우 `workflows/ysai_f4_skin_workflow_v2.json` 포함
- [ ] 루트에는 README, Xcode 프로젝트, 앱 소스, docs, workflows만 유지
- [ ] Xcode user data 등 불필요한 개인 설정 파일 제외 여부 확인
