eMonies
=======

**Your Money.** *Managed.*

eMonies is a Ruby on Rails application for managing the shared finances of a group of people living together.
It was developed with the aim of being used for a house of around four students, living in the United Kingdom,
who frequently make purchases for the common good of the house.

Example use cases include:

* Buying house furniture and working out who owes what
* Jointly purchasing food
* Providing a target for bug reports

eMonies has been designed with the goal of being usable even in the instance that not everyone in the house
will necessarily need to be a part of every purchase. Participants in the eMonies system are free to decline
to accept purchases at will, or to accept a less-than-equal share of any given purchase. It is entirely up
to them.

Glowing Praise for this Readme
------------------------------

> If you do, I will refuse to eMonies any more.

~ Kieran

> I will hit you.

~ Peter

Getting Started
---------------

1. Clone this repository to a suitable location.
2. Make sure Ruby is installed.
3. Execute `bundle install` from inside the repository root.
4. Wait.
5. Execute `bundle exec rake db:migrate` from inside the repository root.
6. Wait some more.
7. Execute `bundle exec rails server` from inside the repository root.
8. Wait even longer.
9. Hooray! You now have a development eMonies instance on http://localhost:3000. Aren't you proud?

Updating eMonies
----------------

If you cloned eMonies directly from an upstream repository, updating eMonies is easy, simple and fast!

1. Execute `git pull` from inside the repository root.
2. Wait for git to do its magic.
3. Execute `bundle install` from inside the repository root.
4. Wait for bundler to bundle some things.
5. Execute `bundle exec rake db:migrate` from inside the repository root.
6. Wait for rake to migrate some database.
7. Hooray! You have now updated your instance of eMonies to a more sensible version.
