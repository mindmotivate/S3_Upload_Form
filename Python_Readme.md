**Script 1: email_extract.py**
- This script, titled "email_extract_variables.py", reads an Excel file named 'email_data.xlsx' using the Pandas library.
- It extracts email addresses from the 'Email' column of the Excel file and converts them into a list.
- Then, it writes the extracted email addresses to a Terraform variables file named 'terraform.tfvars' as a list.
- You can use this script in your project to automate the process of generating Terraform variables for email addresses stored in an Excel file. Simply replace 'email_data.xlsx' with the name of your Excel file containing the email addresses.

**Script 2: email_extract_map.py**
- This script, titled "email_extract_map.py", also utilizes Pandas to read an Excel file named 'email_data_map.xlsx'.
- It creates a dictionary where the keys are names (assumed to be in the 'Name' column of the Excel file) and the values are email addresses (assumed to be in the 'Email' column).
- The script prints the generated email map and writes it to a Terraform variables file named 'terraform.tfvars' as key-value pairs.
- You can integrate this script into your project to automatically generate a mapping of names to email addresses from an Excel file. Ensure your Excel file has 'Name' and 'Email' columns for this script to work correctly.
