# DevOps Questions 101

A comprehensive collection of real-world DevOps interview questions and scenarios covering Linux, Docker, Kubernetes, networking, security, and cloud operations. This repository is designed to help DevOps engineers, SREs, and cloud professionals evaluate their knowledge and prepare for technical interviews.

## Table of Contents

- [About](#about)
- [Repository Structure](#repository-structure)
- [How to Use This Repository](#how-to-use-this-repository)
- [Difficulty Levels](#difficulty-levels)
- [Question Categories](#question-categories)
- [Learning Path](#learning-path)
- [Contributing](#contributing)

---

## About

This repository contains curated DevOps questions as part of the **"DevOps Questions 101"** series. Each question is:

- **Real-world focused:** Based on actual production scenarios
- **Interview-ready:** Commonly asked in DevOps/SRE/Cloud interviews
- **Comprehensive:** Includes follow-up questions and edge cases
- **Practical:** Accompanied by code examples and YAML configurations

**Target Audience:**
- DevOps Engineers (Mid to Senior level)
- Site Reliability Engineers (SRE)
- Kubernetes/Cloud Platform Engineers
- Interview candidates preparing for DevOps roles

---

## Repository Structure

```
devops-questions-101/
├── README.md                      # This file
├── only_questions.txt             # Batch 1: Core DevOps questions (8 questions)
├── question_bank_batch7           # Batch 7: Categorized questions (30 questions)
├── question_list.txt              # Quick reference: Kubernetes networking
├── lab_k8s_questions.txt          # Lab-based questions (cost optimization)
├── solutions.md                   # Detailed solutions with examples
├── devops_lab_overview.md         # Lab setup and overview
│
├── solution2.sh                   # Shell script: Signal handling example
├── solution5.yaml                 # K8s: Dependency management with init containers
├── solution7.service              # Systemd: Resource management example
│
├── deployment.yaml                # Sample Kubernetes deployments
├── deployment2.yaml
├── hard_affinity_sample_app.yaml  # Node affinity examples
├── soft_affinity_sample_app.yaml
│
└── k8s_cost_saving/               # Lab: OpenCost and node affinity
    └── README.md
```

---

## How to Use This Repository

### For Self-Assessment

1. **Start with questions only** - Don't peek at solutions!
   - Read `only_questions.txt` or `question_bank_batch7`
   - Try to answer each question thoroughly
   - Write down your answers or explain them out loud

2. **Review your answers**
   - Compare your responses with `solutions.md`
   - Identify knowledge gaps
   - Note areas for deeper study

3. **Practice with labs**
   - Follow exercises in `lab_k8s_questions.txt`
   - Implement YAML examples in your own cluster
   - Experiment with the provided configurations

### For Interview Preparation

1. **Focus on difficulty levels** matching your target role
2. **Practice explaining concepts** clearly and concisely
3. **Prepare real-world examples** from your own experience
4. **Review follow-up questions** - interviewers love these!
5. **Time yourself** - aim to answer within the suggested time estimates

### For Learning

1. **Follow the learning path** (see below)
2. **Implement the examples** in your own environment
3. **Modify configurations** to understand behavior
4. **Research the references** provided in solutions
5. **Build upon the labs** with your own scenarios

---

## Difficulty Levels

| Level | Description | Expected Experience |
|-------|-------------|---------------------|
| **Basic** | Fundamental concepts, definitions, basic usage | 0-2 years DevOps experience |
| **Intermediate** | Practical implementation, troubleshooting, best practices | 2-4 years DevOps experience |
| **Intermediate-Advanced** | Complex scenarios, trade-off analysis, architecture decisions | 3-5 years DevOps experience |
| **Advanced** | Production-grade design, multi-layer debugging, optimization | 4+ years DevOps experience |

**Time Estimates:**
- Basic: 5-15 minutes per question
- Intermediate: 15-25 minutes per question
- Advanced: 25-40 minutes per question

---

## Question Categories

### Batch 1 (only_questions.txt) - Core Topics
1. Linux Process Priority and Resource Management
2. Linux Signals and Inter-Process Communication
3. Kubernetes Probes Implementation
4. Docker IPC and Socket Communication
5. Kubernetes Application Dependency Management
6. Network Switching and Kubernetes Networking
7. Multi-Tier Application Resource Planning
8. Kubernetes Platform Update Strategy

### Batch 7 (question_bank_batch7) - Comprehensive Coverage

| Category | Question Count | Topics |
|----------|----------------|--------|
| **Kubernetes Architecture** | 5 | Storage, resources, capacity planning, node affinity |
| **Security & Compliance** | 8 | RBAC, pod security, certificates, mTLS, policies |
| **Troubleshooting** | 3 | Debugging, systematic approaches, pod lifecycle |
| **Deployments & Lifecycle** | 7 | Strategies, StatefulSets, probes, backups |
| **Networking** | 3 | Network policies, load balancers, service mesh |
| **CI/CD & Automation** | 2 | Policy enforcement, drift detection |
| **Docker Concepts** | 1 | Image optimization, build performance |
| **Project Insights** | 4 | Real-world setup, CRDs, node operations |

---

## Learning Path

### Beginner to Intermediate

**Week 1-2: Foundations**
- Question 1: Linux process management
- Question 2: Linux signals
- Question 4: Docker architecture
- Question 6: Networking basics

**Week 3-4: Kubernetes Core**
- Question 3: Kubernetes probes
- Batch 7: Q1-Q5 (Architecture and Resources)
- Batch 7: Q19-Q21 (Deployments and Lifecycle)

**Week 5-6: Production Skills**
- Question 7: Resource planning
- Question 8: Platform updates
- Batch 7: Q14-Q16 (Troubleshooting)

### Intermediate to Advanced

**Week 1-2: Security & Compliance**
- Batch 7: Q6-Q13 (All security questions)
- Focus on RBAC, pod security, and certificates

**Week 3-4: Advanced Kubernetes**
- Question 5: Application dependencies
- Batch 7: Q17-Q18 (Deployment strategies, StatefulSets)
- Batch 7: Q22-Q24 (Advanced networking)

**Week 5-6: Architecture & Optimization**
- Batch 7: Q4 (Capacity planning)
- Batch 7: Q25-Q27 (CI/CD, automation, optimization)
- Lab: K8s cost saving with OpenCost

---

## Key Topics Covered

- **Linux:** Process management, signals, IPC, systemd
- **Docker:** Architecture, socket communication, image optimization
- **Kubernetes:**
  - Core: Pods, Deployments, Services, Probes
  - Storage: PV, PVC, StorageClass
  - Networking: Network policies, kube-proxy, service mesh
  - Security: RBAC, pod security, certificates, mTLS
  - Operations: Upgrades, backups, troubleshooting
  - Advanced: StatefulSets, init containers, node affinity, CRDs
- **Cloud & Infrastructure:** Resource planning, cost optimization, capacity planning
- **CI/CD:** GitOps, policy enforcement, drift detection
- **Troubleshooting:** Systematic debugging, multi-layer analysis

---

## Best Practices for Using This Repository

1. **Don't rush** - Take time to understand each concept deeply
2. **Implement, don't just read** - Hands-on practice is essential
3. **Relate to your experience** - Connect questions to your work
4. **Research further** - Use provided references to deepen knowledge
5. **Practice explaining** - Teach concepts to reinforce understanding
6. **Track your progress** - Note which questions you struggled with
7. **Revisit periodically** - Review questions after gaining more experience

---

## Additional Resources

- **Code Examples:** All YAML files and shell scripts in this repo are ready to use
- **Solutions:** Detailed explanations in `solutions.md`
- **Labs:** Hands-on exercises in `k8s_cost_saving/` and `lab_k8s_questions.txt`
- **External Links:** Referenced throughout solutions for deeper learning

---

## Contributing

Found an error? Have a suggestion? Want to add more questions?

1. Open an issue describing the problem or suggestion
2. Submit a pull request with improvements
3. Share your own production scenarios (anonymized)

---

## Recommended Study Order

**First-time learners:**
1. Read `only_questions.txt` and attempt answers
2. Check your answers against `solutions.md`
3. Implement the YAML examples in a test cluster
4. Move to `question_bank_batch7` by category
5. Complete the labs for hands-on practice

**Interview preparation:**
1. Focus on questions matching your target level
2. Practice answering within time limits
3. Prepare personal examples for each topic
4. Review follow-up questions thoroughly
5. Test your knowledge with the labs

**Continuous learning:**
1. Revisit questions periodically
2. Try to improve upon the provided solutions
3. Explore the references and dive deeper
4. Share learnings with your team
5. Apply concepts in your daily work

---

## License

This repository is for educational purposes. Feel free to use and share for learning and interview preparation.

---

**Happy Learning!**

Remember: The goal isn't just to memorize answers, but to **understand the underlying concepts** and **apply them to real-world scenarios**.
