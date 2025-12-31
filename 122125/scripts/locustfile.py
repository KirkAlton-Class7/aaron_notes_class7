import re
from locust import HttpUser, task, between

# Regex to remove all HTML tags like <p>, <div>, <br>, etc.
TAG_REGEX = re.compile(r"<[^>]+>")

# Regex to extract the Availability Zone after the label "Availability Zone:"
# Example it matches: "Availability Zone: us-west-2c"
AZ_REGEX = re.compile(r"Availability\s+Zone:\s*([A-Za-z0-9-._]+)", re.IGNORECASE)

# Regex to extract the Private IP after the label "Instance Private Ip Address:"
# Example it matches: "Instance Private Ip Address: 10.10.3.83"
IP_REGEX = re.compile(r"Instance\s+Private\s+Ip\s+Address:\s*([0-9.]+)", re.IGNORECASE)


class MetadataUser(HttpUser):

    # Each Locust user makes a request every 0.2 seconds (~5 per second)
    wait_time = between(0.2, 0.2)

    def on_start(self):
        # Track the last AZ and IP this user saw
        self.last_az = None
        self.last_ip = None

    @task
    def get_metadata_page(self):
        # Hit the root path (/) of the website behind the ALB
        response = self.client.get("/")

        #  remove tags, collapse spaces
        raw = response.text
        clean = TAG_REGEX.sub(" ", raw)      # remove all <tags>
        clean = re.sub(r"\s+", " ", clean)   # normalize whitespace

        # Look for AZ and Private IP in the clean text
        az_match = AZ_REGEX.search(clean)
        ip_match = IP_REGEX.search(clean)

        # if unable to parse either, skip request
        if not az_match or not ip_match:
            return

        # save matched strings
        az = az_match.group(1).strip()
        ip = ip_match.group(1).strip()

        # If this is the first time, print the initial values
        if self.last_az is None and self.last_ip is None:
            print(f"Initial AZ: {az} - {ip}")

        # If the AZ or IP changes later, print the event
        elif az != self.last_az or ip != self.last_ip:
            print(f"AZ change: {az} - {ip} (previous: {self.last_az} - {self.last_ip})")

        # Store the current values for comparison next time
        self.last_az = az
        self.last_ip = ip
