from django.http import JsonResponse
from django.shortcuts import render
from celery.result import AsyncResult
from .tasks import my_long_task

# View to render the HTML template
def trigger_task_view(request):
    return render(request, 'trigger_task.html')

def trigger_task(request):
    result = my_long_task.delay(5)  # Task will take 5 seconds to complete
    return JsonResponse({'task_id': result.id, 'status': 'Task has been triggered!'})


def check_task_status(request, task_id):
    task_result = AsyncResult(task_id)
    return JsonResponse({'status': task_result.status})

