#

## Rationale on Full Gem

Due to the simple nature of the challenge, I decided that simply providing "a solution" wouldn't properly showcase what
my ability to produce polished, maintainable, and secure code.  I therfore decided to be overly
heavy-handed on showing what all proper aspects of SDLC / maintable code would look like.  This also
is something outside the pervue of current AI tools (they can toss a bunch of process at a project, but fail
in the correct usage of such tools).

This means that the only directory that is of interest for the solution is `lib/dbotquery`, and the remaininng
files can be considered engineering execlence / best practice.

Similarly, due to the fact the example code was based on `argparse`, I decided to use the alternative of `thor` as to
demonstrate a clean implmentation.  In reality, this adds a dependency and would not have been chosen had there not be
value in displaying that the solution is free from the example code.

## Extensive Comments

Due to the fact Ruby is my prefered language, but not as common as say python, I've been overly verbose in the
comments, particularly where there are "rubyisms"

## YARD Documentation

The solution shows proper code documenation inline, with the YARD (Yet another ruby documentation) documentation generated.

## RSpec Testing

The solution is asserted through proper testing.

## RBS, Steep, Rubocop

The solution includes Rubocop for proper code linting, Steep for static analysis.  These are quality tools for the
purpose of showing a fully clean / production ready style of coding.

## AI Attestation

The solution was created with only typical IDE code completion, no agentic tools.