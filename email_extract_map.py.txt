import pandas as pd

# Read the Excel file
df = pd.read_excel('email_data_map.xlsx')

# Create an empty dictionary to store email addresses
email_map = {}

# Iterate over rows in the DataFrame and populate the dictionary
for index, row in df.iterrows():
    username = row['Name']  # Assuming 'Name' is a column in your Excel file
    email = row['Email']  # Assuming 'Email' is a column in your Excel file
    email_map[username] = email

# Print the email map
print("Email Map:")
for name, email in email_map.items():
    print(f"{name}: {email}")

# Write the map to a .tfvars file
with open('terraform.tfvars', 'w') as f:
    f.write("email_addresses= {\n")
    for name, email in email_map.items():
        f.write(f'    "{name}": "{email}",\n')
    f.write("}\n")

