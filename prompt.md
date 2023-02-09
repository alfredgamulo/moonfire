# Luna Infra Take-Home Project Prompt

## The Quest!

Hack together a bare-bones spike of a solution to [smoke test] some mock API endpoints.

[smoke test]: https://en.wikipedia.org/wiki/Smoke_testing_(software)

### Some context

When you have backends that expose both REST and GraphQL APIs, or rely on
periodic jobs or downstream endpoints working, sometimes it's just nice to have
something that you can run during an infrastructure deploy to check on whether
everything is still running as expected, from the application POV. In corporate
speak you can consider this to be what an infra team could use to ensure we're
meeting SLAs we have with other app teams.


### Task Implementation Details

The aim of this exercise is to see how you think about this, ideally see some
code written, but depending on how you approach this that may not be necessary.

While we would like to see your coding style, it is more important to us to
understand how you think about the problem and organize your work.

Imagine you are spiking out the problem at work and want to show a proof of
concept / write up an engineering spec.

1. Create a Dockerfile to deploy something like a barebones web app or
  process that generates traffic to an endpoint: i.e. every 10s makes a request
  to a URL and logs whether or not it is healthy.

  * Pick any domain to query for now, for example https://getluna.com or
    https://availity.com/status/

  * Keep in mind while this proof-of-concept is just making GET requests, we
    want an extensible solution for generating traffic for other kinds of HTTP
    requests too.

  * Choose whatever language or server or technology you think is appropriate
    for this problem.

  * Explain your decision-making thought process in the README.md or however
    you want to organize the Markdown.

  * If you have thoughts on how you would approach this problem outside of an
    interview setting (e.g. considering third party options you have experience
    with or know of), jot them down.

  * Suggested for quicker iteration times: Using [Hashicorp Packer] to build
    your Dockerfile.

2. Include instructions on how to get your solution running, if you made
something that runs.

3. Answer the following:

  * What are some ways to build a dummy endpoint for the sake of testing the
    above spike smoke-testing app, that you could easily toggle the status of?
    The simplest? More complicated approaches? Pro/cons? What do you prefer?

[Hashicorp Packer]: https://www.packer.io/

4. Answer the following in your README:

  * How would you make this more production-ready?
  * How would you plan out steps to figure out unknowns when it comes to making
    it production-ready?
  * What did you think of this take-home project? Be honest!


## Submission

Please either give us access to a *private* repository hosted on GitHub or your
favorite git hosting service, or just send over a zip of your work that
includes the .git/ directory.

Pre-submission checklist for your implementation:

1. A README that describes your approach, and how to set up and run your
   application.

2. The git history for your work. Please include the .git/ directory since that
   is what holds the git history.

3. Can your thought process be understood from the git history and README? Will
   this be easy for the reviewer(s) to set up?

What we’re looking for:

● Clean, easy-to-read, and easy-to-understand code and README

● Efficient, thoughtful implementations. If anything is not production-worthy
  (or otherwise less than ideal) please call it out in the README.

**IMPORTANT**: The amount of effort expected to complete this task can range
anywhere from 2 hours (**extremely** familiar with all the technologies
involved) to 5 hours (completely unfamiliar with any of the technologies
involved), maybe even a little more if you are taking it easy.

If you are going above and beyond for the sake of learning, that’s great, but
is definitely not expected nor required. We want to be respectful of your time,
and we also want to treat all candidate submissions equally. Therefore we
strongly encourage you to timebox working on this project to 3-5 hours,
treating it as a mini "hackathon" session (please do not spend more than a full
weekend day on this!). If you work considerably more time than expected, call
it out in the README.

Also keep in mind this is for showcasing your strengths. Do what you think
makes sense to you, and talk about it in the README. There isn't a specific
solution in mind, this is just an open ended problem that has quite a few
approaches. Feel free to reach out for clarifications.

Lastly...

**Have fun!!**

