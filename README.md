# Lesson 9

## Опис проєкту
Цей проєкт демонструє розгортання Kubernetes-кластера через Terraform, налаштування ECR, Jenkins pipeline для CI/CD та управління додатками через Argo CD.

---

## 1. Terraform

### 1. Ініціалізація та застосування інфраструктури:

```bash
terraform init
terraform plan
terraform apply
```
### 2. Перевірка ресурсів:
```bash
terraform output
kubectl get ns
kubectl get nodes
kubectl get svc -n django
```

## 2. Jenkins
- URL сервісу:
```bash
kubectl get svc -n jenkins
```
- Jenkinsfile збирає Docker-образ, пушить його в ECR та оновлює Helm-чарт.
- Перевірка job: **Jenkins UI → Job → Console Output.**

## 3. Argo CD
- Порт-форвард для доступу до UI:
```bash
kubectl port-forward svc/argo-cd-argocd-server -n argocd 8080:443
```
- Відкрити у браузері: **https://localhost:8080**
- Логін:**admin**
- Пароль:
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```
- Додати Application:
  - Репозиторій: GitHub
  - Path: **lesson-5/charts/django-app**
  - Branch: **lesson-9**
- Перевірка стану: **Application Synced / Healthy**, podи та service працюють.