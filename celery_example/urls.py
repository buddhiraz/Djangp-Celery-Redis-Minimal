from django.contrib import admin
from django.urls import path
from myapp.views import trigger_task_view, trigger_task, check_task_status

urlpatterns = [
    path('admin/', admin.site.urls),
    path('trigger-task/', trigger_task, name='trigger_task'),
    path('check-task-status/<task_id>/', check_task_status, name='check_task_status'),
    path('', trigger_task_view, name='trigger_task_view'),  # Renders the HTML template
]
