# apache-airflow-test

## Installation
You need the following:

- Python v3.6.x
- make create-env
- make install-deps

## Lets run though the tutorial
The [Apache Airflow Tutorial](https://airflow.apache.org/tutorial.html) specifies a dag. Lets place it in
`./dags/tutorial.py`

We can exec into the scheduler container with `make docker-compose-exec-scheduler`

Print the list of active DAGs:

```bash
$ airflow list_dags

-------------------------------------------------------------------
DAGS
-------------------------------------------------------------------
example_bash_operator
example_branch_dop_operator_v3
example_branch_operator
example_http_operator
example_passing_params_via_test_command
example_python_operator
example_short_circuit_operator
example_skip_dag
example_subdag_operator
example_subdag_operator.section-1
example_subdag_operator.section-2
example_trigger_controller_dag
example_trigger_target_dag
example_xcom
latest_only
latest_only_with_trigger
test_utils
tutorial
```

Prints the list of tasks the "tutorial" dag_id:
```bash
$ airflow list_tasks tutorial

print_date
sleep
templated
```

Prints the hierarchy of tasks in the tutorial DAG

```bash
$ airflow list_tasks tutorial --tree

<Task(BashOperator): sleep>
    <Task(BashOperator): print_date>
<Task(BashOperator): templated>
    <Task(BashOperator): print_date>
```

## Running Tasks
We can run tasks. We need to specify a specific at at which the task will run. When we specify a date before now, then the task will be scheduled immediately.

Running task 'print_date':

```bash
$ airflow test tutorial print_date 2015-06-01

[2019-08-06 16:41:24,974] {bash_operator.py:114} INFO - Running command: date
[2019-08-06 16:41:24,980] {bash_operator.py:123} INFO - Output:
[2019-08-06 16:41:24,983] {bash_operator.py:127} INFO - Tue Aug  6 16:41:24 UTC 2019
[2019-08-06 16:41:24,984] {bash_operator.py:131} INFO - Command exited with return code 0
```

Running task 'sleep':

```bash
$ airflow test tutorial sleep 2015-06-01

[2019-08-06 16:43:19,164] {bash_operator.py:114} INFO - Running command: sleep 5
[2019-08-06 16:43:19,171] {bash_operator.py:123} INFO - Output:
[2019-08-06 16:43:24,176] {bash_operator.py:131} INFO - Command exited with return code 0
```

Running task: 'templated':

```bash
$ airflow test tutorial templated 2015-06-01

2019-08-06 16:44:14,109] {bash_operator.py:114} INFO - Running command:

    echo "2015-06-01"
    echo "2015-06-08"
    echo "Parameter I passed in"

    echo "2015-06-01"
    echo "2015-06-08"
    echo "Parameter I passed in"

    echo "2015-06-01"
    echo "2015-06-08"
    echo "Parameter I passed in"

    echo "2015-06-01"
    echo "2015-06-08"
    echo "Parameter I passed in"

    echo "2015-06-01"
    echo "2015-06-08"
    echo "Parameter I passed in"

[2019-08-06 16:44:14,121] {bash_operator.py:123} INFO - Output:
[2019-08-06 16:44:14,124] {bash_operator.py:127} INFO - 2015-06-01
[2019-08-06 16:44:14,124] {bash_operator.py:127} INFO - 2015-06-08
[2019-08-06 16:44:14,126] {bash_operator.py:127} INFO - Parameter I passed in
[2019-08-06 16:44:14,127] {bash_operator.py:127} INFO - 2015-06-01
[2019-08-06 16:44:14,128] {bash_operator.py:127} INFO - 2015-06-08
[2019-08-06 16:44:14,129] {bash_operator.py:127} INFO - Parameter I passed in
[2019-08-06 16:44:14,130] {bash_operator.py:127} INFO - 2015-06-01
[2019-08-06 16:44:14,130] {bash_operator.py:127} INFO - 2015-06-08
[2019-08-06 16:44:14,132] {bash_operator.py:127} INFO - Parameter I passed in
[2019-08-06 16:44:14,132] {bash_operator.py:127} INFO - 2015-06-01
[2019-08-06 16:44:14,133] {bash_operator.py:127} INFO - 2015-06-08
[2019-08-06 16:44:14,134] {bash_operator.py:127} INFO - Parameter I passed in
[2019-08-06 16:44:14,134] {bash_operator.py:127} INFO - 2015-06-01
[2019-08-06 16:44:14,135] {bash_operator.py:127} INFO - 2015-06-08
[2019-08-06 16:44:14,135] {bash_operator.py:127} INFO - Parameter I passed in
[2019-08-06 16:44:14,136] {bash_operator.py:131} INFO - Command exited with return code 0
```

## Backfill
We can ask Airflow to schedule tasks that have not yet run. There are no runs for 2015-06-01 to 2015-06-07. With the following command we can ask Airflow to run these tasks for us, this is called 'backfilling'. The command will show the progress on the CLI and also show the progress on the Airflow webserver.

```bash
$ airflow backfill tutorial -s 2015-06-01 -e 2015-06-07
```

## Python location on OSX
When you have installed Python with brew, then it is located at:

- `/usr/local/Cellar/python`: for all your Python 3 versions
  - Place your python versions here in a subdir eg. `3.7.4`
- `/usr/local/Cellar/python@2`: for all your Python 2 versions
  - Place your python versions here in a subdir eg. `2.7.16`

## Install a version of Python
A handy utility that can help you with installing different versions of python is pyenv.

```bash
$ brew install pyenv
```

Pyenv can show you which versions are available locally:

```bash
$ pyenv versions
* system (set by /Users/dennis/.pyenv/version)
  3.6.5
  3.6.6
  3.7.0
``` 

The python versions are installed in:

```bash
ls ~/.pyenv/versions/
3.6.5 3.6.6 3.6.9 3.7.0
```

To install a new version type the following command:

```bash
$ pyenv install -l | grep 3.6.9
3.6.9
``` 

To activate this version type:

```bash
$ pyenv init
eval "$(pyenv init -)"
```

To launch a shell in 3.6.9:

```bash
$ pyenv shell 3.6.9
$ which python
/Users/dennis/.pyenv/shims/python
$ python -V
Python 3.6.9
```

## Python Profilers
- [PySpy - A Sampling profiler for Python programs](https://github.com/benfred/py-spy)
- [PyFlame](https://github.com/uber/pyflame)

## Resources
- [Python Downloads](https://www.python.org/downloads/)
- [Docker RUN vs CMD vs ENTRYPOINT](https://goinbigdata.com/docker-run-vs-cmd-vs-entrypoint/)
- [GoDataDriven - Airflow](https://github.com/godatadriven-dockerhub/airflow)