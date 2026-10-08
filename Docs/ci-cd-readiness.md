# CI/CD 준비 상태

## CI

- GitHub Actions는 Pull Request와 `main` 푸시에서 실행합니다.
- `.tool-versions`가 Tuist 4.202.0을 고정합니다. 워크플로는 Tuist로 Xcode 프로젝트를 생성한 뒤, 서명 없이 시뮬레이터 빌드와 XCTest를 실행합니다.
- CI에는 API 키나 서버 주소가 필요하지 않습니다. 현재 앱의 검증 범위는 빌드와 로컬 XCTest이며, 실제 서버 응답·인증·업로드 동작을 검증하지 않습니다.

## TestFlight CD

서버 연결은 TestFlight 업로드 자체의 전제 조건이 아닙니다. 다만 이 앱은 현재 로컬 샘플 데이터 중심이라, 업로드된 빌드는 UI 검토용 베타로만 다루는 게 적절합니다. 자동 업로드를 켜려면 아래 준비가 필요합니다.

- Apple Developer Program 가입과 `com.findr.ios` App ID 및 App Store Connect 앱 레코드
- 배포 서명 설정과 자동 증가할 빌드 번호 규칙
- App Store Connect API 접근 승인, 최소 권한 API 키, GitHub Actions Secret 저장
- TestFlight 내부 테스터와 업로드 트리거 결정

이 정보가 준비되면 수동 실행 가능한 TestFlight 워크플로부터 추가하고, 업로드 결과를 확인한 뒤 자동 트리거를 결정합니다. API 키나 서명 파일은 저장소에 커밋하지 않습니다.
