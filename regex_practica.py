import re

print ('\n ====== Greedy ========= \n')

greedyHaRegex = re.compile(r'(Ha){3,5}')
mo1 = greedyHaRegex.search('HaHaHaHaHa')
print (mo1.group())

print ('\n ====== Non Greedy ========= \n')

nongreedyHaRegex = re.compile(r'(Ha){3,5}?')
mo1 = nongreedyHaRegex.search('HaHaHaHaHa')
print (mo1.group())

print ('\n\n\n ############################################ \n\n\n')

## FindAll method:
## ---------------

print ('\n ====== Search Method ========= \n')

phoneNumRegex = re.compile(r'\d\d\d-\d\d\d-\d\d\d\d')
mo = phoneNumRegex.search('Cell: 415-555-9999 Work: 212-555-0000')
print (mo.group())


print ('\n ====== FindAll Method ========= \n')


phoneNumRegex = re.compile(r'\d\d\d-\d\d\d-\d\d\d\d')
mo = phoneNumRegex.findall('Cell: 415-555-9999 Work: 212-555-0000')
print (mo)


print ('\n\n\n ############################################ \n\n\n')


xmasRegex = re.compile(r'\d+\s\w+')
mo = xmasRegex.findall('12 drummers, 11 pipers, 10 lords, 9 ladies, 8 maids, 7 swans, 6 geese, 5 rings, 4 birds, 3 hens, 2 doves, 1 partridge')
print (mo)


print ('\n\n\n ############################################ \n\n\n')


print ('\n ====== Wildcard Character ========= \n')

atRegex = re.compile(r'.at')
mo = atRegex.findall('The cat in the hat sat on the flat mat.')
print (mo)



print ('\n\n\n ############################################ \n\n\n')


print ('\n ====== Substituting Strings with the sub() Method ========= \n')

namesRegex = re.compile(r'Agent \w+')
mo = namesRegex.sub('CENSORED', 'Agent Alice gave the secret documents to Agent Bob.')
print (mo)


print ('\n\n ====== Substituting Strings with the sub() Method 2 ========= \n')

agentNamesRegex = re.compile(r'Agent (\w)\w*')
mo = agentNamesRegex.sub(r'\1****', 'Agent Alice told Agent Carol that Agent Eve knew Agent Bob was a double agent.')
print (mo)



print ('\n\n ====== Substituting Strings with the sub() Method 3 ========= \n')

testRegex = re.compile(r'REVOKE ALL ON SCHEMA public FROM (Armando)')
mo = testRegex.sub(r'\1****','REVOKE ALL ON SCHEMA public FROM Armando;')
print (mo)