

## FileQueue [![Build Status](https://travis-ci.org/pezra/filequeue.svg)](https://travis-ci.org/pezra/filequeue)
A simple file based queue written in Ruby that uses the battle-tested [`Filelock`](https://github.com/sheerun/filelock) gem to push and pop items into a queue. It's not web scale but is nice for lightweight async queuing apps.

## Install

```ruby
gem install filequeue
```

## Usage

```ruby
queue = FileQueue.new 'queue_party.txt'

queue.push "an item"
#  => true
      
queue.pop
#  => "an item"
```

See `spec/filequeue_spec.rb` for more usage details

## Docs

`FileQueue` has the following class methods:

* `push` (alias `<<`)
* `pop`
* `length`
* `empty?`
* `clear`

## Authorship

* Origially written by [daddz](http://www.github.com/daddz) and found in [this gist](https://gist.github.com/352509).
* Ported to a Rubygem by [@pezra](https://github.com/pezra).