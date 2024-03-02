import pandas as pd

# Read the Excel file
df = pd.read_excel('email_data.xlsx')

# Extract relevant data from the DataFrame
email_addresses = df['Email'].tolist()

# Write the extracted data to a Terraform variables file
with open('terraform.tfvars', 'w') as f:
    f.write('email_addresses = [\n')
    for email in email_addresses:
        f.write('    "{}",\n'.format(email))
    f.write(']\n')
    
# Print the email map
print(email_addresses)