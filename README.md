## About CRON EXPRESSIONS PARSER

This project helps to convert cron expression into a more readable format.


### Supported format

As a part of requirement current format supports multiple formats which can be parsed.

```your-program "*/15 0 1,15 * 1-5 /usr/bin/find"```
```
* 5 : fixed value
* 5-10 :  range
* */5 : frequency
* 5,7 : list of values 
```
