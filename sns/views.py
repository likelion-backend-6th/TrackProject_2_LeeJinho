from rest_framework import viewsets, views

from .models import Post, Follow
from .serializers import PostSerializer, FollowSerializer
from rest_framework import status
from rest_framework.response import Response


class PostViewSet(viewsets.ModelViewSet):
    queryset = Post.objects.all()
    serializer_class = PostSerializer  # PostSerializer로 직렬화(API 엔드포인트를 통해 전송가능)

    def get_queryset(self):
        if self.action == "list":
            return Post.objects.filter(user=self.request.user)  # 요청한 사용자의 게시물만 반환
        return super().get_queryset()

    def update(self, request, *args, **kwargs):
        if request.user != self.get_object().user:  # 요청한 사용자가 게시물의 소유자인지 확인
            return Response(status=status.HTTP_403_FORBIDDEN)

        return super().update(request, *args, **kwargs)

    def partial_update(self, request, *args, **kwargs):
        if request.user != self.get_object().user:
            return Response(status=status.HTTP_403_FORBIDDEN)

        return super().partial_update(request, *args, **kwargs)

    def destroy(self, request, *args, **kwargs):
        if request.user != self.get_object().user:
            return Response(status=status.HTTP_403_FORBIDDEN)

        return super().destroy(request, *args, **kwargs)


class FollowView(views.APIView):
    def post(self, request, format=None):
        serializer = FollowSerializer(data=request.data)
        if serializer.is_valid():  # 데이터 유효성 검사
            following = serializer.validated_data["following"]  # following 데이터 나타냄
            qs = Follow.objects.filter(follower=request.user, following=following)
            if qs.exists():
                # 이미 관계가 있으니 unfollow
                qs.delete()
                return Response(status=status.HTTP_204_NO_CONTENT)

            else:
                # 관계가 없으니 follow
                Follow.objects.create(
                    follower=request.user,
                    following=following,
                )
                return Response(status=status.HTTP_201_CREATED)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class FeedView(views.APIView):
    def get(self, request, format=None):
        # get all posts from users that the user is following
        following_ids = Follow.objects.filter(follower=request.user).values_list(
            "following", flat=True
        )
        posts = Post.objects.filter(user__in=following_ids)
        serializer = PostSerializer(posts, many=True)
        return Response(serializer.data)
