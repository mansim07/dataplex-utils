#####################################################################################################################
#    Name: create_failed_records
#    Description: This BQ stored procedure will read the failed records query from the latest DQ Execution, 
#                 extract failed records and materialize in a BQ table in json format.
#    Changes: Replace "your-project-id" and "your-dq-dataset-id" before execution 
#    PS: This is a sample code. Extend to meet your need. 
#####################################################################################################################

CREATE OR REPLACE PROCEDURE `your-project-id.your-dq-dataset-id.create_failed_records`()
BEGIN
DECLARE
  project_id STRING;
DECLARE
  dataset_id STRING;
DECLARE
  _queryComplexRuleString STRING;
DECLARE
  _querySimpleRuleString STRING;
DECLARE
  _queryCreateTableString STRING;
DECLARE
  _querySimpleRuleWithRefString STRING;
SET
  project_id="your-project-id";
SET
  dataset_id="your-dq-dataset-id";
SET
  _queryCreateTableString= FORMAT("""
  CREATE TABLE IF NOT EXISTS `%s`.%s.dq_failed_records_json
(
  _dq_validation_column_id STRING,
  _dq_validation_column_value STRING,
  _dq_validation_complex_rule_validation_errors_count INT64,
  _dq_validation_complex_rule_validation_success_flag BOOL,
  _dq_validation_dimension STRING,
  _dq_validation_invocation_id STRING,
  _dq_validation_rule_binding_id STRING,
  _dq_validation_rule_id STRING,
  _dq_validation_simple_rule_row_is_valid BOOL,
  custom_sql_statement_validation_errors JSON,
  reference_values JSON
) """,project_id,dataset_id);
EXECUTE IMMEDIATE
  (_queryCreateTableString); FOR record IN (
  SELECT
    failed_records_query,
    rule_id,
    table_id,
    execution_ts,
    complex_rule_validation_errors_count
  FROM
    `your-project-id`.your-dq-dataset-id.dq_results
  WHERE
    (TRIM(failed_records_query) != ""
      AND failed_records_query IS NOT NULL)
    AND invocation_id=(
    SELECT
      invocation_id
    FROM
      `your-project-id`.your-dq-dataset-id.dq_results
    WHERE
      execution_ts=(
      SELECT
        MAX(execution_ts)
      FROM
        `your-project-id`.your-dq-dataset-id.dq_results)) ) DO
SET
  _queryComplexRuleString=FORMAT("""INSERT INTO `%s`.%s.dq_failed_records_json Select _dq_validation_column_id,cast(_dq_validation_column_value as string),_dq_validation_complex_rule_validation_errors_count,_dq_validation_complex_rule_validation_success_flag,_dq_validation_dimension,_dq_validation_invocation_id,_dq_validation_rule_binding_id,_dq_validation_rule_id,_dq_validation_simple_rule_row_is_valid,to_json(custom_sql_statement_validation_errors) as custom_sql_statement_validation_errors, NULL as reference_values from (%s) """,project_id,dataset_id,record.failed_records_query);
SET
  _querySimpleRuleString=FORMAT("""INSERT INTO `%s`.%s.dq_failed_records_json Select _dq_validation_column_id,cast(_dq_validation_column_value as string),_dq_validation_complex_rule_validation_errors_count,_dq_validation_complex_rule_validation_success_flag,_dq_validation_dimension,_dq_validation_invocation_id,_dq_validation_rule_binding_id,_dq_validation_rule_id,_dq_validation_simple_rule_row_is_valid, to_json((Select STRUCT(_dq_validation_column_id as column_id,_dq_validation_column_value as column_value))) as custom_sql_statement_validation_errors, NULL as reference_values from (%s) input """,project_id,dataset_id,record.failed_records_query);
SET
  _querySimpleRuleWithRefString=FORMAT("""INSERT INTO `%s`.%s.dq_failed_records_json Select _dq_validation_column_id,cast(_dq_validation_column_value as string),_dq_validation_complex_rule_validation_errors_count,_dq_validation_complex_rule_validation_success_flag,_dq_validation_dimension,_dq_validation_invocation_id,_dq_validation_rule_binding_id,_dq_validation_rule_id,_dq_validation_simple_rule_row_is_valid, to_json((Select STRUCT(_dq_validation_column_id as column_id,_dq_validation_column_value as column_value))) as custom_sql_statement_validation_errors,  to_json_string((SELECT AS STRUCT * EXCEPT ( _dq_validation_column_id ,_dq_validation_column_value ,_dq_validation_complex_rule_validation_errors_count ,_dq_validation_complex_rule_validation_success_flag,_dq_validation_dimension,_dq_validation_invocation_id ,_dq_validation_rule_binding_id ,_dq_validation_rule_id ,_dq_validation_simple_rule_row_is_valid ,custom_sql_statement_validation_errors) FROM unnest([input]))) as reference_values  from (%s) input """,project_id,dataset_id,record.failed_records_query);
IF
  (record.complex_rule_validation_errors_count IS NOT NULL) THEN
EXECUTE IMMEDIATE
  (_queryComplexRuleString);
  ELSE
BEGIN
EXECUTE IMMEDIATE
  (_querySimpleRuleWithRefString); EXCEPTION
    WHEN ERROR THEN EXECUTE IMMEDIATE (_querySimpleRuleString);
END
  ;
END IF
  ;
END
  FOR;
END

# Call the  stored procedure 
CALL `your-project-id`.your-dq-dataset-id.create_failed_records()