from django.urls import path
from rest_framework.routers import DefaultRouter

from . import views


router = DefaultRouter()  # DefaultRouter 인스턴스 생성
router.register(
    r"posts", views.PostViewSet
)  # DefaultRouter로 views.PostViewSet를 posts엔드포인트에 등록(CURD URL패턴 생성)

urlpatterns = [
    path(
        "follow/", views.FollowView.as_view(), name="follow"
    ),  # 엔드포인트에 등록하고 팔로우 기능만 수행
    path("feed/", views.FeedView.as_view(), name="feed"),
] + router.urls
