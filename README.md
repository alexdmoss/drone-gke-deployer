# drone-gke-deployer

Docker image to run in Drone CI to deploy to Google Kubernetes Engine (GKE)

## Intro

Two goals for this repo:

1. I wasn't super-happy with the existing plugins available in Drone CI, and the built-in's seem more geared towards Drone running within the cluster already (and I was used https://cloud.drone.io initially).
2. I wanted to learn a bit more about how Drone actually works.

If you want something a bit more established, then this is probably a good bet: https://github.com/nytimes/drone-gke/

## Usage

It's not configured to auto-build on push to github, so:

```sh
docker build mosstech/drone-gke-deployer:latest
docker login --usernam=mosstech
docker push mosstech/drone-gke-deployer:latest
```
