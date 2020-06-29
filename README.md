# ansible-docker-image
This repository contains basic components to create a docker image with specific python2, python3 and linux dependencies necessary to make your ansible playbooks work. The idea is that you can keep this repository updated with you requirements, as your project grows and the image would be built and pushed to your private repository on an update. Its easy to track the changes when each group of libraries is in one file and not embedded in the Dockerfile.

## Files

* **python2_libs.txt**: This is the requirements file for python2 (all libraries to be installed), among them Ansible. Here you can specify the version of ansible and other libraries you need. It's recommended to specify the exact versions.
* **python3_libs.txt**: Same as python2_libs.txt, but for python3.
* **yum_packages.txt**: Required linux libraries. The base image is centos:centos7, this would be installed 
* **Makefile**: Very basic Makefile to take care of the few steps to build the image. This is called in .gitlab-ci.yml.
* **.gitlab-ci.yml**: Simple gitlab-ci pipeline assuming that the gitlab runner uses the docker executor, docker-in-docker. As mentioned, the steps are in the Makefile so that you can adapt this easier to another CI tool like travis ci, if that's what you use.

## Python version
If you don't need both python versions, you can delete the python#_libs.txt file and the corresponding lines from the Dockerfile.

In my case I needed both, as not everything worked with python3 (for example, python3-libselinux did not exist for Centos), so that had to run with python2. And I also had issues with some tasks running with python2, mostly due to the different unicode handling.

## Run
```
sudo docker run --rm -it \
                --net=host \
                python3 \
                ansible-image \
                /usr/local/bin/ansible-playbook --version
```

### Ansible playbooks
You're probably thinking how to access your playbooks from inside the container. You can mount your repository as a volume, or pull it from inside the container.
In case of using this image with a cicd tool like gitlab-ci, your code would be checked out inside it, so that's taken care for you.

### Running ansible as non-root
You can create another user in the docker file and set that as the container user.

## Proxy
A couple of variables to use a HTTP proxy were added in .gitlab-ci.yml. In case you are using a proxy in your setup, modify the dummy values in .gitlab-ci.yml, if not you can remove them from .gitlab-ci.yml and the Makefile.

## Common issues
### Gitlab runner configuration
To avoid the gitlab runner not being able to execute docker, you can mount the docker.sock as a volume in /etc/gitlab-runner/config.toml. There are other ways that can suit your situation better, I chose this one in my case.
```
volumes = ["/var/run/docker.sock:/var/run/docker.sock", "/cache"]
```

### Pushing to an insecure registry
In production you should setup https communication, but in case you're getting errors when pushing to the registry, while testing this, due to the registry being considered insecure, you can add this to /etc/docker/daemon.json:
```
  "insecure-registries" : ["myregistry:5000"]
```
If the file does not exist, you can create it and add just that line (in json format).
```
{
  "insecure-registries" : ["myregistry:5000"]
}
```
