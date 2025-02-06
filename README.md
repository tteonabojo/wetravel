# ✈️ 떠나보조
- 프로젝트 명 : 위트(wetravel)
- 프로젝트 목적 : 여행계획의 첫 단추를 끼우기 어려운 사람에게 추천 여행지와 가이드를 제공해주는 서비스


## 📅 프로젝트 기간
- 2025.1.16 ~ 2025.2.06 (MVP 구현)
- 2025.2.06 ~ 2025.2.26 (추가 기능 구현)


## ❓About Team
- 김혜지(팀장) : 대시보드 정리, 가이드 페이지 (등록, 수정, 삭제), 데이터 구조화, Firebase 데이터 연동
- 김서후(PM) : 스플래시, 로그인, 회원가입, 내비게이션 바, 메인화면, 앱스토어 배포 세팅
- 선우진(왼팔) : Ai연동, 키워드 선택, 여행계획, 광고 세팅(구글 애드몹), Firebase 세팅
- 김민우(오른팔) : 가이드 추천 패키지 리스트, 마이페이지, 데이터 구조화
- 김수빈(디자이너) : 디자인 시스템 구축, App UI 디자인, PPT 템플릿 작성


## 💡 주요 기능
- 로그인 및 회원가입
    - Firebase의 Authentication 사용
    - 소셜(구글, 애플) 회원가입 및 로그인
- 메인
    - 슬라이드 배너
    - 최근에 본 패키지 출력
    - 인기있는 패키지 출력
- 패키지 생성
    - 새로운 여행 시작하기
        - 키워드 설문
        - AI로 도시 추천 받기
        - AI와 일정 함께하기
            - 일정 상세보기
        - 가이드와 일정 함께하기
            - 일정 목록 확인
            - 일정 상세보기
    - 기존 여행 계속하기(스크랩 기능)
- 가이드
    - 가이드 신청
    - 패키지 등록
    - 패키지 수정
    - 내 패키지 목록 확인
    - 내 패키지 확인
- 마이페이지
    - 내 정보 확인 및 수정
        - 프로필 이미지
        - 닉네임
        - 이메일
        - 자기소개
    - 문의하기
    - 이용약관 / 개인정보 처리방침 확인
    - 로그아웃
    - 회원 탈퇴


## 🔥 Firebase Firestore 구조
<pre>
Firestore
├── packages (컬렉션)
│   ├── {packageId} (문서)
│   │   ├── createdAt: Timestamp
│   │   ├── description: String
│   │   ├── duration: String
│   │   ├── id: String
│   │   ├── imageUrl: String
│   │   ├── isHidden: Boolean
│   │   ├── keywordList: List<String>
│   │   ├── location: String
│   │   ├── reportCount: int
│   │   ├── scheduleIdList: List<String>
│   │   ├── title: String
│   │   ├── userId: String
│   │   ├── userImageUrl: String
│   │   ├── userName: String
│   │   ├── viewCount: int
│
├── schedules (컬렉션)
│   ├── {scheduleId} (문서)
│   │   ├── content: String
│   │   ├── day: int
│   │   ├── id: String
│   │   ├── imageUrl: String
│   │   ├── location: String
│   │   ├── order: int
│   │   ├── packageId: String
│   │   ├── time: String
│   │   ├── title: String
│
├── users (컬렉션)
│   ├── {userId} (문서)
│   │   ├── createdAt: Timestamp
│   │   ├── email: String
│   │   ├── id: String
│   │   ├── imageUrl: String
│   │   ├── isGuide: Boolean
│   │   ├── loginType: String
│   │   ├── name: String
│   │   ├── recentPackages: List<String>
│   │   ├── scrapIdList: List<String>
</pre>


## 🗂️ Architecture 구조
<pre>
.
├── core
│   ├── constants
│   │   ├── app_border_radius.dart
│   │   ├── app_colors.dart
│   │   ├── app_icons.dart
│   │   ├── app_shadow.dart
│   │   ├── app_spacing.dart
│   │   ├── app_typography.dart
│   │   ├── auth_providers.dart
│   │   └── env_constants.dart
│   ├── di
│   │   └── injection_container.dart
│   └── firebase
│       └── firebase_storage.dart
├── data
│   ├── data_source
│   │   ├── banner_data_source.dart
│   │   ├── data_source_implement
│   │   │   ├── banner_data_source_impl.dart
│   │   │   ├── package_data_source_impl.dart
│   │   │   ├── schedule_data_source_impl.dart
│   │   │   └── user_data_source_impl.dart
│   │   ├── package_data_source.dart
│   │   ├── schedule_data_source.dart
│   │   └── user_data_source.dart
│   ├── dto
│   │   ├── banner_dto.dart
│   │   ├── package_dto.dart
│   │   ├── schedule_dto.dart
│   │   └── user_dto.dart
│   └── repository
│       ├── banner_repository_impl.dart
│       ├── package_repository_impl.dart
│       ├── schedule_repository_impl.dart
│       └── user_repository_impl.dart
├── domain
│   ├── entity
│   │   ├── banner.dart
│   │   ├── package.dart
│   │   ├── schedule.dart
│   │   ├── survey_response.dart
│   │   ├── travel_recommendation.dart
│   │   ├── travel_schedule.dart
│   │   └── user.dart
│   ├── repository
│   │   ├── banner_repository.dart
│   │   ├── package_repository.dart
│   │   ├── schedule_repository.dart
│   │   └── user_repository.dart
│   ├── services
│   │   └── gemini_service.dart
│   └── usecase
│       ├── add_package_usecase.dart
│       ├── delete_account_usecase.dart
│       ├── fetch_banners_usecase.dart
│       ├── fetch_package_schedule_usecase.dart
│       ├── fetch_packages_usecase.dart
│       ├── fetch_popular_packages_usecase.dart
│       ├── fetch_recent_packages_usecase.dart
│       ├── fetch_user_packages_usecase.dart
│       ├── fetch_user_usecase.dart
│       ├── get_package_usecase.dart
│       ├── get_schedules_usecase.dart
│       ├── sign_in_with_provider_usecase.dart
│       ├── sign_out_usecase.dart
│       └── watch_recent_packages_usecase.dart
├── firebase_options.dart
├── main.dart
├── presentation
│   ├── pages
│   │   ├── auth
│   │   │   └── login_page.dart
│   │   ├── auth_wrapper
│   │   │   └── auth_wrapper.dart
│   │   ├── guide
│   │   │   ├── guide_apply_page.dart
│   │   │   ├── guide_package_list_page.dart
│   │   │   ├── guide_page.dart
│   │   │   ├── package_edit_page
│   │   │   │   ├── edit_list_bottom_sheet.dart
│   │   │   │   ├── edit_schedule_list.dart
│   │   │   │   ├── package_edit_image.dart
│   │   │   │   └── package_edit_page.dart
│   │   │   ├── package_register_page
│   │   │   │   ├── package_register_page.dart
│   │   │   │   └── widgets
│   │   │   │       ├── package_header.dart
│   │   │   │       ├── package_hero_image.dart
│   │   │   │       ├── schedule_list.dart
│   │   │   │       ├── schedule_list_view_model.dart
│   │   │   │       └── widgets
│   │   │   │           ├── bottom_sheet
│   │   │   │           │   ├── header_bottom_sheet.dart
│   │   │   │           │   ├── list_bottom_sheet.dart
│   │   │   │           │   └── widgets
│   │   │   │           │       └── keyword_selection.dart
│   │   │   │           ├── buttons
│   │   │   │           │   ├── add_schedule_button.dart
│   │   │   │           │   ├── day_chip_button.dart
│   │   │   │           │   └── delete_day_button.dart
│   │   │   │           ├── expandable_text.dart
│   │   │   │           ├── package_register_service.dart
│   │   │   │           └── schedule_item.dart
│   │   │   └── widgets
│   │   │       └── guide_info.dart
│   │   ├── guidepackage
│   │   │   ├── filtered_guide_package_page.dart
│   │   │   └── widgets
│   │   │       ├── app_bar.dart
│   │   │       ├── filterd_package_list.dart
│   │   │       └── filters.dart
│   │   ├── guidepackagedetailpage
│   │   │   ├── package_detail_page.dart
│   │   │   └── widgets
│   │   │       ├── detail_day_chip_button.dart
│   │   │       ├── detail_schedule_list.dart
│   │   │       ├── detail_schedule_list_view_model.dart
│   │   │       ├── package_detail_header.dart
│   │   │       ├── package_detail_image.dart
│   │   │       └── schedule_detail_item.dart
│   │   ├── guideprofile
│   │   │   └── guide_profile_page.dart
│   │   ├── login
│   │   │   ├── login_page.dart
│   │   │   ├── login_page_old.dart
│   │   │   ├── login_page_view_model.dart
│   │   │   └── widgets
│   │   │       ├── indicator_circle.dart
│   │   │       └── indicator_oval.dart
│   │   ├── main
│   │   │   ├── main_page.dart
│   │   │   ├── main_page_view_model.dart
│   │   │   └── widgets
│   │   │       ├── main_banner.dart
│   │   │       ├── main_header.dart
│   │   │       ├── main_label.dart
│   │   │       ├── main_popular_packages.dart
│   │   │       └── main_recently_packages.dart
│   │   ├── mypage
│   │   │   └── mypage.dart
│   │   ├── mypagecorrection
│   │   │   └── mypage_correction.dart
│   │   ├── new_trip
│   │   │   └── new_trip_page.dart
│   │   ├── plan_selection
│   │   │   └── plan_selection_page.dart
│   │   ├── recommendation
│   │   │   └── ai_recommendation_page.dart
│   │   ├── schedule
│   │   │   └── ai_schedule_page.dart
│   │   ├── select_travel
│   │   │   ├── select_travel_page.dart
│   │   │   └── widgets
│   │   │       └── travel_type.dart
│   │   ├── stack
│   │   │   ├── stack_page.dart
│   │   │   └── widgets
│   │   │       └── custom_bottom_navigation_bar.dart
│   │   └── survey
│   │       ├── city_selection_page.dart
│   │       ├── survey_page.dart
│   │       └── widgets
│   │           ├── selection_item.dart
│   │           └── survey_step_indicator.dart
│   ├── provider
│   │   ├── banner_provider.dart
│   │   ├── delete_account_usecase_provider.dart
│   │   ├── firebase_providers.dart
│   │   ├── package_provider.dart
│   │   ├── recommendation_provider.dart
│   │   ├── schedule_provider.dart
│   │   ├── survey_provider.dart
│   │   └── user_provider.dart
│   └── widgets
│       ├── buttons
│       │   ├── chip_button.dart
│       │   ├── social_login_button.dart
│       │   └── standard_button.dart
│       ├── custom_checkbox.dart
│       ├── custom_input_field.dart
│       ├── main_container.dart
│       └── package_item.dart
└── theme.dart
</pre>


## 📋 커밋 컨벤션
- `add`: 새로운 파일 및 폴더 추가
- `feat`: 새로운 기능 추가
- `bugfix`: 버그 수정
- `fix`: 코드 수정
- `refactor`: 코드 리팩토링
- `docs`: 문서 작업
- `comment`: 주석
- `move`: 파일/폴더 옮김
- `del`: 기능/파일/폴더 삭제
- `design`: 디자인 작업
- `ToDo`: 해야할 것 mention


## 🛠️ 기술 스택 및 툴
![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white) ![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat&logo=dart&logoColor=white) ![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=flat&logo=firebase&logoColor=black) ![GitHub](https://img.shields.io/badge/GitHub-181717?style=flat&logo=github&logoColor=white) ![Git](https://img.shields.io/badge/Git-F05032?style=flat&logo=git&logoColor=white) ![Figma](https://img.shields.io/badge/Figma-F24E1E?style=flat&logo=figma&logoColor=white) ![Slack](https://img.shields.io/badge/Slack-4A154B?style=flat&logo=slack&logoColor=white)

## 로고
<img src="assets/icons/app_logo/logo_bg_blue_24x24.svg" height="50" alt="wetravel Logo"/> <img src="assets/icons/app_logo/logo_letter.svg" height="50" alt="wetravel Logo"/>
