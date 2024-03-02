
## Before You begin...


1. **Packages**:
   - Before you begin, ensure you have the following packages installed as dependencies:
     - aws-sdk
     - ejs
     - express
     - mu2-updated
     - multiparty
     - uuid

2. **Install Packages**:
   - To install these packages, run the following command in your project directory:
     ```bash
     npm install aws-sdk ejs express mu2-updated multiparty uuid
     ```




## To use these python scripts(optional):

1. **Prepare your Excel file**:
   - Ensure your Excel file contains the relevant data:
   - **Choose one of these following files to run  based on you excel fomrmat*
     - For **Script 1 (email_extract_variables.py)**: The Excel file should have a column labeled 'Email' containing email addresses.
     - For **Script 2 (email_extract_map.py)**: The Excel file should have columns labeled 'Name' and 'Email' containing corresponding name and email address pairs.
   
2. **Run the Python script**:
   - Choose the script based on your requirement:
     - For a simple list of email addresses, use **Script 1 (email_extract_variables.py)**.
     - For a mapping of names to email addresses, use **Script 2 (email_extract_map.py)**.
   - Run the selected script using the Python interpreter:
     ```
     python email_extract_variables.py
     ```
     or
     ```
     python email_extract_map.py
     ```

3. **Check the output**:
   - After running the script, check the generated Terraform variables file named 'terraform.tfvars'.
   - It should contain the email addresses extracted from the Excel file in the format required by your Terraform configuration.

By following these instructions, you can easily populate your Terraform variables file with email addresses extracted from an Excel file using the provided Python scripts.


## Bucket Creation w/ Terraform

1. **Create a unique bucket name**:
   - Open the 'variables.tf' file in your project directory.
   - Define a variable for the bucket name.
   - Replace "your-unique-bucket-name" with your desired bucket name.

**2. Ensure your terraform.tfvars file is populated**

**3.Run Terraform commands**:
   - Initialize Terraform:
     ```
     terraform init
     ```
   - Generate and review the execution plan:
     ```
     terraform plan
     ```
   - Apply the changes:
     ```
     terraform apply
     ```

## Run Local Server:
   - Before running the local server, ensure you have installed Express and other required packages by running:
     ```bash
     npm install express aws-sdk mu2-updated uuid multiparty
     ```
   - Once the dependencies are installed, follow these steps to run the local server:
     1. Open a terminal or command prompt.
     2. Navigate to your project directory:
        ```bash
        cd /path/to/your/project
        ```
        Replace `/path/to/your/project` with the actual path to your project directory.
     3. Run the following command to start the server:
        ```bash
        node server.js your-bucket-name
        ```
        Replace `your-bucket-name` with the name of your S3 bucket.
     4. Once the server is running, open a web browser and navigate to http://localhost:8080.
     5. You should now be able to access and use the `index.html` form on your local server.
   - Alternatively, you can simply click on the generated clickable link in your console output to open the form directly in your default web browser.
