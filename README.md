## About CRON EXPRESSIONS PARSER

This project helps to convert cron expression into a more readable format.

### Developer Setup
* Install ruby 2.7.0
* run bundle install  

And you are good to go..  
To execute the program their is a runner file ``.\runner.rb``, which need to be called using the command below
``ruby ./runner.rb "*/15 0 1,15 * 1-5 /usr/bin/find"``


### Development Approach
As per current requirement the parser have multiple formats which can be parser. Some of them are listed below.
```
* 5 : fixed value
* 5-10 :  range
* */5 : frequency
* 5,7 : list of values 
```
* The runner class calls the ``CronExecutorParser`` class, which takes care of execution and display of errors and results. 
* All the different format has a validator in ``Validate`` class.
* The range for each cron input(min, hours, day_of_month,.. etc) and other constant are listed in ``constants.rb`` file.
* And for each format there is a seperate parser method in ``CronParser`` class. Currently all the parser is parsed based on the cron input object which needs to be modified such that it is only dependent on the value of the cron object.
* Test Specs can be added or modified in `./spec` directory, which can be class specific or module specific.
* Error handeling is done to some extent and more are to be added.
