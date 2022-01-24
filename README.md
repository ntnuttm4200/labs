# labs
Lab Assignments for NTNU TTM4200: Computer Networks (Spring 2022)


## 1.1 [Course Repository](https://git-scm.com/)

We will use a Github repository for all labs materials during this course.


* Clone the labs' repository from Github:

    ```bash
    git clone https://github.com/ntnuttm4200/labs.git /home/ttm4200/labs
    ```
    A new directory called "labs" will be created in your home directory.

* We will update the course repository frequently, so you should pull the new updates at the beginning of each lab.

    ```bash
    cd ~/labs
    git add .
    git commit -m "message describing local changes"
    git pull origin main --no-edit
    ```