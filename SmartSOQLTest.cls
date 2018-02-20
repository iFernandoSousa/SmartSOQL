/**
 * @author  Fernando Sousa
 * @version 0.10
 * @createon 16/02/18.
 *
 * This class is a Test for Smart SOQL generator
 */

@IsTest
public class SmartSOQLTest {

	@IsTest
	static void count() {
		Integer result = new SmartSOQL().fromObject(Profile.sObjectType).count();
		system.assertEquals(result, [SELECT COUNT() FROM Profile]);
	}

	@IsTest
	static void withStringFields() {
		String query = new SmartSOQL()
				.fromObject(Profile.sObjectType)
				.withFields('Id, Name')
				.getQuery();

		system.assertEquals('SELECT Id, Name FROM Profile', query);
	}

	@IsTest
	static void withArrayStringFields() {
		String query = new SmartSOQL()
				.fromObject(Profile.sObjectType)
				.withFields(new String[] {'Id',
		                                  'Name'})
				.getQuery();

		system.assertEquals('SELECT Id, Name FROM Profile', query);
	}

	@IsTest
	static void withObjectFieldType() {
		String query = new SmartSOQL()
				.fromObject(Profile.sObjectType)
				.withFields(new SObjectField[] {Profile.Id,
		                                        Profile.Name})
				.getQuery();

		system.assertEquals('SELECT Id, Name FROM Profile', query);
	}

	@IsTest
	static void findAll() {
		List<Profile> result = new SmartSOQL()
				.fromObject(Profile.sObjectType)
				.withFields(new SObjectField[] {Profile.Id,
		                                        Profile.Name})
				.findAll();

		system.assertEquals(result.size(), [SELECT COUNT() FROM Profile]);
	}

	@IsTest
	static void withLimit() {
		List<Profile> result = new SmartSOQL()
				.fromObject(Profile.sObjectType)
				.withFields(new SObjectField[] {Profile.Id,
		                                        Profile.Name})
				.withLimit(5)
				.findAll();

		system.assertEquals(result.size(), [SELECT COUNT() FROM Profile LIMIT 5]);
	}

	@IsTest
	static void findFirst() {
		Profile result = (Profile)new SmartSOQL()
				.fromObject(Profile.sObjectType)
				.withFields(new SObjectField[] {Profile.Id,
		                                        Profile.Name})
				.findFirst();

		system.assertEquals(result.Id, [SELECT Id FROM Profile LIMIT 1].Id);
	}

	@IsTest
	static void orderBy() {
		String query = new SmartSOQL()
				.fromObject(Profile.sObjectType)
				.withFields(new SObjectField[] {Profile.Id,
		                                        Profile.Name})
				.orderBy('Id')
				.getQuery();

		system.assertEquals('SELECT Id, Name FROM Profile ORDER BY Id', query);
	}

	@IsTest
	static void orderByField() {
		String query = new SmartSOQL()
				.fromObject(Profile.sObjectType)
				.withFields(new SObjectField[] {Profile.Id,
		                                        Profile.Name})
				.orderBy(Profile.Name)
				.getQuery();

		system.assertEquals('SELECT Id, Name FROM Profile ORDER BY Name', query);
	}

	@IsTest
	static void orderByAsc() {
		String query = new SmartSOQL()
				.fromObject(Profile.sObjectType)
				.withFields(new SObjectField[] {Profile.Id,
		                                        Profile.Name})
				.orderBy('Id', SmartSOQL.ORDERBY.ASCENDING)
				.getQuery();

		system.assertEquals('SELECT Id, Name FROM Profile ORDER BY Id ASC', query);
	}

	@IsTest
	static void orderByDesc() {
		String query = new SmartSOQL()
				.fromObject(Profile.sObjectType)
				.withFields(new SObjectField[] {Profile.Id,
		                                        Profile.Name})
				.orderBy('Id', SmartSOQL.ORDERBY.DESCENDING)
				.getQuery();

		system.assertEquals('SELECT Id, Name FROM Profile ORDER BY Id DESC', query);
	}

	@IsTest
	static void orderByAscNullFirst() {
		String query = new SmartSOQL()
				.fromObject(Profile.sObjectType)
				.withFields(new SObjectField[] {Profile.Id,
		                                        Profile.Name})
				.orderBy('Id', SmartSOQL.ORDERBY.ASCENDING_NULL_FIRST)
				.getQuery();

		system.assertEquals('SELECT Id, Name FROM Profile ORDER BY Id ASC NULL FIRST', query);
	}

	@IsTest
	static void orderByAscNullLast() {
		String query = new SmartSOQL()
				.fromObject(Profile.sObjectType)
				.withFields(new SObjectField[] {Profile.Id,
		                                        Profile.Name})
				.orderBy(Profile.Id, SmartSOQL.ORDERBY.ASCENDING_NULL_LAST)
				.getQuery();

		system.assertEquals('SELECT Id, Name FROM Profile ORDER BY Id ASC NULL LAST', query);
	}

	@IsTest
	static void orderByDescNullFirst() {
		String query = new SmartSOQL()
				.fromObject(Profile.sObjectType)
				.withFields(new SObjectField[] {Profile.Id,
		                                        Profile.Name})
				.orderBy('Id', SmartSOQL.ORDERBY.DESCENDING_NULL_FIRST)
				.getQuery();

		system.assertEquals('SELECT Id, Name FROM Profile ORDER BY Id DESC NULL FIRST', query);
	}

	@IsTest
	static void orderByDescNullLast() {
		String query = new SmartSOQL()
				.fromObject(Profile.sObjectType)
				.withFields(new SObjectField[] {Profile.Id,
		                                        Profile.Name})
				.orderBy(Profile.Id, SmartSOQL.ORDERBY.DESCENDING_NULL_LAST)
				.getQuery();

		system.assertEquals('SELECT Id, Name FROM Profile ORDER BY Id DESC NULL LAST', query);
	}

	@IsTest
	static void doubleOrderBy() {
		String query = new SmartSOQL()
				.fromObject(Profile.sObjectType)
				.withFields(new SObjectField[] {Profile.Id,
		                                        Profile.Name})
				.orderBy(Profile.Id, SmartSOQL.ORDERBY.DESCENDING)
				.orderBy(Profile.Name)
				.getQuery();

		system.assertEquals('SELECT Id, Name FROM Profile ORDER BY Id DESC, Name', query);
	}

	@IsTest
	static void whereString() {
		List<sObject> query = new SmartSOQL()
				.fromObject(Profile.sObjectType)
				.withFields(new SObjectField[] {Profile.Id,
		                                        Profile.Name})
				.equalTo(Profile.UserType, 'Standard')
				.orderBy(Profile.Id, SmartSOQL.ORDERBY.DESCENDING)
				.orderBy(Profile.Name)
				.withLimit(5)
				.findAll();

		system.assertEquals(query.size(), [SELECT Count() FROM Profile WHERE UserType = 'Standard' LIMIT 5]);
	}

	@IsTest
	static void withDoubleWhereString() {
		List<sObject> query = new SmartSOQL()
				.fromObject(Profile.sObjectType)
				.withFields(new SObjectField[] {Profile.Id,
		                                        Profile.Name})
				.equalTo(Profile.UserType, 'Standard')
				.equalTo(Profile.Name, 'Force.com - Free User')
				.orderBy(Profile.Id, SmartSOQL.ORDERBY.DESCENDING)
				.orderBy(Profile.Name)
				.withLimit(5)
				.findAll();

		system.assertEquals(query.size(),
				[SELECT Count() FROM Profile WHERE UserType = 'Standard' AND Name = 'Force.com - Free User' LIMIT 5]);
	}

	@IsTest
	static void withDoubleWhereStringWithGroup() {
		List<sObject> query = new SmartSOQL()
				.fromObject(Profile.sObjectType)
				.withFields(new SObjectField[] {Profile.Id,
		                                        Profile.Name})
				.beginGroup()
				.equalTo(Profile.UserType, 'Standard')
				.equalTo(Profile.Name, 'Force.com - Free User')
				.endGroup()
				.orderBy(Profile.Id, SmartSOQL.ORDERBY.DESCENDING)
				.orderBy(Profile.Name)
				.withLimit(5)
				.findAll();

		system.assertEquals(query.size(),
				[SELECT Count() FROM Profile WHERE UserType = 'Standard' AND Name = 'Force.com - Free User' LIMIT 5]);
	}

	@IsTest
	static void withDoubleWhereStringWithGroupWithOR() {
		List<sObject> query = new SmartSOQL()
				.fromObject(Profile.sObjectType)
				.withFields(new SObjectField[] {Profile.Id,
		                                        Profile.Name})
				.beginGroup()
				.equalTo(Profile.UserType, 'Standard')
				.withOr()
				.equalTo(Profile.Name, 'Force.com - Free User')
				.endGroup()
				.withLimit(5)
				.findAll();

		system.assertEquals(query.size(),
				[SELECT Count() FROM Profile WHERE UserType = 'Standard' OR Name = 'Force.com - Free User' LIMIT 5]);
	}

	@IsTest
	static void withDoubleWhereStringWithGroupWithAnd() {
		List<sObject> query = new SmartSOQL()
				.fromObject(Profile.sObjectType)
				.withFields(new SObjectField[] {Profile.Id,
		                                        Profile.Name})
				.beginGroup()
				.equalTo(Profile.UserType, 'Standard')
				.withAnd()
				.equalTo(Profile.Name, 'Force.com - Free User')
				.endGroup()
				.withLimit(5)
				.findAll();

		system.assertEquals(query.size(),
				[SELECT Count() FROM Profile WHERE UserType = 'Standard' AND Name = 'Force.com - Free User' LIMIT 5]);
	}

	@IsTest
	static void withNotEqualsWhereString() {
		List<sObject> query = new SmartSOQL()
				.fromObject(Profile.sObjectType)
				.withFields(new SObjectField[] {Profile.Id,
		                                        Profile.Name})
				.notEqualTo(Profile.UserType, 'Standard')
				.findAll();

		system.assertEquals(query.size(), [SELECT Count() FROM Profile WHERE UserType != 'Standard']);
	}

	@IsTest
	static void contains() {
		List<sObject> query = new SmartSOQL()
				.fromObject(Profile.sObjectType)
				.withFields(new SObjectField[] {Profile.Id,
		                                        Profile.Name})
				.contains(Profile.UserType, 'tandar')
				.findAll();

		system.assertEquals(query.size(), [SELECT Count() FROM Profile WHERE UserType LIKE '%tandar%']);
	}

	@IsTest
	static void beginsWith() {
		List<sObject> query = new SmartSOQL()
				.fromObject(Profile.sObjectType)
				.withFields(new SObjectField[] {Profile.Id,
		                                        Profile.Name})
				.beginsWith(Profile.UserType, 'Stand')
				.findAll();

		system.assertEquals(query.size(), [SELECT Count() FROM Profile WHERE UserType LIKE 'Stand%']);
	}

	@IsTest
	static void endWith() {
		List<sObject> query = new SmartSOQL()
				.fromObject(Profile.sObjectType)
				.withFields(new SObjectField[] {Profile.Id,
		                                        Profile.Name})
				.endsWith(Profile.UserType, 'dard')
				.findAll();

		system.assertEquals(query.size(), [SELECT Count() FROM Profile WHERE UserType LIKE '%dard']);
	}

	@IsTest
	static void isNull() {
		List<sObject> query = new SmartSOQL()
				.fromObject(Profile.sObjectType)
				.withFields(new SObjectField[] {Profile.Id,
		                                        Profile.Name})
				.isNull(Profile.UserType)
				.findAll();

		system.assertEquals(query.size(), [SELECT Count() FROM Profile WHERE UserType = null]);
	}

	@IsTest
	static void isNotNull() {
		List<sObject> query = new SmartSOQL()
				.fromObject(Profile.sObjectType)
				.withFields(new SObjectField[] {Profile.Id,
		                                        Profile.Name})
				.isNotNull(Profile.UserType)
				.findAll();

		system.assertEquals(query.size(), [SELECT Count() FROM Profile WHERE UserType != null]);
	}

	@IsTest
	static void betweenInteger() {
		Integer startValue = 10;
		Integer endValue = 40;
		List<sObject> query = new SmartSOQL()
				.fromObject(AppMenuItem.sObjectType)
				.withFields(new SObjectField[] {AppMenuItem.Id,
		                                        AppMenuItem.Name})
				.between(AppMenuItem.SortOrder, startValue, endValue)
				.findAll();

		system.assertEquals(query.size(),
				[SELECT Count() FROM AppMenuItem WHERE (SortOrder >= :startValue AND SortOrder <= :endValue)]);
	}

	@IsTest
	static void betweenLong() {
		Long startValue = 1;
		Long endValue = 40;
		List<sObject> query = new SmartSOQL()
				.fromObject(AppMenuItem.sObjectType)
				.withFields(new SObjectField[] {AppMenuItem.Id,
		                                        AppMenuItem.Name})
				.between(AppMenuItem.SortOrder, startValue, endValue)
				.findAll();

		system.assert(query.size() > 0);
	}

	@IsTest
	static void betweenDouble() {
		Double startValue = 0.0;
		Double endValue = 40.0;
		List<sObject> query = new SmartSOQL()
				.fromObject(EmailTemplate.sObjectType)
				.withFields(new SObjectField[] {EmailTemplate.Id,
		                                        EmailTemplate.Name})
				.between(EmailTemplate.ApiVersion, startValue, endValue)
				.findAll();

		system.assertEquals(query.size(),
				[SELECT Count() FROM EmailTemplate WHERE (ApiVersion >= :startValue AND ApiVersion <= :endValue)]);
	}

	@IsTest
	static void betweenDecimal() {
		Decimal startValue = 10.0;
		Decimal endValue = 40.0;
		List<sObject> query = new SmartSOQL()
				.fromObject(EmailTemplate.sObjectType)
				.withFields(new SObjectField[] {EmailTemplate.Id,
		                                        EmailTemplate.Name})
				.between(EmailTemplate.ApiVersion, startValue, endValue)
				.findAll();

		system.assertEquals(query.size(),
				[SELECT Count() FROM EmailTemplate WHERE (ApiVersion >= :startValue AND ApiVersion <= :endValue)]);
	}

	@IsTest
	static void equalToBoolean() {
		Boolean isActive = true;
		List<sObject> query = new SmartSOQL()
				.fromObject(User.sObjectType)
				.withFields(new SObjectField[] {User.Id,
		                                        User.Name})
				.equalTo(User.IsActive, isActive)
				.findAll();

		system.assertEquals(query.size(), [SELECT Count() FROM User WHERE IsActive = :isActive]);
	}

	@IsTest
	static void equalToLong() {
		Long longValue = 1;
		List<sObject> query = new SmartSOQL()
				.fromObject(AppMenuItem.sObjectType)
				.withFields(new SObjectField[] {AppMenuItem.Id,
		                                        AppMenuItem.Name})
				.equalTo(AppMenuItem.SortOrder, longValue)
				.findAll();

		system.assert(query.size() > 0);
	}

	@IsTest
	static void equalToInteger() {
		Integer intValue = 1;
		List<sObject> query = new SmartSOQL()
				.fromObject(AppMenuItem.sObjectType)
				.withFields(new SObjectField[] {AppMenuItem.Id,
		                                        AppMenuItem.Name})
				.equalTo(AppMenuItem.SortOrder, intValue)
				.findAll();

		system.assert(query.size() > 0);
	}

	@IsTest
	static void equalToDecimal() {
		Decimal startValue = 0.0;

		List<sObject> query = new SmartSOQL()
				.fromObject(EmailTemplate.sObjectType)
				.withFields(new SObjectField[] {EmailTemplate.Id,
		                                        EmailTemplate.Name})
				.equalTo(EmailTemplate.ApiVersion, startValue)
				.findAll();

		system.assertEquals(query.size(), [SELECT Count() FROM EmailTemplate WHERE ApiVersion = :startValue]);
	}

	@IsTest
	static void equalToDouble() {
		Double startValue = 0.0;

		List<sObject> query = new SmartSOQL()
				.fromObject(EmailTemplate.sObjectType)
				.withFields(new SObjectField[] {EmailTemplate.Id,
		                                        EmailTemplate.Name})
				.equalTo(EmailTemplate.ApiVersion, startValue)
				.findAll();

		system.assertEquals(query.size(), [SELECT Count() FROM EmailTemplate WHERE ApiVersion = :startValue]);
	}

	@IsTest
	static void notEqualToBoolean() {
		Boolean isActive = true;
		List<sObject> query = new SmartSOQL()
				.fromObject(User.sObjectType)
				.withFields(new SObjectField[] {User.Id,
		                                        User.Name})
				.notEqualTo(User.IsActive, isActive)
				.findAll();

		system.assertEquals(query.size(), [SELECT Count() FROM User WHERE IsActive != :isActive]);
	}

	@IsTest
	static void equalToDatetime() {
		Datetime value = Datetime.now();

		List<Profile> result = new SmartSOQL()
				.fromObject(Profile.sObjectType)
				.withFields(new SObjectField[] {Profile.Id,
		                                        Profile.Name})
				.equalTo(Profile.CreatedDate, value)
				.findAll();

		system.assertEquals(result.size(), [SELECT COUNT() FROM Profile WHERE CreatedDate = :value]);
	}

	@IsTest
	static void equalToDate() {
		Date value = Date.today();

		List<Contact> result = new SmartSOQL()
				.fromObject(Contact.sObjectType)
				.withFields(new SObjectField[] {Contact.Id,
		                                        Contact.Name})
				.equalTo(Contact.Birthdate, value)
				.withDeletedRows()
				.findAll();

		system.assertEquals(result.size(), [SELECT COUNT() FROM Contact WHERE Birthdate = :value ALL ROWS]);
	}

	@IsTest
	static void withIn() {
		String[] lista = new String[] {'Standard', 'Guest', 'CsnOnly'};

		List<sObject> query = new SmartSOQL()
				.fromObject(Profile.sObjectType)
				.withFields(new SObjectField[] {Profile.Id,
		                                        Profile.Name})
				.withIn(Profile.UserType, 'Standard,Guest,CsnOnly')
				.findAll();

		system.assertEquals(query.size(), [SELECT Count() FROM Profile WHERE UserType in :lista]);
	}

	@IsTest
	static void withInLista() {
		String[] lista = new String[] {'Standard', 'Guest', 'CsnOnly'};

		List<sObject> query = new SmartSOQL()
				.fromObject(Profile.sObjectType)
				.withFields(new SObjectField[] {Profile.Id,
		                                        Profile.Name})
				.withIn(Profile.UserType, lista)
				.findAll();

		system.assertEquals(query.size(), [SELECT Count() FROM Profile WHERE UserType in :lista]);
	}

	@IsTest
	static void greaterThanOrEqualToInteger() {
		Integer startValue = 0;

		List<sObject> query = new SmartSOQL()
				.fromObject(AppMenuItem.sObjectType)
				.withFields(new SObjectField[] {AppMenuItem.Id,
												AppMenuItem.Name})
				.greaterThanOrEqualTo(AppMenuItem.SortOrder, startValue)
				.findAll();

		system.assert(query.size() > 0);
	}

	@IsTest
	static void greaterThanOrEqualToLong() {
		Long startValue = 0;

		List<sObject> query = new SmartSOQL()
				.fromObject(AppMenuItem.sObjectType)
				.withFields(new SObjectField[] {AppMenuItem.Id,
		                                        AppMenuItem.Name})
				.greaterThanOrEqualTo(AppMenuItem.SortOrder, startValue)
				.findAll();

		system.assert(query.size() > 0);
	}

	@IsTest
	static void withNot() {
		List<sObject> query = new SmartSOQL()
				.fromObject(Profile.sObjectType)
				.withFields(new SObjectField[] {Profile.Id,
												Profile.Name})
				.beginGroup()
				.withNot()
				.contains(Profile.UserType, 'tandar')
				.endGroup()
				.findAll();

		system.assertEquals(query.size(), [SELECT Count() FROM Profile WHERE (NOT UserType LIKE '%tandar%')]);
	}

	@IsTest
	static void notEqualToDatetime() {
		Datetime value = Datetime.now();

		List<Profile> result = new SmartSOQL()
				.fromObject(Profile.sObjectType)
				.withFields(new SObjectField[] {Profile.Id,
		                                        Profile.Name})
				.notEqualTo(Profile.CreatedDate, value)
				.findAll();

		system.assertEquals(result.size(), [SELECT COUNT() FROM Profile WHERE CreatedDate != :value]);
	}

	@IsTest
	static void notEqualToDate() {
		Date value = Date.today();

		List<Contact> result = new SmartSOQL()
				.fromObject(Contact.sObjectType)
				.withFields(new SObjectField[] {Contact.Id,
		                                        Contact.Name})
				.notEqualTo(Contact.Birthdate, value)
				.withDeletedRows()
				.findAll();

		system.assertEquals(result.size(), [SELECT COUNT() FROM Contact WHERE Birthdate != :value ALL ROWS]);
	}

	@IsTest
	static void notEqualToInteger() {
		Integer intValue = 1;
		List<sObject> query = new SmartSOQL()
				.fromObject(AppMenuItem.sObjectType)
				.withFields(new SObjectField[] {AppMenuItem.Id,
		                                        AppMenuItem.Name})
				.notEqualTo(AppMenuItem.SortOrder, intValue)
				.findAll();

		system.assert(query.size() > 0);
	}

	@IsTest
	static void notEqualToLong() {
		Long intValue = 1;
		List<sObject> query = new SmartSOQL()
				.fromObject(AppMenuItem.sObjectType)
				.withFields(new SObjectField[] {AppMenuItem.Id,
		                                        AppMenuItem.Name})
				.notEqualTo(AppMenuItem.SortOrder, intValue)
				.findAll();

		system.assert(query.size() > 0);
	}

	@IsTest
	static void notEqualToDecimal() {
		Decimal startValue = 0.0;

		List<sObject> query = new SmartSOQL()
				.fromObject(EmailTemplate.sObjectType)
				.withFields(new SObjectField[] {EmailTemplate.Id,
		                                        EmailTemplate.Name})
				.notEqualTo(EmailTemplate.ApiVersion, startValue)
				.findAll();

		system.assertEquals(query.size(), [SELECT Count() FROM EmailTemplate WHERE ApiVersion != :startValue]);
	}

	@IsTest
	static void notEqualToDouble() {
		Double startValue = 0.0;

		List<sObject> query = new SmartSOQL()
				.fromObject(EmailTemplate.sObjectType)
				.withFields(new SObjectField[] {EmailTemplate.Id,
		                                        EmailTemplate.Name})
				.notEqualTo(EmailTemplate.ApiVersion, startValue)
				.findAll();

		system.assertEquals(query.size(), [SELECT Count() FROM EmailTemplate WHERE ApiVersion != :startValue]);
	}


	@IsTest
	static void betweenDatetime() {
		Datetime value = Datetime.now();
		Datetime endDate = Datetime.now().addDays(30);

		List<Profile> result = new SmartSOQL()
				.fromObject(Profile.sObjectType)
				.withFields(new SObjectField[] {Profile.Id,
		                                        Profile.Name})
				.between(Profile.CreatedDate, value, endDate)
				.findAll();

		system.assertEquals(result.size(),
				[SELECT COUNT() FROM Profile WHERE CreatedDate >= :value AND CreatedDate <= :endDate]);
	}

	@IsTest
	static void betweenDate() {
		Date value = Date.today();
		Date endDate = Date.today().addDays(30);

		List<Contact> result = new SmartSOQL()
				.fromObject(Contact.sObjectType)
				.withFields(new SObjectField[] {Contact.Id,
		                                        Contact.Name})
				.between(Contact.Birthdate, value, endDate)
				.findAll();

		system.assertEquals(result.size(),
				[SELECT COUNT() FROM Contact WHERE Birthdate >=:value AND Birthdate <= :endDate]);
	}

	@IsTest
	static void greaterThanDouble() {
		Double startValue = 0.0;

		List<sObject> query = new SmartSOQL()
				.fromObject(EmailTemplate.sObjectType)
				.withFields(new SObjectField[] {EmailTemplate.Id,
		                                        EmailTemplate.Name})
				.greaterThan(EmailTemplate.ApiVersion, startValue)
				.findAll();

		system.assertEquals(query.size(), [SELECT Count() FROM EmailTemplate WHERE ApiVersion > :startValue]);
	}

	@IsTest
	static void greaterThanDecimal() {
		Decimal startValue = 0.0;

		List<sObject> query = new SmartSOQL()
				.fromObject(EmailTemplate.sObjectType)
				.withFields(new SObjectField[] {EmailTemplate.Id,
		                                        EmailTemplate.Name})
				.greaterThan(EmailTemplate.ApiVersion, startValue)
				.findAll();

		system.assertEquals(query.size(), [SELECT Count() FROM EmailTemplate WHERE ApiVersion > :startValue]);
	}

	@IsTest
	static void greaterThanInteger() {
		Integer startValue = 0;

		List<sObject> query = new SmartSOQL()
				.fromObject(AppMenuItem.sObjectType)
				.withFields(new SObjectField[] {AppMenuItem.Id,
		                                        AppMenuItem.Name})
				.greaterThan(AppMenuItem.SortOrder, startValue)
				.findAll();

		system.assert(query.size() > 0);
	}

	@IsTest
	static void greaterThanLong() {
		Long startValue = 0;

		List<sObject> query = new SmartSOQL()
				.fromObject(AppMenuItem.sObjectType)
				.withFields(new SObjectField[] {AppMenuItem.Id,
		                                        AppMenuItem.Name})
				.greaterThan(AppMenuItem.SortOrder, startValue)
				.findAll();

		system.assert(query.size() > 0);
	}

	@IsTest
	static void greaterThanDatetime() {
		Datetime value = Datetime.now();

		List<Profile> result = new SmartSOQL()
				.fromObject(Profile.sObjectType)
				.withFields(new SObjectField[] {Profile.Id,
		                                        Profile.Name})
				.greaterThan(Profile.CreatedDate, value)
				.findAll();

		system.assertEquals(result.size(),
				[SELECT COUNT() FROM Profile WHERE CreatedDate > :value]);
	}

	@IsTest
	static void greaterThanDate() {
		Date value = Date.today();

		List<Contact> result = new SmartSOQL()
				.fromObject(Contact.sObjectType)
				.withFields(new SObjectField[] {Contact.Id,
		                                        Contact.Name})
				.greaterThan(Contact.Birthdate, value)
				.findAll();

		system.assertEquals(result.size(),
				[SELECT COUNT() FROM Contact WHERE Birthdate > :value]);
	}
}
