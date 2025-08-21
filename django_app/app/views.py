from django.http import HttpResponse

def home(request):
    return HttpResponse("Hello from Django in Docker with PostgreSQL and Nginx! 🚀")
