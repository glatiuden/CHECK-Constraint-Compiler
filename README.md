## Instructions
### Contents
Our main program, CHECK Constraint Compiler can be found in `create_function.sql`.

### Usage / Testing
You may download and execute the following script in sequence
- `create_tables.sql`: contains some sample tables
- `execute_function.sql`: to create a CHECK constraint based on the tables in `create_tables.sql`
- `test_cases.sql`: test cases to the CHECK constraint created in `execute_function.sql`
- `tear_down.sql`: to remove all the tables/functions/triggers that was created

### Performance Test
You may download and execute the following script in sequence
- `performance_test.sql`: set up tables and the CHECK constraint for the performance test
- `generate_data.py`: to generate random input to insert into the tables
