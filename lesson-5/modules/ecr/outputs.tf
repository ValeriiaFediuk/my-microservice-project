output "repository_url" {
  description = "URL створеного ECR репозиторію"
  value       = aws_ecr_repository.this.repository_url
}
