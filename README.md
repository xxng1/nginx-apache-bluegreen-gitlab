# nginx-apache-bluegreen-gitlab

Edge Nginx(8081) 앞단에서 Blue/Green(app-blue/app-green) 두 슬롯을 상시 구동하고,

심볼릭 링크 교체 + `nginx -s reload`로 즉시 전환하는 무중단 배포 템플릿.


## CI/CD (GitLab + Runner)

- **Self-hosted GitLab(Omnibus)** + **GitLab Runner(Shell executor)** 사용
- **태그 푸시**로 파이프라인 자동 실행  
  `bootstrap → deploy → verify → switch → (delayed) cleanup`
- **Runner 태그**: `.gitlab-ci.yml`의 `tags: [bluegreen]` ↔ 러너 등록 시 `bluegreen`로 일치
