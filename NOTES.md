# Luna Project Prompt Answers and Discussion

I was able to create a functioning deployment of an ECS service running a configurable web app that runs a background task smoke test.

___
> **What are some ways to build a dummy endpoint for the sake of testing the above spike?**

For local testing, it would be easiest to set up a simple Python based localhost endpoint with
```
python3 -m http.server
```

However, for testing in a deployed setting, the app can have another path that could have a configurable http response. FastAPI makes it easy to send custom http response codes. In a production ready setting, another page on the app could have a button or toggle that changes responses for a test URL.

___

___
> **How would you make this more production ready**

I would create a custom Cloudwatch Dashboard that has uptime of the ECS service and use custom metrics filters to capture that there is a steady stream of valid smoke test pings. When an error occurs or a request fails, the custom metrics filter can capture those data points and display the errors as spikes on a graph. Furthermore, the metrics can be used to set up Cloudwatch alarms that could then trigger downstream messaging through the use of SNS. For example, I could set up PagerDuty pages or Slack alerts if a certain threshold of smoketest errors were to breach.
___

___
> ***How would you plan out steps to figure out unknowns when it comes to making it production-ready?*

In general, I would review what I've learned about making a product highly available and that it meets the bar for an AWS Well-Architected Framework. In terms of battle-testing the product, there are many tools to check if the service can handle traffic or load. These tools include gatling, locust, jmeter. I could run more infosec driven tests with BurpSuite. With this being an internal tool, I probably wouldn't require a third-party service to give an app-sec review, but I would consider that aspect for public-facing web apps.
___

___
> **What did I think of this take-home project?**

It was an engaging project -- I really liked it. I am now very glad to have this in my github repository and I will probably refer to it many many many times in the future.
___

___
> **My thoughts on how I would approach this problem outside of an interview setting:**

If I were in charge of speccing out this task, I might not bother making a web app. I would make a simple and small AWS Lambda Function that basically runs the meat of the background task that I have in `main.py`. Essentially, the Lambda will make requests in the same manner and even use environment variables to be configurable. A Lambda could be triggered with a cron and the function would log its output in the same way that I have it set up to log to Cloudwatch Logs. As I stated above, the cloudwatch logs can provide information towards making a custom metrics filter. Alternatively, Lambda has basic built-in metrics that I can query directly from AWS Cloudwatch and create a pretty easy alarming strategy for any function invocation errors.
___
