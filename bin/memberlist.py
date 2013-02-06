#!/usr/bin/env python
'''Prints the current member list as JSON'''

try:
    import json
except ImportError:
    import simplejson as json

from get_renewees import execute_query, Member

query = ("SET NAMES 'utf8'; "
         "SELECT CONCAT(firstname, ';', lastname, ';', email, ';', "
         "              last_renewed_on) "
         " FROM foundationmembers"
         " WHERE DATE_SUB(CURDATE(), INTERVAL 2 YEAR) <= last_renewed_on"
         " ORDER BY lastname, firstname")
      

def get_current_electorate():
    infile = execute_query(query)
    memberlist = [Member.from_csv(line.strip()) for line in infile]

    return memberlist
            

def get_json_memberlist():
    members = get_current_electorate()
    objects = [
        {'firstname': o.firstname,
         'lastname': o.lastname,
         'email': o.email,
         'last_renewed_on': o.token_or_last_renewed_on,
        }
        for o in members]
    
    j = json.dumps(objects, indent=4)
    return j

if __name__ == '__main__':
    print get_json_memberlist()
