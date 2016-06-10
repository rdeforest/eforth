
# Introducing Lookout 2.0!

## 

#### _DATELINE: Seattle, WA, July 2020_

Amazon's Lookout team launched a web UI and equivalent AWS API which current
and future customers may use to obtain and manage Lookout services.

For "several years"<sup>_[clarify]_</sup> Lookout has offered a metric
summarization service to a select few internal teams. Through this service,
teams could expose multi-dimensional data to Lookout and later query Lookout to
determine what the most common patterns in that data were. Customers generally
used the service to identify malicious or dramatically inefficient activities
which should either be stopped or optimized.

In this way, the service has been of great value in identifying the "low
hanging fruit" of resource consumption, but the system also had many
unfortunate constraints which limited its utility.

Today's launch of Lookout's new external API and UI are merely the customer-visible
tip of the iceberg that is the re-tooling of the entire Lookout Suite.
This re-tooling will delight customers and the Lookout team alike by

- removing humans as a gating factor in most customer-driven changes
  - _which changes?_
- reducing or eliminating system limitations
  - _which limitations?_
- reducing the operating costs of Lookout for customers and Lookout alike
  - _which costs? how much?_

## Full Control Of Everything, Now

Beta customers have repeatedly identified the interactivity of the new
interfaces as the most dramatic and useful change offered by the new
interfaces.

Where previously customers' control of how Lookout processed their data was
largely through working with the Lookout team offline, the new interfaces give
customers a single pair of interfaces with which to interact with their data
and its processing. While some customer requests are still realized through
intervention by Lookout team members, customers no longer need to make such a
distinction. This consolidation of the interface between Lookout and its
customers gives Lookout a way to quickly adapt to customer needs by applying
the same kind of analysis to their customer interfaces that they have
previously applied to their customers' data.

Furthermore, since one of these interfaces is a RESTful API following the same
standards and best practices as most of the rest of AWS, customers can apply
to Lookut the lessons learned automating their interaction with other services.

## FAQ

### This sounds amazing, how do I exploit this right away?

If you are already a customer, you only need to know two things:

- Instead of interacting with Lookout through Remedy and social tools, head to
  https://my.lookout.amazon.com

- When you're ready to automate changes to your data flows, metrics and
  alarms, take a look at https://lookout.amazon.com/apiDocs. If for some
  reason that page is unsatisfactory, submit feedback directly through the
  interface, or consider submitting a support request through your dashboard
  as exposed by my.lookout.amazon.com

### Sure, that's nice and all, but how do I get a Better Lookout?

You already have it! Existing customers already benefit from the improvements
we've made. You're not limited to 200 metrics any more, though you're still
subject to the limitations described by Gödel's incompleteness theorems, the
Shannon Limit and the laws of thermo-dynamics.

### I don't have Lookout yet; how do I get it?

Head on over to my.lookout.amazon.com. The site will lead you through the
process of establishing a new customer relationship with the Lookout team and
setting up the data flows and analyses you need.
