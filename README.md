<div style="text-align: center; display: flex; flex-direction: column; justify-items: center; align-items: center">

![promptspot-logo.png](app%2Fassets%2Fimages%2Fpromptspot-logo.svg)

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)</div>
Say goodbye to the chore of copying and pasting prompts between apps, building your own internal tools, or relying on
limited
playgrounds. With ✨Promptspot, you have the power to:

- Test prompts against numerous inputs (your application data) in a single test suite
- Collaborate on prompts with your team (e.g. version control, drafts)
- View outputs side-by-side
- Download CSVs for offline analysis
- Clone tests quickly for quick iteration

[![Video walkthrough](app%2Fassets%2Fimages%2Fscreenshot.png)](https://youtu.be/1lGHRb9hryg)
*Click the image above for a quick 4m video walkthrough*

## Stack

- Rails 7
- Stimulus
- TailwindCSS
- Postgres
- Goodjob
- Minitest

## Getting Started

### Pre-requisites

Ensure you have Docker and Docker Compose installed on your machine.
Visit [the official Docker site](https://docs.docker.com/get-docker/)
and [the official Docker Compose site](https://docs.docker.com/compose/install/) for download and installation
instructions if you haven't done so already.

### Steps

1. Clone the [repo]([url](https://github.com/jordanful/promptspot)).
2. Navigate into the project directory:
    ```
    cd Promptspot
    ```
3. Copy `.env.example` to `.env` and fill in the necessary environment variables:
    ```
    cp .env.example .env
    ```
4. Build and start the Docker services:
    ```
    docker compose up --build
    ```
5. Visit `http://localhost:3000`
6. Create a new account and sign in
7. Visit `http://localhost:3000/users/edit` and add your OpenAI API key

## Concepts

### Prompts

Sometimes called "system prompt" or "hidden prompt", in Promptspot a `prompt` is the initial text you send to a model to
generate a completion. They can be as simple as a single sentence, or as complex as a multi-paragraph description of a
user's state.

Example:

```
You are a hotel concierge. You are an expert. Your IQ is 132. 
Every hotel recommendation you make is personalized to the individual asking. 
Based on the user profile below, delimited by three equals signs (===), offer 5 hotel recommendations. 
Respond only in JSON with the following fields: 
- Hotel name 
- Hotel address 
- Description (1 or 2 sentences at most, and try to make it relevant to the user profile below). 
Remember: ONLY RESPOND IN JSON. 

===
```

Promptspot offers some neat features specific to prompts, including drafts, versioning, and diffs.

### Inputs

Sometimes referred to as "user prompts" or "hidden context", an `input` is the relevant data you need in order to
generate a completion. You may have heard of this referred to as "give a bot a fish 🐟", which just means you include the
relevant context in the prompt itself, so the model is simply aware of it.

Inputs are often user-specific and dynamic data, like a name, age, and location — or application state, like a team's
current balance or recent activity, or even just today's date and time.
**Inputs are combined with prompts to generate a completion.**

Example:

```
 User profile:
     
   Name: Alice Lee  
   Age: 29
   Favorite hotels: 
        1) Ace Hotel, New Orleans
        2) Hotel San Fernando, Mexico City
        3) Blackberry Farms, TN
   Traveling for: business
   Hobbies and interests: fitness, art museums, music festivals
```

### Tests

Tests (or `TestSuite`s in the code) are Promptspot's atomic object. A test is a collection of `n` prompts and `n`
inputs, tested against one another and a LLM model.

There are two main use cases for tests:

1) Testing a single prompt against multiple inputs
2) Testing multiple prompts against a single input

## Roadmap

We're just getting started! Here's what we're planning to build next:

- [ ] Wider test coverage
- [ ] "Input collections" (a collection of inputs that can be used, many-to-many, across multiple tests)
- [ ] Support for chat-based models
- [ ] Support for other completion APIs (e.g. outside of OpenAI)
- [ ] Better team + collaboration support
- [ ] Use LLMs to help improve prompts themselves
- [ ] Full API support (e.g. for CI/CD)
- [ ] Prompt hosting (i.e. serve prompts to your app from Promptspot)
- [ ] Support for multiple users and accounts
- [ ] Shareable outputs (semi-private links to test results)
- [ ] Support for diffusion / image-based models

## Contributing

We need your help! Promptspot is an open-source project, and we welcome contributions of all kinds.

## License

Promptspot is licensed under the Apache License v2.0. See [LICENSE](LICENSE.md) for more information.
