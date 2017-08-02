from apple.dep import FileWaveClient
from apple.models.dep import DEPAccount
failed = []
for a in DEPAccount.objects.all():
	c = FileWaveClient( a )
	try:
		c.sync_device_model()
	except:
		failed.append( c )

for c in failed:
	print (c.__dict__)
