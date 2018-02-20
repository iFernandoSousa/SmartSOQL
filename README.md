# SmartSOQL
A new way to write your SQOL for apex code

This is a simple way to create a query using methods so simple like this:
```
    List<sObject> query = new SmartSOQL()
				.fromObject(Profile.sObjectType)
				.withFields(new SObjectField[] {Profile.Id,
		                                        Profile.Name})
				.equalTo(Profile.UserType, 'Standard')
				.orderBy(Profile.Name)
				.withLimit(5)
				.findAll();
```
