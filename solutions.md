Question 1 : In Linux, the Nice command is used to prioritize the execution of processes.
a. Tell me more about it and if given a choice where do you think it will be useful in your existing project ?
b. If you have to prioritize a specific workloads in a dockerd or k8s environment, how will you do it similarly to the native Nice command of Linux ?

Solution : In Linux, the priority value for a process ranges from -20 to 19, with -20 being the highest priority and 19 being the lowest priority. In other words, The higher the value, the lower the priority of the process.
There are two commands that are used for the process, "nice and renice"
You can set the initial priority with the nice command : nice -n 10 my_program
Then if needed, we can also change the same with : renice 1 my_program 
In my existing project, I was using this for the long running back ground processes that were running clean up jobs. 

For docker and k8s the priority is not a relative terms, there is no guarantee. In Docker we can specify the requirements with the run command and in K8s we have resources block in the pod manifest to set requests and limits, however they are subject to the availability of the underlying nodes and we cant give numbers "-20 to 19" here to set the relative priority within the same kind of objects.

Question 2 : What do you know about LINUX Signals, how does Inter-Process Communication happen with uses of signals.
Follow-up : How is it related to Kubernetes pod status and to Docker entry points ?

Solution : There are the interrupt commands that the linux process are able to send to the one another. We dont create a new signal we use the existing list that Linux provides (64 of them). 
You can see a list of signals and their meanings by running the kill -l command in a terminal.
Here is a shell script that can help you explain this better in the context of linux : signal.sh

All the container and docker life cycles are managed by using the signals, this is how we are able to start stop and complete the container and pod objects. From with the pods and containers, we can also initial traps for graceful shutdowns. 
For docker, signals have a huge significance. By using the signals the underlying daemon is able to manage the relative signal handlings of the container and also is able to do the cleanups once the main process defined in the endpoints exists.
Note : (remember the interviewer wont as you the names or the functions of all the signals) you can find the details here : https://faculty.cs.niu.edu/~hutchins/csci480/signals.htm


Question 3 :What are the kubernetes probs that you have used in your deployments, explain their importance and pre-requisites for each one.
Follow up:
1. What are the check mechanisms that you used while implementing the probs apart form the httpGet
2. Probs seem very useful, Why doesn't Kubernetes mandate applications to have default probs ?
startup, readiness and liveness all are optional, why ?

Solution : I have explained this in the link below have a look at : 
https://github.com/syednadeembe/project_sessions/tree/main/session-design/deployment
httpGet is the most common form, however there are tcpSocket and exec as well ( please only explain them if you have used them, otherwise stay with httpGet).

Probs are very useful, however at the end of the day, they are also processes and demand resources. Imagine having a prob check every 10 sec for a pod that is suppose to run for 10-20 minutes and complete. In this case the probs can endup consuming more resources than the actual pod.  Not all applications have the same requirements or architecture, so mandating default probes could limit the flexibility.

Note : The startup prob is similar to a liveness probe but it only run once when the container is first started. So it only makes sense to have this if your application is having longer initialDelaySeconds

Question 4 : We spoke about IPC socket or Unix domain socket in Question 2 (find that question in previous posts), explain how inter-process communication workflow works in Docker Architecture.
Follow up:
1. What is the role of docker.sock file ?
2. How Docker socket work ?

Solution : Docker provides several IPC mechanisms for communication between containers and between containers and the Docker daemon the most common is the docker.sock file
This is an Unix Sockets (docker.sock): The Docker daemon exposes a Unix socket file (docker.sock) that clients can use to communicate with the Docker daemon over the Unix socket protocol. This socket file is located at /var/run/docker.sock on Linux systems. So when every you run docker command in the CLI, you are using this IPC mechanism of inter-process communication.  Docker socket, typically located at /var/run/docker.sock, is used by the Docker daemon (dockerd) to listen for Docker API requests and thats how the docker architecture is built to work.

There are some other IPC Mechanisms like Shared Volumes and Network Communication that you can also explain if you have used them.

Question 5 : Design a Kubernetes deployment setup where you have 3 applications that need to run in HA to create a solution. However the applications have starting and running dependencies and requirements.
a. application 1 should always start first
b. application 2 should always start after application 1 is Ready
c. application 3 should always start after application 2 is Ready
Follow up:
1. How will you design a check mechanism for the applications in such a way that restarts and schedular reschedules dont break the dependence requirements
2. How will you plan to incorporate such check mechanism with CD tools where deployments are gitops driven

Solution : This was answered here : https://www.linkedin.com/feed/update/urn:li:activity:7171006364901687296?commentUrn=urn%3Ali%3Acomment%3A%28activity%3A7171006364901687296%2C7171052035369283584%29&dashCommentUrn=urn%3Ali%3Afsd_comment%3A%287171052035369283584%2Curn%3Ali%3Aactivity%3A7171006364901687296%29

Note : They key to this question is to not over complicate and over engineer the solution. I have attached a deployment for your reference to check this : solution5.yaml

Question 6 : Please explain your understanding of multilayer switches and what Layer 4 LAN switching does.
Follow up:
1. Which component of Kubernetes using this technology and how ?

Solution : These are software-based switches that operate at multiple layers of the OSI model, they provide routing and switching functionalities similar to hardware-based switches and routers. Layer 4 LAN switching, involves switching traffic based on information found at Layer 4 of the OSI model, the transport layer. 

All the iptables rules that the nodes have are a reference of this switching.
Kube-proxy is responsible for implementing a form of Layer 4 load balancing to distribute incoming traffic to Kubernetes services across multiple pods. It uses iptables (or other proxy modes like IPVS or userspace proxy) to perform this function. 

Note : Read this if you are interested (https://www.haproxy.com/blog/layer-4-and-layer-7-proxy-mode https://opensource.com/article/22/6/kubernetes-networking-fundamentals)

Question 7 : You have 3 applications that make a solution. UI application, business application and database application. All the three applications are installable stand alone and connect with one another via configurations and endpoints. UI application needs 100MB and 1CPU, business application needs 200MB and 2CPU while the database application needs 300MB and 3CPU for every 1000 users payload. So think of this as 1:2:3 ratio in terms of resources.

How will you design deployment the solution on the following infrastructures and also make the sure the resource ratios are maintained:
1. On VM
2. On docker setup
3. On k8s setup

Follow up:
Design the most optional solution, keeping the production cost as priority.

Solution : On VM, the easy options is to have either separate vms for the setup, or install docker on a single vm and then define the conditions at the docker level. This will also be the most efficient approach, however this wont be practical if you are expecting to auto scale the deployments.
If we keep as side scaling, then we can even use tools like systemd to manage and control the resources allocated to each application at the linux level and this wont even need us to have docker. 
Something like this : solution7.service

On docker and on k8s this is very simple to achieve, So i will let you answer that :)

