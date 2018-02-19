/**
 * @author  Fernando Sousa
 * @version 0.10
 * @createon 16/02/18.
 *
 * This class is a Smart SOQL generator using Fluent Interface principles
 * See more about at: {@link https://en.wikipedia.org/wiki/Fluent_interface}
 */
public class SmartSOQL {
	private String query;
	private SObjectType sObjectPrincipal;

	public SmartSOQL() {
		query = '';
	}

	/*
	* Specify the main object of this query
	* @param    objecType Indicate the type of main Object for sample Account.sObjectType
	*
	* @return   SmartSOQL   return this class to continue concatenate expressions
	*/
	public SmartSOQL fromObject(SObjectType objecType) {
		this.sObjectPrincipal = objecType;

		return this;
	}

	/*
	* set fields to query
	* @param    fields      the String fields you want to query separeted with comma, sample: Id, Name
	*
	* @return   SmartSOQL   return this class to continue concatenate expressions
	*/
	public SmartSOQL withFields(String fields) {
		return withFields(fields.replaceAll(' ', '').split(','));
	}

	/*
	* set fields to query
	* @param    fields      the array of string fields you want to query, sample: new String[] {'Id', 'Name' }
	*
	* @return   SmartSOQL   return this class to continue concatenate expressions
	*/
	public SmartSOQL withFields(String[] fields) {
		query = 'SELECT ';
		query += String.join(fields, ', ');
		query += ' FROM ';
		query += this.sObjectPrincipal.getDescribe().getName();

		return this;
	}

	/*
	* set fields to query
	* @param    fields      the array of SObjectField fields you want to query, sample: new SObjectField[] {Profile.Id, Profile.Name}
	*
	* @return   SmartSOQL   return this class to continue concatenate expressions
	*/
	public SmartSOQL withFields(SObjectField[] fields) {
		String[] stringFields = new String[]{};

		for (SObjectField field : fields) {
			stringFields.add(field.getDescribe().getName());
		}

		return withFields(stringFields);
	}

	/*
	* Execute the query and return the data
	*
	* @return   List<sObject>   return the result of your query
	*/
	public List<sObject> findAll() {
		system.debug(query);
		return Database.query(query);
	}

	/*
	* Get the Query built using SmartSOQL
	*
	* @return   String   return the your query
	*/
	public String getQuery() {
		system.debug(query);
		return query;
	}

	/*
	* Execute the Count() with this query
	*
	* @return   Integer   return the number of records affected with your query
	*/
	public Integer count() {
		if (String.isBlank(query))
			withFields('');

		query = query.replace(query.substringBetween('SELECT', 'FROM'), ' COUNT() ');

		return Database.countQuery(query);
	}

	/*
	* Execute the query and return the first record, force to use LIMIT 1
	*
	* @return   sObject   return the result of your query
	*/
	public sObject findFirst() {
		query = getQuery().substringBeforeLast('LIMIT');
		query += ' LIMIT 1';

		return Database.query(query);
	}

	public SmartSOQL orderBy(SObjectField field) {
		return orderBy(field.getDescribe().getName());
	}

	public SmartSOQL orderBy(String field) {
		return orderBy(field, null);
	}

	public SmartSOQL orderBy(SObjectField field, ORDERBY sortBy) {
		return orderBy(field.getDescribe().getName(), sortBy);
	}

	public SmartSOQL orderBy(String field, ORDERBY sortBy) {
		if (query.contains('ORDER BY'))
			query += ', ';
		else
			query += ' ORDER BY ';

		query += field;
		query += getOrderBy(sortBy);

		return this;
	}

	/*
	* set the LIMIT of rows to get
	* @param    limitOfRows     the number of rows to limit in this query
	* @return   SmartSOQL       return this class to continue concatenate expressions
	*/
	public SmartSOQL withLimit(Integer limitOfRows) {
		query = query.substringBeforeLast('LIMIT');
		query += ' LIMIT ';
		query += limitOfRows;

		return this;
	}

	public SmartSOQL withOr() {
		if (!query.endsWithIgnoreCase('AND') && !query.endsWithIgnoreCase('OR') && !query.endsWithIgnoreCase('('))
			query += ' OR';

		return this;
	}

	public SmartSOQL withAnd() {
		if (!query.endsWithIgnoreCase('AND') && !query.endsWithIgnoreCase('OR') && !query.endsWithIgnoreCase('('))
			query += ' AND';

		return this;
	}

	public SmartSOQL equalTo(SObjectField field, String value) {
		return equalTo(field.getDescribe().getName(), value);
	}

	public SmartSOQL equalTo(String field, String value) {
		checkWhereAndJunction();
		query += ' ' + field;
		query += ' = ';
		query += '\'' + value + '\'';

		return this;
	}

	public SmartSOQL equalTo(SObjectField field, Boolean value) {
		return equalTo(field.getDescribe().getName(), value);
	}

	public SmartSOQL equalTo(String field, Boolean value) {
		checkWhereAndJunction();
		query += ' ' + field;
		query += ' = ';
		query += value ? 'TRUE' : 'FALSE';

		return this;
	}

	public SmartSOQL equalTo(SObjectField field, Integer value) {
		return equalTo(field.getDescribe().getName(), value);
	}

	public SmartSOQL equalTo(String field, Integer value) {
		return equalTo(field, (Long)value);
	}

	public SmartSOQL equalTo(SObjectField field, Long value) {
		return equalTo(field.getDescribe().getName(), value);
	}

	public SmartSOQL equalTo(String field, Long value) {
		checkWhereAndJunction();
		query += ' ' + field;
		query += ' = ';
		query += value;

		return this;
	}

	public SmartSOQL equalTo(SObjectField field, Double value) {
		return equalTo(field.getDescribe().getName(), value);
	}

	public SmartSOQL equalTo(String field, Double value) {
		return equalTo(field, (Decimal)value);
	}

	public SmartSOQL equalTo(SObjectField field, Decimal value) {
		return equalTo(field.getDescribe().getName(), value);
	}

	public SmartSOQL equalTo(String field, Decimal value) {
		checkWhereAndJunction();
		query += ' ' + field;
		query += ' = ';
		query += value;

		return this;
	}

	public SmartSOQL equalTo(SObjectField field, Datetime value) {
		return equalTo(field.getDescribe().getName(), value);
	}

	public SmartSOQL equalTo(String field, Datetime value) {
		checkWhereAndJunction();
		query += ' ' + field;
		query += ' = ';
		query += value.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');

		return this;
	}

	public SmartSOQL equalTo(SObjectField field, Date value) {
		return equalTo(field.getDescribe().getName(), value);
	}

	public SmartSOQL equalTo(String field, Date value) {
		checkWhereAndJunction();
		query += ' ' + field;
		query += ' = ';
		query += ((Datetime)value).formatGMT('yyyy-MM-dd');

		return this;
	}

	public SmartSOQL notEqualTo(SObjectField field, Integer value) {
		return notEqualTo(field.getDescribe().getName(), value);
	}

	public SmartSOQL notEqualTo(String field, Integer value) {
		return notEqualTo(field, (Long)value);
	}

	public SmartSOQL notEqualTo(SObjectField field, Long value) {
		return notEqualTo(field.getDescribe().getName(), value);
	}

	public SmartSOQL notEqualTo(String field, Long value) {
		checkWhereAndJunction();
		query += ' ' + field;
		query += ' != ';
		query += value;

		return this;
	}

	public SmartSOQL notEqualTo(SObjectField field, Double value) {
		return notEqualTo(field.getDescribe().getName(), value);
	}

	public SmartSOQL notEqualTo(String field, Double value) {
		return notEqualTo(field, (Decimal)value);
	}

	public SmartSOQL notEqualTo(SObjectField field, Decimal value) {
		return notEqualTo(field.getDescribe().getName(), value);
	}

	public SmartSOQL notEqualTo(String field, Decimal value) {
		checkWhereAndJunction();
		query += ' ' + field;
		query += ' != ';
		query += value;

		return this;
	}

	public SmartSOQL notEqualTo(SObjectField field, String value) {
		return notEqualTo(field.getDescribe().getName(), value);
	}

	public SmartSOQL notEqualTo(String field, String value) {
		checkWhereAndJunction();
		query += ' ' + field;
		query += ' != ';
		query += '\'' + value + '\'';

		return this;
	}

	public SmartSOQL notEqualTo(SObjectField field, Datetime value) {
		return equalTo(field.getDescribe().getName(), value);
	}

	public SmartSOQL notEqualTo(String field, Datetime value) {
		checkWhereAndJunction();
		query += ' ' + field;
		query += ' != ';
		query += value.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');

		return this;
	}

	public SmartSOQL notEqualTo(SObjectField field, Date value) {
		return equalTo(field.getDescribe().getName(), value);
	}

	public SmartSOQL notEqualTo(String field, Date value) {
		checkWhereAndJunction();
		query += ' ' + field;
		query += ' != ';
		query += ((Datetime)value).formatGMT('yyyy-MM-dd');

		return this;
	}

	public SmartSOQL notEqualTo(SObjectField field, Boolean value) {
		return notEqualTo(field.getDescribe().getName(), value);
	}

	public SmartSOQL notEqualTo(String field, Boolean value) {
		checkWhereAndJunction();
		query += ' ' + field;
		query += ' != ';
		query += value ? 'TRUE' : 'FALSE';

		return this;
	}

	public SmartSOQL between(SObjectField field, Integer startValue, Integer endValue) {
		return between(field.getDescribe().getName(), startValue, endValue);
	}

	public SmartSOQL between(String field, Integer startValue, Integer endValue) {
		return between(field, (Long)startValue, (Long)endValue);
	}

	public SmartSOQL between(SObjectField field, Long startValue, Long endValue) {
		return between(field.getDescribe().getName(), startValue, endValue);
	}

	public SmartSOQL between(String field, Long startValue, Long endValue) {
		checkWhereAndJunction();
		query += ' (' + field;
		query += ' >= ';
		query += startValue;
		query += ' AND ' + field;
		query += ' <= ';
		query += endValue;
		query += ')';

		return this;
	}

	public SmartSOQL between(SObjectField field, Double startValue, Double endValue) {
		return between(field.getDescribe().getName(), startValue, endValue);
	}

	public SmartSOQL between(String field, Double startValue, Double endValue) {
		return between(field, (Decimal)startValue, (Decimal)endValue);
	}

	public SmartSOQL between(SObjectField field, Decimal startValue, Decimal endValue) {
		return between(field.getDescribe().getName(), startValue, endValue);
	}

	public SmartSOQL between(String field, Decimal startValue, Decimal endValue) {
		checkWhereAndJunction();
		query += ' (' + field;
		query += ' >= ';
		query += startValue;
		query += ' AND ' + field;
		query += ' <= ';
		query += endValue;
		query += ')';

		return this;
	}

	public SmartSOQL between(SObjectField field, Datetime startValue, Datetime endValue) {
		return between(field.getDescribe().getName(), startValue, endValue);
	}

	public SmartSOQL between(String field, Datetime startValue, Datetime endValue) {
		checkWhereAndJunction();
		query += ' (' + field;
		query += ' >= ';
		query += startValue.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
		query += ' AND ' + field;
		query += ' <= ';
		query += endValue.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
		query += ')';

		return this;
	}

	public SmartSOQL between(SObjectField field, Date startValue, Date endValue) {
		return between(field.getDescribe().getName(), startValue, endValue);
	}

	public SmartSOQL between(String field, Date startValue, Date endValue) {
		checkWhereAndJunction();
		query += ' (' + field;
		query += ' >= ';
		query += ((Datetime)startValue).formatGMT('yyyy-MM-dd');
		query += ' AND ' + field;
		query += ' <= ';
		query += ((Datetime)endValue).formatGMT('yyyy-MM-dd');
		query += ')';

		return this;
	}

	public SmartSOQL withIn(SObjectField field, String values) {
		return withIn(field.getDescribe().getName(), values);
	}

	public SmartSOQL withIn(String field, String values) {
		return withIn(field, values.split(','));
	}

	public SmartSOQL withIn(SObjectField field, String[] values) {
		return withIn(field.getDescribe().getName(), values);
	}

	public SmartSOQL withIn(String field, String[] values) {
		String value = '\'' + String.join(values, '\', \'') + '\'';

		checkWhereAndJunction();
		query += ' ' + field;
		query += ' in (';
		query += value + ')';

		return this;
	}

	public SmartSOQL greaterThan(SObjectField field, Double value) {
		return greaterThan(field.getDescribe().getName(), (Decimal)value);
	}

	public SmartSOQL greaterThan(SObjectField field, Decimal value) {
		return greaterThan(field.getDescribe().getName(), value);
	}

	public SmartSOQL greaterThan(String field, Double value) {
		return greaterThan(field, (Decimal)value);
	}

	public SmartSOQL greaterThan(String field, Decimal value) {
		checkWhereAndJunction();
		query += ' ' + field;
		query += ' > ';
		query += value;

		return this;
	}

	public SmartSOQL greaterThan(SObjectField field, Integer value) {
		return greaterThan(field.getDescribe().getName(), value);
	}

	public SmartSOQL greaterThan(String field, Integer value) {
		return greaterThan(field, (Long)value);
	}

	public SmartSOQL greaterThan(SObjectField field, Long value) {
		return greaterThan(field.getDescribe().getName(), (Decimal)value);
	}

	public SmartSOQL greaterThan(String field, Long value) {
		checkWhereAndJunction();
		query += ' ' + field;
		query += ' > ';
		query += value;

		return this;
	}

	public SmartSOQL greaterThan(SObjectField field, Date value) {
		return greaterThan(field.getDescribe().getName(), value);
	}

	public SmartSOQL greaterThan(String field, Date value) {
		checkWhereAndJunction();
		query += ' ' + field;
		query += ' > ';
		query += ((Datetime)value).formatGMT('yyyy-MM-dd');

		return this;
	}

	public SmartSOQL greaterThan(SObjectField field, Datetime value) {
		return greaterThan(field.getDescribe().getName(), value);
	}

	public SmartSOQL greaterThan(String field, Datetime value) {
		checkWhereAndJunction();
		query += ' ' + field;
		query += ' > ';
		query += value.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');

		return this;
	}

	public SmartSOQL lessThan(SObjectField field, Double value) {
		return lessThan(field.getDescribe().getName(), value);
	}

	public SmartSOQL lessThan(String field, Double value) {
		return lessThan(field, (Decimal)value);
	}

	public SmartSOQL lessThan(SObjectField field, Decimal value) {
		return lessThan(field.getDescribe().getName(), value);
	}

	public SmartSOQL lessThan(String field, Decimal value) {
		checkWhereAndJunction();
		query += ' ' + field;
		query += ' < ';
		query += value;

		return this;
	}

	public SmartSOQL lessThan(SObjectField field, Integer value) {
		return lessThan(field.getDescribe().getName(), value);
	}

	public SmartSOQL lessThan(String field, Integer value) {
		return lessThan(field, (Long)value);
	}

	public SmartSOQL lessThan(SObjectField field, Long value) {
		return lessThan(field.getDescribe().getName(), value);
	}

	public SmartSOQL lessThan(String field, Long value) {
		checkWhereAndJunction();
		query += ' ' + field;
		query += ' < ';
		query += value;

		return this;
	}

	public SmartSOQL lessThan(SObjectField field, Date value) {
		return lessThan(field.getDescribe().getName(), value);
	}

	public SmartSOQL lessThan(String field, Date value) {
		checkWhereAndJunction();
		query += ' ' + field;
		query += ' < ';
		query += ((Datetime)value).formatGMT('yyyy-MM-dd');

		return this;
	}

	public SmartSOQL lessThan(SObjectField field, Datetime value) {
		return greaterThan(field.getDescribe().getName(), value);
	}

	public SmartSOQL lessThan(String field, Datetime value) {
		checkWhereAndJunction();
		query += ' ' + field;
		query += ' < ';
		query += value.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');

		return this;
	}

	public SmartSOQL greaterThanOrEqualTo(SObjectField field, Double value) {
		return greaterThanOrEqualTo(field.getDescribe().getName(), value);
	}

	public SmartSOQL greaterThanOrEqualTo(String field, Double value) {
		return greaterThanOrEqualTo(field, (Decimal)value);
	}

	public SmartSOQL greaterThanOrEqualTo(SObjectField field, Decimal value) {
		return greaterThanOrEqualTo(field.getDescribe().getName(), value);
	}

	public SmartSOQL greaterThanOrEqualTo(String field, Decimal value) {
		checkWhereAndJunction();
		query += ' ' + field;
		query += ' >= ';
		query += value;

		return this;
	}

	public SmartSOQL greaterThanOrEqualTo(SObjectField field, Integer value) {
		return greaterThanOrEqualTo(field.getDescribe().getName(), value);
	}

	public SmartSOQL greaterThanOrEqualTo(String field, Integer value) {
		return greaterThanOrEqualTo(field, (Long)value);
	}

	public SmartSOQL greaterThanOrEqualTo(SObjectField field, Long value) {
		return greaterThanOrEqualTo(field.getDescribe().getName(), value);
	}

	public SmartSOQL greaterThanOrEqualTo(String field, Long value) {
		checkWhereAndJunction();
		query += ' ' + field;
		query += ' >= ';
		query += value;

		return this;
	}

	public SmartSOQL greaterThanOrEqualTo(SObjectField field, Date value) {
		return greaterThanOrEqualTo(field.getDescribe().getName(), value);
	}

	public SmartSOQL greaterThanOrEqualTo(String field, Date value) {
		checkWhereAndJunction();
		query += ' ' + field;
		query += ' >= ';
		query += ((Datetime)value).formatGMT('yyyy-MM-dd');

		return this;
	}

	public SmartSOQL greaterThanOrEqualTo(SObjectField field, Datetime value) {
		return greaterThanOrEqualTo(field.getDescribe().getName(), value);
	}

	public SmartSOQL greaterThanOrEqualTo(String field, Datetime value) {
		checkWhereAndJunction();
		query += ' ' + field;
		query += ' >= ';
		query += value.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');

		return this;
	}

	public SmartSOQL lessThanOrEqualTo(SObjectField field, Double value) {
		return lessThanOrEqualTo(field.getDescribe().getName(), value);
	}

	public SmartSOQL lessThanOrEqualTo(String field, Double value) {
		return lessThanOrEqualTo(field, (Decimal)value);
	}

	public SmartSOQL lessThanOrEqualTo(SObjectField field, Decimal value) {
		return lessThanOrEqualTo(field.getDescribe().getName(), value);
	}

	public SmartSOQL lessThanOrEqualTo(String field, Decimal value) {
		checkWhereAndJunction();
		query += ' ' + field;
		query += ' <= ';
		query += value;

		return this;
	}

	public SmartSOQL lessThanOrEqualTo(SObjectField field, Integer value) {
		return lessThanOrEqualTo(field.getDescribe().getName(), value);
	}

	public SmartSOQL lessThanOrEqualTo(String field, Integer value) {
		return lessThanOrEqualTo(field, (Long)value);
	}

	public SmartSOQL lessThanOrEqualTo(SObjectField field, Long value) {
		return lessThanOrEqualTo(field.getDescribe().getName(), value);
	}

	public SmartSOQL lessThanOrEqualTo(String field, Long value) {
		checkWhereAndJunction();
		query += ' ' + field;
		query += ' <= ';
		query += value;

		return this;
	}

	public SmartSOQL lessThanOrEqualTo(SObjectField field, Date value) {
		return lessThanOrEqualTo(field.getDescribe().getName(), value);
	}

	public SmartSOQL lessThanOrEqualTo(String field, Date value) {
		checkWhereAndJunction();
		query += ' ' + field;
		query += ' <= ';
		query += ((Datetime)value).formatGMT('yyyy-MM-dd');

		return this;
	}

	public SmartSOQL lessThanOrEqualTo(SObjectField field, Datetime value) {
		return lessThanOrEqualTo(field.getDescribe().getName(), value);
	}

	public SmartSOQL lessThanOrEqualTo(String field, Datetime value) {
		checkWhereAndJunction();
		query += ' ' + field;
		query += ' <= ';
		query += value.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');

		return this;
	}

	public SmartSOQL contains(SObjectField field, String value) {
		return contains(field.getDescribe().getName(), value);
	}

	public SmartSOQL contains(String field, String value) {
		checkWhereAndJunction();
		query += ' ' + field;
		query += ' LIKE ';
		query += '\'%' + value + '%\'';

		return this;
	}

	public SmartSOQL beginsWith(SObjectField field, String value) {
		return beginsWith(field.getDescribe().getName(), value);
	}

	public SmartSOQL beginsWith(String field, String value) {
		checkWhereAndJunction();
		query += ' ' + field;
		query += ' LIKE ';
		query += '\'' + value + '%\'';

		return this;
	}

	public SmartSOQL endsWith(SObjectField field, String value) {
		return endsWith(field.getDescribe().getName(), value);
	}

	public SmartSOQL endsWith(String field, String value) {
		checkWhereAndJunction();
		query += ' ' + field;
		query += ' LIKE ';
		query += '\'%' + value + '\'';

		return this;
	}

	public SmartSOQL isNull(SObjectField field) {
		return isNull(field.getDescribe().getName());
	}

	public SmartSOQL isNull(String field) {
		checkWhereAndJunction();
		query += ' ' + field;
		query += ' = null';

		return this;
	}

	public SmartSOQL isNotNull(SObjectField field) {
		return isNotNull(field.getDescribe().getName());
	}

	public SmartSOQL isNotNull(String field) {
		checkWhereAndJunction();
		query += ' ' + field;
		query += ' != null';

		return this;
	}

	public SmartSOQL beginGroup() {
		checkWhereAndJunction();
		query += '(';

		return this;
	}

	public SmartSOQL endGroup() {
		query += ')';

		return this;
	}

	public SmartSOQL withNot() {
		query += ' NOT';

		return this;
	}

	public SmartSOQL withDeletedRows() {
		query += ' ALL ROWS';

		return this;
	}

	/*
	* get the String OrderBy syntax
	* @param    sortBy      Order by Enum
	* @return   String      return the String syntax SOQL
	*/
	private String getOrderBy(ORDERBY sortBy) {
		return ORDERBY.ASCENDING.equals(sortBy) ? ' ASC' :
		       ORDERBY.DESCENDING.equals(sortBy) ? ' DESC' :
		       ORDERBY.ASCENDING_NULL_FIRST.equals(sortBy) ? ' ASC NULL FIRST' :
		       ORDERBY.ASCENDING_NULL_LAST.equals(sortBy) ? ' ASC NULL LAST' :
		       ORDERBY.DESCENDING_NULL_FIRST.equals(sortBy) ? ' DESC NULL FIRST' :
		       ORDERBY.DESCENDING_NULL_LAST.equals(sortBy) ? ' DESC NULL LAST' : '';
	}

	private void checkWhereAndJunction() {
		if (!query.contains('WHERE'))
			query += ' WHERE';
		else if (!query.endsWithIgnoreCase('AND') && !query.endsWithIgnoreCase('OR') && !query.endsWithIgnoreCase('('))
			query += ' AND';
	}

	public ENUM ORDERBY {
			ASCENDING,
			DESCENDING,
			ASCENDING_NULL_FIRST,
			ASCENDING_NULL_LAST,
			DESCENDING_NULL_FIRST,
			DESCENDING_NULL_LAST
	}
}
