
# AOP-Suite Deployment


## 1. Prepare a Directory on the Cluster

We ask the maintainer to keep all the files related to services on a single place. 

```
# Navigate the common directory
cd /mnt/gluster/docker/

# Create a directory for the service and a data directory in it
mkdir aop-suite

cd aop-suite
mkdir data 
```


## 2. Creating the Container Image

Service's source code is avaialable at [its GitHub repoistory](https://github.com/VHP4Safety/AOP-Suite). The repository can be cloned by running the following code on the terminal: 

```
git clone https://github.com/VHP4Safety/AOP-Suite.git
```

The command above will clone the repository in a directory with the name `AOP-Suite` inside the working directory. 

Next, the container is image can be created by running the command below in the directory where all the source code and the Dockerfile are available:

```
cd AOP-Suite
docker build -t aop-suite .
```


## 3. Launching the Container

Note that the (sub-)domain should be made available from the Strato's webpage for this deployment and its A-record should be set to the IP address of the cluster. Please contact the Department of Translational Genomics at Maastricht University for this. 

Once the (sub-)domain is available, e.g., `aopsuite.cloud.vhp4safety.nl`, one can run the command below.

```
docker service create \
  --name aopsuite \
  --network core \
  --label traefik.enable=true \
  --label "traefik.http.routers.aopsuite.rule=Host(\`aopsuite.cloud.vhp4safety.nl\`)" \
  --label traefik.http.routers.aopsuite.entrypoints=websecure \
  --label traefik.http.routers.aopsuite.tls=true \
  --label traefik.http.routers.aopsuite.tls.certresolver=letsencrypt \
  --label traefik.http.services.aopsuite.loadbalancer.server.port=5000 \
  --label traefik.docker.network=core \
  --restart-condition on-failure \
  aop-suite
```

After a while, the service should be ready at `https://aopsuite.cloud.vhp4safety.nl/`.


## 4. Updating the Service

If there are updates to the tool on its GitHub repository, one can run `git pull` to receive the updates under `/mnt/gluster/docker/aopsuite`. After this, the new image can be built with `docker build -t aop-suite .`.

In order to launch the new version, one first needs to stop the running version. The list of all the running services can be displayed with 

```
docker service ls
```

One then needs to find the service, whose name will be displayed as it was given in the command for launching the  service with its `--name` option, e.g., above it is `aopsuite`. The service can then be stopped with 

```
docker service rm aopsuite
```

After stopping the running version, you can launch the new version again, using the command in step 3. 
