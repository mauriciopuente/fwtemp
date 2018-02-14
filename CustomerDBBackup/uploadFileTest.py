import requests

tarfile = 'b345a0a590f34320bd71e97e893b7e20-12.0.2-MacOS10.13.1-2_14_2018_11_28.sql.tar.gz'
tarfilepath = '/tmp/b345a0a590f34320bd71e97e893b7e20-12.0.2-MacOS10.13.1-2_14_2018_11_28.sql.tar.gz'

r = requests.post('https://files.filewave.ch/api2/auth-token/', {'username':'autoupload@filewave.com','password':'eatitnow'})
token = r.json()['token']
print(token)
a = requests.get('https://files.filewave.ch/api2/default-repo/', headers={'Authorization':'Token '+token})
# Check if there are repos
if a.json()['exists'] == False:
    print("Create a repo")
else:
    print("Repo exists")
    print(a.json())
    # Get the Upload link
    repoid = a.json()['repo_id']
    resp = requests.get('https://files.filewave.ch/api2/repos/'+repoid+'/upload-link/', headers={'Authorization':'Token '+token})
    upload_link = resp.json()
    # Upload file to repo
    response = requests.post(upload_link, data={'filename': tarfile, 'parent_dir': '/'},files={'file': open(tarfilepath, 'rb')},headers={'Authorization': 'Token '+token})
    print(response)
