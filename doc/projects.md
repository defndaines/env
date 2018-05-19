# Projects

This is a page of project idea and TODOs. It isn't necessarily ordered, just
a place for me to consolidate several different notes I have.


## Technology

This section lists some general technology I'd like to explore.

### Naga

[Naga](https://github.com/threatgrid/naga) is a Datalog-based rules engine.
That just sounds really fun to play with.

### Onyx

[Onyx](https://github.com/onyx-platform/onyx) Distributed, masterless, high
performance, fault tolerant data processing.

### Aeron

[Aeron](https://github.com/real-logic/aeron) Efficient messaging.


## Affinity Reviews

Honestly, I don't have much faith in the reviews and recommendations provided
by different sites, but lets start with [Goodreads](https://www.goodreads.com/).

Use the Goodreads API to find reviewers with similar tastes to mine.
Analyze people with similar tastes based on 4-star review
threshold. Maybe see if there's a way to filter out reviews and create a new
score more likely to be in-line with what I'd think. In particular, it is easy
to see (but hard to programmatically analyze?) that racists and misogynists
down-rate some good books, so completely
disregard their ratings when doing the calculation.


## Consistent Hashing

Just an interesting algorithm to explore as a kata.
[Consistent hashing and random trees: distributed caching protocols for
relieving hot spots on the World Wide Web](http://dl.acm.org/citation.cfm?id=258660)


## Amazon Wish List

Figure out Amazon API (or create authenticated web scraper) to monitor wish
list and notify if an item is about to go out of stock or the price had
dropped dramatically.

I started playing with this a couple years
ago—[az-wish](https://github.com/defndaines/az-wish)—but it has languished
for a while.

I also threw together a [gist on using
Jsoup](https://gist.github.com/defndaines/8e4124fa2d6c530d477e06f91223188d)
from Clojure. It is probably a simpler scraper compared to the library I was
using before (which caused problems in the REPL).


## Graph Problems

My graph algorithm skills are weak. I could spend some time beefing them up.

Resources:
* [Loom](https://github.com/aysylu/loom) Graph library for Clojure
* [Top Coder Problems](https://www.topcoder.com/community/data-science/data-science-tutorials/introduction-to-graphs-and-their-data-structures-section-1/)
* [Techie Delight Graphs Interview Questions](http://www.techiedelight.com/graphs-interview-questions/)

Simple problems to use it against:
* Implement a Hangman solver.
* Implement a word ladder solver.


## OCR Photos

Use OCR to automatically scan a photo on
[flickr](https://www.flickr.com/photos/ax2groin) and then add the text to the
description. I have played with using
[tesseract](https://github.com/tesseract-ocr/tesseract), but still need to
capture that learning in a repository.


## Twitter Bot

Monitor changes to a website and automatically tweet links to new articles.


## Look into in-Browser Editing

Use [Quill](http://quilljs.com/) to handle article editing.


## Civic Analysis

Analyze data from government sources. Perhaps scrape out information of interest
that isn't formatted for easy use. Maybe something local like Culver City.


## Census

Spider and grab all the [census data from 1940](http://1940census.archives.gov/search/?search.result_type=image&search.state=OH&search.county=Athens+County&search.city=&search.street=#)
 ... then see if I can OCR it and locate the information under Daines.


## Games

### Using D&D Rules

Rogue-like using D&D rules. Start with one class, like Warlock.

### Pac-Man

For modifying Pac-Man
* Allow a ghost to go through walls (it's a ghost, after all). Moves slower, though.
* Implement the scent AI
 * Maybe Pac-Man exhales every other step?
 * Fruit have smells? Ghost might follow them.

Ghost AIs
 * Knows where other ghosts are and avoids them, unless tracking Pac-Man
 * Hive-mind ... able to cooperate and work together with information that each has about Pac-Man's location.
 * Developmental AI ... playful learning.

Maze generation
 * Original vertical 
 * Dead ends? Limited by length and number, based upon level
 * Transportation walls / warp tunnels
 * Home base for ghosts
 * Non-rectangular

Pac-Man is limited by energy. For example, starts with 1, each dot gives 3, each move costs one
 * exhaustion slows you down
 * moving faster when not stopping to "eat"
 * power pills vs. fruit? fruit is just more energy, where power pills give a skill, like killing ghosts.

Movement
 * Allow Pac-Man to stop and wait.
 * Allow ghosts to make decisions outside of junctions.

Visibility
 * What if Pac-Man couldn't see the whole maze?

Pac-Man mazes and AIs. AIs: use A* to always close the gap; use A*, but diminish cost of walls so that the ghost will pass through them; loner ghost that doesn't like other ghosts it can see. Not ghosts, but different monsters.
