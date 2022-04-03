import random, sys

### Takes in two arguments which is the number of rows generated and the name of table
def main():
    number_line = int(sys.argv[1])
    table_name = sys.argv[2]

    with open('{}.sql'.format(table_name), 'w') as f:
        f.write('insert into {} (a, b, c) values\n'.format(table_name))
        for n in range(number_line):
            ### Customize the table here
            a = n
            b = random.randint(0, 1000)
            c = random.randint(0, 499)
        
            if n == number_line - 1:
                f.write('({}, {}, {});'.format(a, b, c))
            else:
                f.write('({}, {}, {}),\n'.format(a, b, c))   
        f.close()
if __name__ == "__main__":
    main()