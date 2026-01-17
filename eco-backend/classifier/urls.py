from django.urls import path
from .views import ImageClassificationView, ModelListView, EnsembleClassificationView

urlpatterns = [
    path('classify/', ImageClassificationView.as_view(), name='classify-image'),
    path('classify/ensemble/', EnsembleClassificationView.as_view(), name='ensemble-classify'),
    path('models/', ModelListView.as_view(), name='list-models'),
]
