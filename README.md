## Setup

To setup tokens and log into vault run below command from `scripts-ddp` folder.  
**Ask teammates for the tokens**

```
./setup.sh [OPTIONS]

OPTIONS:    -c <circle_ci_token>
            -g <github_personal_access_token>

Eg: ./setup.sh -c <circle_ci_token> -g <github_personal_access_token>
```

**Reload any open terminals or open new ones to reflect applied changes.**

## Frontend

### Startup

**Find study [keys here](https://github.com/broadinstitute/ddp-angular/blob/develop/.circleci/config.yml#L14) and [guids here](https://github.com/broadinstitute/ddp-angular/blob/develop/.circleci/config.yml#L16)**

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

### Testing

After creating PR run below command from `ddp-angular/build-utils` folder to start automated tests

```
./run_ci.sh run-tests <study_key> <branch> dev
```

## Backend

### Startup

To compile and run study run below command from `scripts-ddp` folder

```
./build-study.sh <study_key> <substitutions_file> --all

Eg: ./build-study.sh singular substitutions.conf --all
```

Other available commands:

```
./build-study.sh <study_key> <substitutions_file> --build-pepper
./build-study.sh <study_key> <substitutions_file> --build-study
./build-study.sh <study_key> <substitutions_file> --run-pepper
```

### Testing

After creating PR run this command from `ddp-study-server/pepper-apis/scripts` folder to start automated testing

```
./run_ci_tests.sh <your_branch_name>
```
