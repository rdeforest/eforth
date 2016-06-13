# End result

## Simplified interfaces

### User interface

Friendly vaneer over API, as is the modern way.

### Application Interface

See models.litcoffee

## Simplified management

### Conslidated customer relations

### Myriad configuration and policy interfaces conslidated

Most if not all of the models we interact with exist in multiple domains and
have configuration, history, issues and other items which also crosses
multiple domains. This proposal abstracts that out so that, for example,
everything we know or have to say about a region is managed by a model which
wraps DNS, Brazil Config, code, Odin, AWS accounts, AWS services, IAM, etc.

When we call

    {Region, Domain} = world.models
    domains = Domain.registry

    exa = Region.create
      realmName: 'xx-example-1'
      airportCode: 'EXA'
      state: Region.states.proposed

    exa.addDomain domains.prod

This informs the system that there could end up being such a region and that
it should prepare itself to have conversations about that region.

Having done so, we could then call

    world
      .inventory
      .regions 'exa'
      .promote state: Region.states.approved

Which will cause the system to generate and deploy monitoring appropriate for
a region which we intend to deploy to when all our requirements are met.

Via the principle of Sane Defaults (tm), a Region will also have an assumed
.buildPageURL which might be implemented on the parent something like

    buildPageURL: -> @standards 'url/doc/collab/build/region', this

# Changes

# Stages

