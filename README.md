# coachmod3-12Apr25
# Continuous deployment





## Activity Overview
- In this activity, you would be required to create your infra using Terraform, followed by deploying your sample app (Covered in Lessons 3.3 & 3.4) using Github Actions to ECS & ECR respectively.
- Also think through the following on how you would segregate your git repository / repositories to achieve this.
- Below are some examples: 
  - Mono repo: Application & IaC goes into a single repository.
  - 2 repositories :
    - 1 repository to store your IaC and manage your IaC deployment.
    - Another repository to manage your application code & deployment.

- Note that each of the strategies above, may result in a slightly different GitHub action workflow & directory structure.
