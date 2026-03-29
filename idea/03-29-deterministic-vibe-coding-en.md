# Deterministic Vibe Coding

## Production Integration of an AI Agent Through Oracle APEX: A Deterministic Layer for a Safe Product Module with Amazon

What technology can be much more powerful than vibe coding?

Much more powerful than vibe coding can be a technology that combines low-code platforms with vibe coding platforms. Why does this produce results? Imagine you're doing vibe coding in a system that's used in production. You can't immediately build — it's impossible to immediately build — a system that can be used right after vibe coding.

Because the LLM, or more precisely the AI agent, has access to the code. It has a great deal of freedom in that access, and the agent can generate code that doesn't fit the organization for reasons that the agent simply doesn't understand the business requirements. For example, it can change the authorization scheme, the authentication scheme, change some security policies, because at the moment the AI agent generated this, it understood it within the context that was provided to it.

Another issue with vibe coding is teamwork, because if you have a large team of developers, the style and implementation of code by different parts of the team, by different developers, will differ dramatically. This code won't be uniform — it will be written differently, and typically one part of this code can conflict with another part of other code. And such a solution is extremely hard to immediately deploy into a large existing project.

So vibe coding has these downsides, which I'd probably describe as extremely vast freedom for both agents and code access.

What is a low-code platform? A low-code platform is a platform that has been created over many, many years so that people could more easily, at a different level, build applications. And so all low-code platforms, to varying degrees, have some API — a programmatic API in the middle. And this API works with the user, with the user interface, or with some data that the user provides through a web interface, through an application.

And this API is an intermediary for building the application, because the user doesn't write code directly. And all the pieces of code are covered by this intermediary layer that the low-code platform provides, and this intermediary layer very strictly controls the rules. Because if we take, for example, Oracle APEX, to draw a table you need to specify the template name and provide a query. And perhaps configure column display parameters at a very high level, but you cannot affect the design of this table, you cannot change some global security settings for this table, and therefore, no matter which developer does this, no matter what context they have, they will never go beyond the boundaries of this application.

Because this is called a deterministic application, which doesn't allow the developer to deviate. In the case of Oracle APEX, this is an extremely deterministic system where practically every action is described by thousands of APIs for various use cases with different parameters, covering a very large number of business requirements, because Oracle has been developing this platform for 20 years and it has a very large number of components.

And right now there is value in combining vibe coding with low-coding, because if the AI agent has access not directly to the code but to the API that the low-code platform provides, this allows development to fit into existing complex projects. And this allows — regardless of the style, the agent's settings, the type of agent, or what context it has — to perform targeted tasks that will fully integrate into the system immediately and be production-ready right away.

So now I'll do a demo where I'll show APEX capabilities from a new perspective, where APEX is controlled by an AI agent. In my demo we already have an existing system with its own design, its own security rules, user authorization settings. This system tracks customer data but has no module for tracking products.

And we have, for example, a new requirement: we want to add a module to this system — without breaking the overall standards — that will download top-selling products from Amazon, search the internet for their descriptions and images, store these products in a local products table, allow the user to list these products, and add the ability to track these products. Meaning we can create a document for receiving these products, write-off or sell these products from the warehouse, have some statement of remaining inventory, and conduct inventory checks. We also need to develop a report showing the balance of these products and the price set by the user.

This module has never existed in this system, and the agent's task is to integrate this module — develop database tables, develop PL/SQL procedures for daily information updates. When the user presses a button, information should be pulled from the website or from Amazon and updated in the system. And we need to show how well this application integration immediately adds to the system as a production solution. It essentially requires no review or verification, because the Oracle APEX platform is a knowledge base — deterministic — that very strongly limits all steps in any other direction.

So the task is to develop such a demo. We need to use APEX and the SQLcl Skill to develop a plan for how we'll implement this. With the help of NotebookLM we'll create a presentation, with NotebookLM we'll make a video clip for this, and we'll also record a live video of how it works. We'll speed up this video to make it clearer. But the result of this video we'll integrate with the clip that Google's NotebookLM created. So the video starts with NotebookLM telling us the general concept. Then at very high speed we show how the generation of this module works. And at the end we show the result on video.

So we'll record these several videos, edit everything together in DaVinci Resolve, and I'll also probably need to generate some description — an audio description in English — for this video. So I need to look for a system that can do this, for example Eleven Labs or something like that, where we'll prepare the text and the system will simply create the narration for this video.

So that's our plan for today. That's it for now.
