DjangoApp 배포 : be-lb-staging-19609149-0dfe808d8688.kr.lb.naverncp.com  

라이브러리 버전  
Django 4.2.3  
postgresql 13  
gunicorn 21.2.0  
psycopg2-binary 2.9.7  
djangorestframework 3.14.0  
drf-spectacular 0.26.4  
python-dotenv 0.19.1  
  
1. 백엔드 DB 설계
Django 모델을 사용하여 게시글과 유저를 생성합니다.
Django의 ORM을 사용하여 모델 간의 관계를 정의하고 데이터베이스를 마이그레이션합니다.
2. 백엔드 API 개발
Django REST framework를 사용하여 필요한 API 엔드포인트를 개발합니다.
사용자, 게시글과 관련된 API를 구현합니다.
API에 대한 권한과 인증을 설정하여 사용자만이 해당 기능을 사용할 수 있도록 합니다.
3. 더미데이터 추가
5명 이상의 사용자와 각 사용자당 3개 이상의 게시글을 생성합니다.
4. 테스트 코드 작성
Django의 테스트 프레임워크를 사용하여 API 엔드포인트에 대한 테스트 코드를 작성합니다.
정상 케이스와 비정상 케이스에 대한 테스트를 작성합니다. (ex: 권한이 없는 사용자의 접근 시도)
각 테스트 케이스를 실행하여 예상대로 작동하는지 확인합니다.
5. 배포
Django 프로젝트를 NCP 클라우드 서비스에 배포합니다.
웹 서버 Gunicorn, 리버스 프록시 Nginx를 설정하여 프로덕션 환경에 배포합니다.
서버에서 환경 변수를 설정하여 중요한 정보를 안전하게 관리합니다.
6. CICD Pipeline 작성
CICD 확인 : https://github.com/bainaryho/DRF_SNS
GitHub Actions CI/CD 도구를 사용하여 CI/CD 파이프라인을 설정합니다.
코드가 GitHub 리포지토리에 푸시될 때 테스트를 자동으로 실행하도록 설정합니다.
테스트가 성공하면 자동으로 서버에 새로운 버전을 배포하도록 설정합니다.
7. Terrafrom을 사용한 모듈화로 지속적인 배포와 관리 진행(infra 이하)
8. k8s로 배포