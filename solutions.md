## Question 1: Linux Process Priority and Resource Management
**Topic:** Linux Fundamentals, Resource Management
**Difficulty:** Intermediate

**Question:** In Linux, the Nice command is used to prioritize the execution of processes.

**Part a.** Explain how nice values work and where you would use them in production.
**Part b.** How would you achieve similar workload prioritization in Docker or Kubernetes?

---

### Solution

**Part a - Linux Nice Command:**

In Linux, the priority value for a process ranges from **-20 to 19**, with:
- **-20** = highest priority
- **19** = lowest priority
- **Higher value = Lower priority**

**Commands:**
```bash
# Set initial priority
nice -n 10 my_program

# Change priority of running process
renice -n 5 -p <PID>
```

**Real-world use case:** In my project, I used nice for long-running background processes that perform cleanup jobs, log aggregation, or batch processing. These tasks should not interfere with critical user-facing services.

**Part b - Docker and Kubernetes:**

In Docker and Kubernetes, priority is not expressed in relative terms like Linux nice values. There's no guarantee of strict prioritization, but you can influence resource allocation:

**Docker:**
```bash
# CPU shares (relative weight)
docker run --cpu-shares=512 my_app

# CPU quota/period
docker run --cpu-quota=50000 --cpu-period=100000 my_app
```

**Kubernetes:**
```yaml
resources:
  requests:
    cpu: "100m"
    memory: "128Mi"
  limits:
    cpu: "500m"
    memory: "512Mi"
```

**Key Differences:**
- No exact "-20 to 19" equivalent in containers
- Subject to node capacity and scheduler decisions
- Use QoS classes (Guaranteed, Burstable, BestEffort) for priority
- For strict prioritization, use PriorityClass in Kubernetes

---

## Question 2: Linux Signals and Inter-Process Communication
**Topic:** Linux Fundamentals, Docker Architecture, Kubernetes
**Difficulty:** Intermediate

**Question:** What do you know about Linux signals? How does Inter-Process Communication (IPC) happen using signals?

**Follow-up:** How is signal handling related to Kubernetes pod status and Docker entry points?

---

### Solution

**Linux Signals Overview:**

Signals are interrupt commands that Linux processes can send to one another for Inter-Process Communication (IPC). We don't create new signals; we use the existing list that Linux provides (64 standard signals).

**View available signals:**
```bash
kill -l
```

**Common signals:**
- **SIGTERM (15):** Graceful termination request
- **SIGKILL (9):** Force kill (cannot be caught or ignored)
- **SIGINT (2):** Interrupt from keyboard (Ctrl+C)
- **SIGHUP (1):** Hangup signal
- **SIGUSR1/SIGUSR2:** User-defined signals

**Example shell script for signal handling:**
See `solution2.sh` for a practical example of signal trapping.

**Relationship to Docker and Kubernetes:**

All container and Docker lifecycles are managed using signals:

**Docker:**
- When you run `docker stop`, Docker sends **SIGTERM** to the main process
- After a grace period (default 10 seconds), Docker sends **SIGKILL** if the process hasn't exited
- The Docker daemon uses signals to manage container lifecycles and perform cleanup
- Entry point processes can trap signals for graceful shutdowns:

```bash
#!/bin/bash
trap 'echo "Shutting down gracefully..."; cleanup; exit 0' SIGTERM SIGINT
```

**Kubernetes:**
- When a pod is terminated, Kubernetes sends **SIGTERM** to containers
- `terminationGracePeriodSeconds` defines how long to wait before sending **SIGKILL**
- Pod status changes are driven by process exit codes and signal handling
- Proper signal handling ensures graceful shutdowns and prevents data loss

**Best Practices:**
- Always handle SIGTERM in your application for graceful shutdowns
- Use `terminationGracePeriodSeconds` appropriately in pod specs
- Implement cleanup logic in signal handlers (close connections, flush buffers, save state)

**Reference:** https://faculty.cs.niu.edu/~hutchins/csci480/signals.htm


---

## Question 3: Kubernetes Probes Implementation
**Topic:** Kubernetes, Application Health Management
**Difficulty:** Intermediate

**Question:** What are the Kubernetes probes (startup, readiness, liveness) that you have used in your deployments? Explain their importance and prerequisites for each one.

**Follow-up:**
1. What check mechanisms have you used apart from httpGet?
2. Why doesn't Kubernetes mandate default probes? Why are startup, readiness, and liveness all optional?

---

### Solution

**Three Types of Kubernetes Probes:**

**1. Liveness Probe**
- **Purpose:** Determines if the container is running properly
- **Action on failure:** Kubelet kills and restarts the container
- **Use case:** Detect deadlocks, infinite loops, or application crashes
- **Example:** Health check endpoint that verifies application is responsive

**2. Readiness Probe**
- **Purpose:** Determines if the container is ready to accept traffic
- **Action on failure:** Pod removed from Service endpoints (no traffic sent)
- **Use case:** Application startup, dependency checks, temporary unavailability
- **Example:** Database connection check, cache warmup validation

**3. Startup Probe**
- **Purpose:** Determines if the application has started successfully
- **Action on failure:** Kubelet kills and restarts the container
- **Use case:** Slow-starting applications (legacy apps, large initialization)
- **Key benefit:** Prevents liveness probe from interfering during long startup times

**Check Mechanisms:**

**a) httpGet (Most Common):**
```yaml
livenessProbe:
  httpGet:
    path: /healthz
    port: 8080
  initialDelaySeconds: 30
  periodSeconds: 10
```

**b) tcpSocket:**
```yaml
readinessProbe:
  tcpSocket:
    port: 3306
  initialDelaySeconds: 5
  periodSeconds: 10
```
Use for: Databases, message queues, or services without HTTP endpoints

**c) exec:**
```yaml
livenessProbe:
  exec:
    command:
    - cat
    - /tmp/healthy
  initialDelaySeconds: 5
  periodSeconds: 5
```
Use for: Custom health checks, file-based checks, complex validation logic

**Why Probes Are Optional:**

Probes are very useful, but they have important trade-offs:

**1. Resource Overhead:**
- Probes are processes that consume CPU/memory/network
- Example: A probe running every 10 seconds for a 10-minute batch job could consume more resources than the job itself
- For short-lived pods, probes may be unnecessary overhead

**2. Flexibility:**
- Not all applications have the same requirements
- Simple applications may not need health checks
- Batch jobs, cronjobs, and init containers often don't benefit from probes
- Mandating default probes would limit architectural flexibility

**3. Application Design:**
- Some applications don't have meaningful health endpoints
- Legacy applications may not support proper health checks
- Forcing defaults could cause false positives/negatives

**Best Practices:**
- Use liveness probes for long-running services (not batch jobs)
- Always use readiness probes for services behind a load balancer
- Use startup probes only for applications with slow initialization (initialDelaySeconds > 60s)
- Configure appropriate timeouts and thresholds to avoid false restarts

**Detailed Reference:** https://github.com/syednadeembe/project_sessions/tree/main/session-design/deployment

---

## Question 4: Docker IPC and Socket Communication
**Topic:** Docker Architecture, Inter-Process Communication
**Difficulty:** Intermediate

**Question:** Building on IPC concepts from Question 2, explain how inter-process communication workflow works in Docker Architecture.

**Follow-up:**
1. What is the role of the docker.sock file?
2. How does the Docker socket work?

---

### Solution

**Docker IPC Architecture:**

Docker provides several IPC (Inter-Process Communication) mechanisms, with the most common being the **docker.sock** Unix socket.

**1. Unix Socket (docker.sock):**

The Docker daemon exposes a Unix socket file that clients use to communicate with the Docker daemon over the Unix socket protocol.

**Location:** `/var/run/docker.sock` (on Linux systems)

**How it works:**
```
Docker CLI → Unix Socket (/var/run/docker.sock) → Docker Daemon (dockerd) → Container Runtime
```

**Example workflow:**
1. You run: `docker ps`
2. Docker CLI connects to `/var/run/docker.sock`
3. CLI sends HTTP request over the Unix socket
4. Docker daemon (dockerd) receives request via the socket
5. Daemon processes request and returns response
6. CLI displays formatted output

**Security Considerations:**
- Access to docker.sock = root access to the host
- Never mount docker.sock into untrusted containers
- Use Docker socket proxy for limited access
- Consider rootless Docker for improved security

**Example - Mounting docker.sock (use with caution):**
```bash
docker run -v /var/run/docker.sock:/var/run/docker.sock my-container
```
This gives the container ability to manage other containers (used by CI/CD tools, monitoring agents).

**2. Other IPC Mechanisms:**

**a) Shared Volumes:**
```bash
# Container 1 writes data
docker run -v shared-data:/data writer-app

# Container 2 reads data
docker run -v shared-data:/data reader-app
```

**b) Network Communication:**
```bash
# Create custom network
docker network create my-network

# Containers can communicate via container names
docker run --network my-network --name app1 my-app
docker run --network my-network --name app2 my-app

# app2 can reach app1 at: http://app1:port
```

**c) Docker API over TCP (remote):**
```bash
# Expose Docker API (insecure - use TLS in production)
dockerd -H tcp://0.0.0.0:2375

# Connect remotely
docker -H tcp://remote-host:2375 ps
```

**Best Practices:**
- Use Unix socket for local communication (faster, more secure)
- Use Docker networks for container-to-container communication
- Implement TLS for remote Docker API access
- Limit socket access using appropriate file permissions
- Consider using shared volumes only for data, not for IPC

---

## Question 5: Kubernetes Application Dependency Management
**Topic:** Kubernetes, Application Architecture, HA Design
**Difficulty:** Advanced

**Question:** Design a Kubernetes deployment setup where you have 3 applications that need to run in HA with strict dependencies:
- Application 1 should always start first
- Application 2 should always start after Application 1 is Ready
- Application 3 should always start after Application 2 is Ready

**Follow-up:**
1. How will you design a check mechanism so that restarts and scheduler reschedules don't break the dependency requirements?
2. How will you incorporate this with CD tools in a GitOps-driven environment?

---

### Solution

**Key Principle:** Don't over-complicate or over-engineer the solution. Use Kubernetes primitives effectively.

**Approach: Init Containers + Readiness Probes**

**Architecture:**
```yaml
# App 1: No dependencies, starts first
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app1
spec:
  replicas: 3
  template:
    spec:
      containers:
      - name: app1
        image: app1:latest
        readinessProbe:
          httpGet:
            path: /ready
            port: 8080
          initialDelaySeconds: 5
          periodSeconds: 5
---
# App 2: Depends on App 1
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app2
spec:
  replicas: 3
  template:
    spec:
      initContainers:
      - name: wait-for-app1
        image: busybox:latest
        command: ['sh', '-c', 'until nslookup app1.default.svc.cluster.local; do echo waiting for app1; sleep 2; done']
      containers:
      - name: app2
        image: app2:latest
        readinessProbe:
          httpGet:
            path: /ready
            port: 8080
---
# App 3: Depends on App 2
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app3
spec:
  replicas: 3
  template:
    spec:
      initContainers:
      - name: wait-for-app2
        image: busybox:latest
        command: ['sh', '-c', 'until nslookup app2.default.svc.cluster.local; do echo waiting for app2; sleep 2; done']
      containers:
      - name: app3
        image: app3:latest
```

**How it handles restarts and reschedules:**

1. **Init containers** ensure dependencies are met before main container starts
2. **Readiness probes** ensure Service only routes traffic when app is truly ready
3. **Service discovery** via DNS ensures dependencies are checked dynamically
4. **Automatic retry** - init containers will keep retrying until dependency is available

**GitOps Integration:**

**Structure your Git repository:**
```
manifests/
├── 01-app1/
│   ├── deployment.yaml
│   └── service.yaml
├── 02-app2/
│   ├── deployment.yaml
│   └── service.yaml
└── 03-app3/
    ├── deployment.yaml
    └── service.yaml
```

**ArgoCD/FluxCD approach:**
```yaml
# Using ArgoCD Application sync waves
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: app1
  annotations:
    argocd.argoproj.io/sync-wave: "1"
---
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: app2
  annotations:
    argocd.argoproj.io/sync-wave: "2"
---
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: app3
  annotations:
    argocd.argoproj.io/sync-wave: "3"
```

**Alternative: Health Checks in Init Containers**
```yaml
initContainers:
- name: wait-for-app1-ready
  image: curlimages/curl:latest
  command:
  - sh
  - -c
  - |
    until curl -f http://app1:8080/ready; do
      echo "Waiting for app1 to be ready..."
      sleep 5
    done
```

**Best Practices:**
- Keep init containers simple and lightweight
- Use appropriate timeout values to avoid infinite waits
- Implement proper readiness probes in all applications
- Test failure scenarios (app restarts, node failures, reschedules)
- Use GitOps sync waves for ordered deployments
- Document dependencies clearly in your repository

**Reference Implementation:** See `solution5.yaml` for complete example

**Additional Reading:** https://www.linkedin.com/feed/update/urn:li:activity:7171006364901687296

---

## Question 6: Network Switching and Kubernetes Networking
**Topic:** Networking Fundamentals, Kubernetes Networking
**Difficulty:** Intermediate-Advanced

**Question:** Please explain your understanding of multilayer switches and what Layer 4 LAN switching does.

**Follow-up:** Which component of Kubernetes uses this technology and how?

---

### Solution

**Multilayer Switches:**

Multilayer switches are software-based or hardware-based switches that operate at multiple layers of the OSI model. They provide both routing and switching functionalities, combining capabilities typically found in separate switches and routers.

**Layer 4 (Transport Layer) Switching:**

Layer 4 LAN switching involves routing/switching traffic based on information found at **Layer 4 of the OSI model** - the transport layer. This includes:
- **Protocol:** TCP or UDP
- **Source Port**
- **Destination Port**
- **TCP Flags and State**

**OSI Layer 4 Information:**
```
Layer 7: Application (HTTP, DNS, FTP)
Layer 6: Presentation (SSL/TLS encryption)
Layer 5: Session (session management)
Layer 4: Transport (TCP/UDP, ports) ← Layer 4 switching operates here
Layer 3: Network (IP addresses, routing)
Layer 2: Data Link (MAC addresses, switches)
Layer 1: Physical (cables, signals)
```

**Kubernetes Component: kube-proxy**

**kube-proxy** is responsible for implementing Layer 4 load balancing to distribute incoming traffic to Kubernetes Services across multiple pods.

**How kube-proxy works:**

**1. iptables mode (most common):**
```bash
# kube-proxy creates iptables rules on each node
# Example rule for a Service:
-A KUBE-SERVICES -d 10.96.0.1/32 -p tcp -m tcp --dport 80 \
   -j KUBE-SVC-XXXXXXXXXXX

# Load balances to backend pods:
-A KUBE-SVC-XXXXXXXXXXX -m statistic --mode random --probability 0.33 \
   -j KUBE-SEP-POD1
-A KUBE-SVC-XXXXXXXXXXX -m statistic --mode random --probability 0.50 \
   -j KUBE-SEP-POD2
-A KUBE-SVC-XXXXXXXXXXX -j KUBE-SEP-POD3
```

**2. IPVS mode (more efficient for large clusters):**
- Uses Linux Virtual Server for better performance
- Supports multiple load-balancing algorithms (round-robin, least-connection, etc.)
- More efficient than iptables for large numbers of Services

**3. userspace mode (legacy, rarely used)**

**Key Points:**
- All iptables rules on nodes are managed by kube-proxy
- kube-proxy watches the Kubernetes API for Service/Endpoint changes
- Traffic is distributed based on Layer 4 information (IP + Port)
- No application-layer (Layer 7) awareness in kube-proxy

**Layer 4 vs Layer 7:**
- **Layer 4:** TCP/UDP port-based routing (kube-proxy, Service)
- **Layer 7:** HTTP path/host-based routing (Ingress Controller, Service Mesh)

**References:**
- [HAProxy Layer 4 and Layer 7 Proxy Mode](https://www.haproxy.com/blog/layer-4-and-layer-7-proxy-mode)
- [Kubernetes Networking Fundamentals](https://opensource.com/article/22/6/kubernetes-networking-fundamentals)

---

## Question 7: Multi-Tier Application Resource Planning
**Topic:** Resource Management, Architecture Design, Cost Optimization
**Difficulty:** Advanced

**Question:** You have 3 applications that make a complete solution:
- **UI application:** 100MB memory, 1 CPU
- **Business application:** 200MB memory, 2 CPU
- **Database application:** 300MB memory, 3 CPU
- **Resource ratio:** 1:2:3 for every 1000 users

How will you design and deploy the solution on the following infrastructures while maintaining resource ratios?
1. On Virtual Machines (VMs)
2. On Docker setup
3. On Kubernetes setup

**Follow-up:** Design the most optimal solution, keeping production cost as priority.

---

### Solution

**1. Virtual Machine Approach:**

**Option A: Separate VMs**
```
VM1: UI App      - 1 vCPU, 100MB RAM
VM2: Business    - 2 vCPU, 200MB RAM
VM3: Database    - 3 vCPU, 300MB RAM
```
**Pros:** Complete isolation, independent scaling
**Cons:** Higher cost, resource waste, complex management

**Option B: Single VM with systemd resource control**
```bash
# Use systemd to manage resources at Linux level
# See solution7.service for implementation

# UI service
[Service]
CPUShares=1024
MemoryLimit=100M

# Business service
[Service]
CPUShares=2048
MemoryLimit=200M

# Database service
[Service]
CPUShares=3072
MemoryLimit=300M
```
**Pros:** Most cost-effective, efficient resource use
**Cons:** No auto-scaling, single point of failure, not cloud-native

**Option C: Single VM with Docker**
```bash
# Install Docker and run containers with resource limits
docker run -d --cpus="1" --memory="100m" ui-app
docker run -d --cpus="2" --memory="200m" business-app
docker run -d --cpus="3" --memory="300m" database-app
```
**Pros:** Better than systemd, easier deployment
**Cons:** Limited auto-scaling on single VM

**2. Docker Approach (Multi-VM or Swarm):**

**docker-compose.yml:**
```yaml
version: '3.8'
services:
  ui:
    image: ui-app:latest
    deploy:
      resources:
        limits:
          cpus: '1'
          memory: 100M
        reservations:
          cpus: '0.5'
          memory: 50M

  business:
    image: business-app:latest
    deploy:
      resources:
        limits:
          cpus: '2'
          memory: 200M
        reservations:
          cpus: '1'
          memory: 100M

  database:
    image: database-app:latest
    deploy:
      resources:
        limits:
          cpus: '3'
          memory: 300M
        reservations:
          cpus: '1.5'
          memory: 150M
```

**3. Kubernetes Approach (Most Scalable):**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ui-app
spec:
  replicas: 3
  template:
    spec:
      containers:
      - name: ui
        image: ui-app:latest
        resources:
          requests:
            cpu: "1000m"
            memory: "100Mi"
          limits:
            cpu: "1500m"
            memory: "150Mi"
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: business-app
spec:
  replicas: 3
  template:
    spec:
      containers:
      - name: business
        image: business-app:latest
        resources:
          requests:
            cpu: "2000m"
            memory: "200Mi"
          limits:
            cpu: "3000m"
            memory: "300Mi"
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: database-app
spec:
  replicas: 3
  template:
    spec:
      containers:
      - name: database
        image: database-app:latest
        resources:
          requests:
            cpu: "3000m"
            memory: "300Mi"
          limits:
            cpu: "4000m"
            memory: "400Mi"
```

**Add Horizontal Pod Autoscaler to maintain ratios:**
```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: ui-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: ui-app
  minReplicas: 1
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
```

**Most Optimal Solution for Production (Cost Priority):**

**Recommended: Kubernetes on Cloud with Auto-Scaling**

**Cost Optimization Strategies:**
1. **Use spot/preemptible instances** for non-critical workloads
2. **Right-size your nodes** based on pod requirements
3. **Enable cluster autoscaler** to scale nodes based on demand
4. **Use HPA** to scale pods based on metrics
5. **Implement resource quotas** to prevent over-provisioning
6. **Use PodDisruptionBudgets** for safe scaling
7. **Leverage reserved instances** for baseline capacity

**Example cost-optimized architecture:**
- **Dev/Test:** Single VM with Docker Compose (cheapest)
- **Small Production:** Managed Kubernetes (GKE/EKS/AKS) with 2-3 nodes
- **Large Production:** Multi-AZ Kubernetes with node auto-scaling, spot instances for stateless apps, reserved instances for databases

**Reference Implementation:** See `solution7.service` for systemd approach

**Cost Comparison (Monthly estimates):**
- VM approach: $50-100 (single VM) or $150-300 (separate VMs)
- Docker on VMs: $75-150
- Managed Kubernetes: $200-500 (includes control plane, better scaling)

