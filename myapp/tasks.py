from celery import shared_task
import time

@shared_task
def my_long_task(seconds):
    time.sleep(seconds)  # Simulate a long-running task
    print('TIME TAKEN TO COMPLETE THE TASK ------>',seconds)
    return f'Task completed in {seconds} seconds'
