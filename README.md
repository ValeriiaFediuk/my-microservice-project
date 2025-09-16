# Final DevOps Project

## Технічні вимоги

**Інфраструктура:** AWS з використанням Terraform  
**Компоненти:** VPC, EKS, RDS, ECR, Jenkins, Argo CD, Prometheus, Grafana  

---

## Етапи виконання

### 1. Підготовка середовища
- Ініціалізувати Terraform:
```bash
terraform init
````

* Перевірити всі необхідні змінні та параметри.

### 2. Розгортання інфраструктури

* Виконати команду розгортання:

```bash
terraform apply
```

* Перевірити стан ресурсів:

```bash
kubectl get all -n jenkins
kubectl get all -n argocd
kubectl get all -n monitoring
```

### 3. Перевірка доступності сервісів

**Jenkins:**

```bash
kubectl port-forward svc/jenkins 8080:80 -n jenkins
```

Відкрити в браузері: `http://localhost:8080`

**Argo CD:**

```bash
kubectl port-forward svc/argo-cd-argocd-server 8081:443 -n argocd
```

Відкрити в браузері: `https://localhost:8081`

**Grafana:**

```bash
kubectl port-forward svc/grafana 3000:80 -n monitoring
```

Відкрити в браузері: `http://localhost:3000`

---

### 4. Моніторинг та перевірка метрик

* Відкрити Grafana Dashboard та перевірити стан метрик.
* Підключити Prometheus як джерело даних для Grafana.

---

### 5. Після перевірки обов'язково видаляємо створені ресурси:

```bash
terraform destroy
```
---