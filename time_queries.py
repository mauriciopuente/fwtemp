from inventory.models import Query
from inventory.query import QueryExecutor
from filewave.fw_util.helpers import get_locale_aware_datetime_now

result = list()

for q in Query.objects.filter(favorite=True):
    now = get_locale_aware_datetime_now()
    qe = QueryExecutor(q)
    count = qe.queryset.count()
    done = get_locale_aware_datetime_now()
    result.append( (q.name, count, (done-now).total_seconds()))

for detail in sorted(result, key=lambda tup: -tup[2]):
    print "Query %s: \t\tcount = %d, \t\ttime = %.5f" % detail
