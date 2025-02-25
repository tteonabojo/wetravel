## ✈️ 여행의 가치를 더하는, 나만의 패키지 여행 - **위트(WeTravel)**  
![readme_banner](https://github.com/user-attachments/assets/d1df8478-d2e9-41fc-9081-5c924452cfad)
<div align="center">
  <table border="0" width="100%" align="center">
    <tr>
        <td width="80%" valign="top">
            여행의 가치를 더하는, 나만의 패키지 여행 - <strong>위트(WeTravel)</strong><br>
            AI 기반 여행지 및 여행일정 추천 / 나만의 패키지 작성 앱 <br><br>
            ✈️ 아직 여행지를 못 정했을 때 <br>
            ✈️ 나 혼자 여행일정을 만들기 어려울 때 <br>
            ✈️ 다른 사람들은 여행일정을 어떻게 만드는지 궁금하다면 <br>
            ✈️ 내가 만든 여행일정을 다른 사람들과 공유하고 싶다면 <br><br>
            위트 있는 여행 앱 <strong>'위트'</strong>에서 여행일정을 만들어보세요!
        </td>
        <td width="20%" align="center">
            <img src="https://github.com/user-attachments/assets/5720ff54-2929-4921-adc3-f8a1ee90c7b9" width="250"/>
            <p> 앱스토어 QR</p>
        </td>
    </tr>
  </table>
</div>


## 🎬 실행화면
<div align="center">
  <img src="https://github.com/user-attachments/assets/c9fcd06a-98a6-445f-b64a-b9ebd688659d" width="18%" alt="app_image_1"/>
  <img src="https://github.com/user-attachments/assets/3c36209d-3b56-472b-8a8a-9e0867009af4" width="18%" alt="app_image_2"/>
  <img src="https://github.com/user-attachments/assets/5aac7c11-970c-4ded-882b-79e2404dc0db" width="18%" alt="app_image_3"/>
  <img src="https://github.com/user-attachments/assets/2befc169-5ef6-465e-8c83-4fbecac8962a" width="18%" alt="app_image_4"/>
  <img src="https://github.com/user-attachments/assets/2c55b38a-862e-4ac5-a362-7157c71e6c8c" width="18%" alt="app_image_5"/>
</div>


## 📅 프로젝트 기간
- 2025.1.16 ~ 2025.2.06 (MVP 구현)
- 2025.2.06 ~ 2025.2.26 (추가 기능 구현)
- 2025.2.26 ~ (유저테스트 결과 반영, 코드 리팩토링 및 운영)


## ❓About Team
- 팀명 : 떠나보조
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
- 여행 시작
    - 새로운 여행 시작하기
        - 키워드 설문
        - AI로 도시 추천 받기
        - AI와 일정 함께하기
            - 일정 상세보기
        - 가이드와 일정 함께하기
            - 일정 목록 확인
            - 일정 상세보기
    - 내가 담은 AI 패키지
        - 목록 확인
        - 삭제
    - 내가 담은 가이드 패키지
        - 목록 확인
        - 삭제
- 패키지 작성
    - 패키지 등록
    - 패키지 수정
    - 내 패키지 목록 확인
    - 내 패키지 확인
    - 공개/비공개 전환
- 마이페이지
    - 내 정보 확인 및 수정
        - 프로필 이미지
        - 닉네임
        - 이메일
        - 자기소개
    - 패키지 관리(관리자일 경우)
        - 수정
        - 공개/비공개 전환
        - 삭제
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
│   │   ├── app_animations.dart
│   │   ├── app_border_radius.dart
│   │   ├── app_colors.dart
│   │   ├── app_icons.dart
│   │   ├── app_shadow.dart
│   │   ├── app_spacing.dart
│   │   ├── app_typography.dart
│   │   ├── auth_providers.dart
│   │   ├── env_constants.dart
│   │   ├── firestore_constants.dart
│   │   └── on_boarding_images.dart
│   ├── di
│   │   └── injection_container.dart
│   └── firebase
│       └── firebase_storage.dart
├── data
│   ├── data_source
│   │   ├── banner_data_source.dart
│   │   ├── data_source_implement
│   │   │   ├── banner_data_source_impl.dart
│   │   │   ├── base_firestore_impl.dart
│   │   │   ├── package_data_source_impl.dart
│   │   │   ├── schedule_data_source_impl.dart
│   │   │   ├── scrap_packages_data_source_impl.dart
│   │   │   └── user_data_source_impl.dart
│   │   ├── package_data_source.dart
│   │   ├── schedule_data_source.dart
│   │   ├── scrap_packages_data_source.dart
│   │   └── user_data_source.dart
│   ├── dto
│   │   ├── banner_dto.dart
│   │   ├── package_dto.dart
│   │   ├── schedule_dto.dart
│   │   └── user_dto.dart
│   └── repository
│       ├── banner_repository_impl.dart
│       ├── firebase_storage_repository_impl.dart
│       ├── package_repository_impl.dart
│       ├── schedule_repository_impl.dart
│       ├── survey_repository_impl.dart
│       └── user_repository_impl.dart
├── domain
│   ├── entity
│   │   ├── banner.dart
│   │   ├── package.dart
│   │   ├── schedule.dart
│   │   ├── survey
│   │   │   └── survey_state.dart
│   │   ├── survey_response.dart
│   │   ├── travel_recommendation.dart
│   │   ├── travel_schedule.dart
│   │   └── user.dart
│   ├── repository
│   │   ├── banner_repository.dart
│   │   ├── firebase_storage_repository.dart
│   │   ├── package_repository.dart
│   │   ├── schedule_repository.dart
│   │   ├── survey_repository.dart
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
│       ├── fetch_users_by_ids_usecase.dart
│       ├── get_package_usecase.dart
│       ├── get_schedules_usecase.dart
│       ├── sign_in_with_provider_usecase.dart
│       ├── sign_out_usecase.dart
│       ├── update_user_profile_usecase.dart
│       ├── upload_profile_image_usecase.dart
│       ├── survey
│       │   ├── get_survey_state_usecase.dart
│       │   ├── update_survey_state_usecase.dart
│       │   └── validate_survey_usecase.dart
│       └── watch_recent_packages_usecase.dart
├── firebase_options.dart
├── main.dart
├── presentation
│   ├── pages
│   │   ├── admin
│   │   │   └── admin_page.dart
│   │   ├── guide
│   │   │   ├── guide_package_list_page.dart
│   │   │   ├── package_edit_page
│   │   │   │   ├── edit_list_bottom_sheet.dart
│   │   │   │   ├── edit_schedule_list.dart
│   │   │   │   ├── package_edit_image.dart
│   │   │   │   └── package_edit_page.dart
│   │   │   └── package_register_page
│   │   │       ├── package_register_page.dart
│   │   │       └── widgets
│   │   │           ├── package_header.dart
│   │   │           ├── package_hero_image.dart
│   │   │           ├── schedule_list.dart
│   │   │           ├── schedule_list_view_model.dart
│   │   │           └── widgets
│   │   │               ├── bottom_sheet
│   │   │               │   ├── header_bottom_sheet.dart
│   │   │               │   ├── list_bottom_sheet.dart
│   │   │               │   └── widgets
│   │   │               │       └── keyword_selection.dart
│   │   │               ├── buttons
│   │   │               │   ├── add_schedule_button.dart
│   │   │               │   ├── day_chip_button.dart
│   │   │               │   └── delete_day_button.dart
│   │   │               ├── expandable_text.dart
│   │   │               ├── package_register_service.dart
│   │   │               └── schedule_item.dart
│   │   ├── guide_package
│   │   │   ├── filtered_guide_package_page.dart
│   │   │   └── widgets
│   │   │       ├── filterd_package_list.dart
│   │   │       └── filters.dart
│   │   ├── guide_package_detail_page
│   │   │   ├── package_detail_page.dart
│   │   │   └── widgets
│   │   │       ├── detail_day_chip_button.dart
│   │   │       ├── detail_schedule_list.dart
│   │   │       ├── detail_schedule_list_view_model.dart
│   │   │       ├── package_detail_header.dart
│   │   │       ├── package_detail_image.dart
│   │   │       └── schedule_detail_item.dart
│   │   ├── guide_profile
│   │   │   └── guide_profile_page.dart
│   │   ├── login
│   │   │   ├── login_page.dart
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
│   │   │       ├── main_recently_packages.dart
│   │   │       └── popular_package_list_item.dart
│   │   ├── my_page
│   │   │   ├── my_page.dart
│   │   │   └── widgets
│   │   │       ├── admin_box.dart
│   │   │       ├── inquiry_box.dart
│   │   │       ├── log_out_box.dart
│   │   │       ├── profile_box.dart
│   │   │       └── terms_and_privacy_box.dart
│   │   ├── my_page_correction
│   │   │   ├── mypage_correction_view_model.dart
│   │   │   └── mypage_correction.dart
│   │   ├── new_trip
│   │   │   ├── new_trip_page.dart
│   │   │   └── scrap_package_page.dart
│   │   ├── notice_page
│   │   │   ├── notice_add_page.dart
│   │   │   ├── notice_edit_page.dart
│   │   │   └── noticepage.dart
│   │   ├── on_boarding
│   │   │   ├── on_boarding_page.dart
│   │   │   └── widgets
│   │   │       └── on_boarding_screen.dart
│   │   ├── plan_selection
│   │   │   └── plan_selection_page.dart
│   │   ├── recommendation
│   │   │   ├── ai_recommendation_page.dart
│   │   │   └── widgets
│   │   │       ├── destination_card.dart
│   │   │       ├── destination_image.dart
│   │   │       ├── recommendation_app_bar.dart
│   │   │       ├── recommendation_buttons.dart
│   │   │       └── recommendation_header.dart
│   │   ├── saved_plans
│   │   │   └── saved_plans_page.dart
│   │   ├── schedule
│   │   │   ├── ai_schedule_page.dart
│   │   │   └── widgets
│   │   │       ├── schedule_day_tabs.dart
│   │   │       ├── schedule_header.dart
│   │   │       ├── schedule_item.dart
│   │   │       ├── schedule_list.dart
│   │   │       └── time_picker_bottom_sheet.dart
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
│   │   ├── my_page_correction_provider.dart
│   │   ├── update_user_profile_usecase_provider.dart
│   │   ├── upload_profile_image_usecase_provider.dart
│   │   ├── package_provider.dart
│   │   ├── recommendation_provider.dart
│   │   ├── schedule_actions_provider.dart
│   │   ├── schedule_provider.dart
│   │   ├── survey
│   │   │   └── survey_provider.dart
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
│       ├── package_item.dart
│       └── schedule_card.dart
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
![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white) ![Clean Architecture](https://img.shields.io/badge/Clean%20Architecture-%232F74C0.svg?style=flat) ![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat&logo=dart&logoColor=white) ![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=flat&logo=firebase&logoColor=black) ![GitHub](https://img.shields.io/badge/GitHub-181717?style=flat&logo=github&logoColor=white) ![Git](https://img.shields.io/badge/Git-F05032?style=flat&logo=git&logoColor=white) ![Figma](https://img.shields.io/badge/Figma-F24E1E?style=flat&logo=figma&logoColor=white) ![Slack](https://img.shields.io/badge/Slack-4A154B?style=flat&logo=slack&logoColor=white)

## 로고
<img src="assets/icons/app_logo/logo_bg_blue_24x24.svg" height="50" alt="wetravel Logo"/> <img src="assets/icons/app_logo/logo_letter.svg" height="50" alt="wetravel Text Logo"/>
