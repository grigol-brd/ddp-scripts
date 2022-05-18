# Docs

You can find study configuration example with explanations [here](https://github.com/broadinstitute/ddp-study-server/blob/626d9c2f4f7e2979182f7ac3a7ea8eea5a08567c/pepper-apis/studybuilder-cli/studies/study-example.conf).

To learn how study `Activity` and its parts work read guide [here](https://broadinstitute.atlassian.net/wiki/spaces/DDP/pages/1344995771/Activity+Guide).

<br/>

# Requirements

You'll need to download a few things to get local development up and running.

### Frontend

- Node.js (`v16.13.1` as of writing this)
- Angular CLI (`v13.1.2` as of writing this)

  ```
  npm install -g @angular/cli@13.1.2
  ```

  **if you've worked on other angular projects, you may first need to**

  ```
  npm uninstall -g @angular/cli
  ```

### Backend

- Java 11 - see the [docs here](https://github.com/broadinstitute/ddp-study-server/blob/develop/pepper-apis/docs/java-11.md)
- Maven - for building the project
- Python - for running various scripts if needed
- Ruby - for rendering configuration files from templates
- Vault - for secrets management (for more: [setup](https://broadinstitute.atlassian.net/wiki/spaces/DO/pages/113874856/Vault), [usage](https://broadinstitute.atlassian.net/wiki/spaces/DDP/pages/746651676/Vault+Usage+Guide))
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) - for running pubsub locally
- [Docker](https://www.docker.com/products/docker-desktop/) - for building images and optionally for running the test suite

Tip: for Windows, if you're familiar with Chocolatey package manager you can use it to download above items.

<br/>

# Environment Setup

Before running frontend/backend you need to setup the environment:

1. Open [env.sh](./env.sh) file and update `DIR` variables relative to your machine.

2. To setup tokens and log in into vault run below command from `scripts-ddp` folder.  
   **Ask your teammates for the tokens**.

   ```
   ./setup.sh [OPTIONS]

   OPTIONS:    -c <circle_ci_token>
               -g <github_personal_access_token>

   Eg: ./setup.sh -c <circle_ci_token> -g <github_personal_access_token>
   ```

   **Reload any open terminals or IDE to reflect applied changes after setup.**

<br/>

# Frontend Development

## Start up

**Find study 👉 [KEYs here](https://github.com/broadinstitute/ddp-angular/blob/develop/.circleci/config.yml#L14) and [GUIDs here](https://github.com/broadinstitute/ddp-angular/blob/develop/.circleci/config.yml#L16)** 👈

Generate frontend study config. Run this from `scripts-ddp` folder

```
./render-client-config.sh <study_key> <study_guid>
```

Install required dependencies. Run below command from `ddp-angular/ddp-workspace` folder

```
npm install
```

Start frontend app. Run below command from `ddp-angular/ddp-workspace` folder

```
ng serve <study_project_folder> -o

Eg: ng serve ddp-singular -o
```

## Testing

After creating PR run below command from `ddp-angular/build-utils` folder to start automated tests

```
./run_ci.sh run-tests <study_key> <branch> dev
```

## Deployment

When a pull request is merged to `develop` deployment is automatically triggered and that should be sufficient in most cases. However, if you happen to need to deploy specific branch to dev environment you can do so by running the following script from `ddp-angular/build-utils` folder

```
./startbuilddeploy.sh <study_key> <branch>
```

<br/>

# Backend Development

## Preparation

You need to have docker containers running before you start the server.  
Start the containers by running given command from `scripts-ddp` folder:

```
docker-compose up -d
```

Make sure the containers are running. Check Docker Desktop or run the command below.

You should see `mysql` and `redis` in the list.

```
docker ps
```

## Start up

To compile and run study run below command from `scripts-ddp` folder

```
./build-study.sh <study_key> <substitutions_file> --all

Eg: ./build-study.sh singular substitutions.conf --all
```

Other (but not all) available commands:

```
./build-study.sh <study_key> <substitutions_file> --build-pepper
./build-study.sh <study_key> <substitutions_file> --build-study
./build-study.sh <study_key> <substitutions_file> --run-pepper
```

## Testing

After creating PR run this command from `ddp-study-server/pepper-apis/scripts` folder to start automated testing

```
./run_ci_tests.sh <your_branch_name>
```
