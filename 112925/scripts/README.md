# Python Environment Setup and Headless Locust Execution

## Create and Activate a Python Virtual Environment

1) Move to scripts dir

2) Create a virtual environment
```bash
python3 -m venv venv
```

3) Activate the virtual environment (macOS)
```bash
source venv/bin/activate
```

4) Activate the virtual environment (Git Bash)
```bash
source venv/Scripts/activate
```


## Install Required Python Modules

```bash
pip install locust
```


## Run Locust in Headless Mode

The command below runs Locust without starting the web UI.
It targets your ALB, starts immediately, spawns 5 users per second, and runs 20 total.

```bash
locust -f locustfile.py \
  --host "<alb url>" \
  -u 20 \
  -r 5 \
  --headless \
  --run-time 5m \
  --loglevel INFO
  ```





## 4. Optional: Save Output to a Log File

```bash
--logfile az_test.log
bash