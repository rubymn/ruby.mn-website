#!/usr/local/bin/ruby
#
# (c) 2004 Chris Riddoch

require 'tmail'
require 'parsedate'
include ParseDate

$sessinc = 1  # This is used for generating new threads.
$randseq = rand(10**20).to_s

class MailThread
  attr_writer :messages, :id_table, :rootset
  attr_reader :messages, :id_table, :rootset
  
  def initialize(messages)
    @messages = messages
    @id_table = {} # id_table is a hash table. 
    @root = [] # An empty list, at first.
  end

  # get the existing, or make a new container for this id
  def get_cont_for_id(id)
    if @id_table.has_key?(id)
      cont = @id_table[id]
    else
      cont = ThreadContainer.new(id)
      @id_table[id] = cont
    end
    return cont
  end

  def make_fakeroot
    fakeroot = ThreadContainer.new("fakeroot")
    fakeroot.set_children(@rootset)
    return fakeroot
  end

  def repopulate_rootset(fakeroot)
    @rootset = fakeroot.children
    #@rootset.each { |n| fakeroot.remove_child(n) }
  end

  def group_set_bysubject()
    subjectset = {}
    newrootset = []

    @rootset.each { |msg|
      subject = msg.simple_subject
      if subjectset.has_key?(subject)
        # Add the message to the current set of
        # messages with the same subject
        subjectset[subject].push(msg)
      else
        # Or, we haven't seen this subject before.
        # In that case, make a list and put this message in it.
        subjectset[subject] = [msg]
      end
    }

    subjectset.each_pair { |subject, messageset|
      if messageset.length == 1
        newrootset.push(messageset[0])
      else
        # Is one of them a parent message?
        p = messageset.find { |i| !i.parented }
        if !p.nil?
          newparent = p
          messageset.delete(newparent)
        else
          newparent = ThreadContainer.new("empty_container_" + $randseq.to_s + "_" + $sessinc.to_s)
          $sessinc = $sessinc + 1
          newparent.subject = subject # Use the existing simple subject.
        end
        # What's left of the messageset should now be assigned as the children.
        newparent.children.concat(messageset)
        newrootset.push(newparent)
      end
    }

    @rootset = newrootset
  end

  def thread()
    setup()

    #@id_table.values.each { |v|
    #  v.debug_self
    #}

    #puts "=========================="
    # Find the set of ThreadContainers that haven't been
    # marked as having a parent: these are the rootset.
    @rootset = @id_table.values.find_all { |i| !i.parented }

    fakeroot = make_fakeroot()
    fakeroot.prune_empties()
    repopulate_rootset(fakeroot)

    #@rootset = fakeroot.children # The rootset has changed!
    @rootset = @rootset.uniq

    group_set_bysubject()

    fakeroot = make_fakeroot()
    fakeroot.order_by_date()
    repopulate_rootset(fakeroot)

    #@rootset.each { |r| r.debug_tree(0)}
  end

  def setup()
    # 1.  For each message
    @messages.each { |mesg|
      # A. if id_table...
      thiscontainer = get_cont_for_id(mesg.message_id)
      thiscontainer.assign_message(mesg)

      #puts "Setting up message: #{mesg.message_id}"
      # B. For each element in the message's References field:
      refs = thiscontainer.references()
      prev = nil
      unless refs.nil? 
        refs.each { |ref|
          #puts "Current reference: #{ref}"
          # Find a Container object for the given Message-ID
          container = get_cont_for_id(ref)
          
          # Link the References field's Containers together in the
          # order implied by the References header
          # * If they are already linked don't change the existing links
          # * Do not add a link if adding that link would introduce
          #   a loop...
          if (prev &&
                container.parented != true && # this container hasn't been assigned to a parent
                (!container.has_descendant(prev))) # would loop if we made it a child here.
            #puts "Adding #{container.messageid} as a child to #{prev.messageid} - #{container.parented}"
            prev.add_child(container)
          end
          prev = container
        }
      end

      # C. Set the parent of this message to be the last element in References
      if (prev and (!thiscontainer.has_descendant(prev)))
        # Make sure thiscontainer isn't already a child of *anything*.
        @id_table.each { |id,mesg|
          mesg.children.delete_if { |c|
            c.messageid == thiscontainer.messageid
          }
        }
        prev.add_child(thiscontainer)
      end

    } # messages.each

  end
  
end

class ThreadContainer
  attr_writer :children, :messageid, :message, :parented, :subject, :refs, :irt
  attr_reader :children, :messageid, :message, :parented, :subject, :refs, :irt

  def initialize(id)
    @messageid = id
    @children = []
    @parented = false
    @subject = "no subject"
    @refs = []
    @irt = []
  end

  def placeholder?
    @message.nil?
  end

  def assign_message(mesg)
    @message = mesg
    if mesg.subject.nil?
       @subject = "no subject"
    else
      @subject = mesg.subject
    end
    if mesg.references.nil?
      @refs = []
    else
      @refs = mesg.references
    end
    if mesg.in_reply_to.nil?
      @irt = []
    else
      @irt = mesg.in_reply_to
    end
  end

  def debug_self()
    if self.message.nil?
      print "ID: #{messageid} (not real!)"
    else
      print "ID: #{messageid}"
    end
    if (@parented)
      print "- is parented"
    end
    print "\n"
    unless @children.empty?
      puts "Children:"
      @children.each {|c| puts "  #{c.messageid}"}
    end
  end

  def debug_tree(level)
    if self.message.nil?
      puts "  " * level + "Not a real message"
    else
      puts "  " * level + "#{@subject} - #{self.messageid}"
    end
    @children.each {|c| c.debug_tree(level + 1)}
  end

  def references()
    return Array.new().concat(@refs).concat(@irt).uniq
  end

  # Depth-first traversal
  # Looking for the first container with a valid message
  def topmost
    return self if self.message
    unless @children.empty?
      @children.each {|c|
        unless c.topmost.nil?
          return c
        end
      }
    end
    return nil
  end

  def isreply
    replregex = /^re:\s?/i
    matches = replregex.match(@subject)
    if ((references.length > 0) && matches)
      return true
    end
  end

  def simple_subject
    subjregex = /re?([\d+])?:\s?/i
    i = @subject.gsub(subjregex, '')
    return i.strip # Ignore spacing differences
  end

  def has_descendant(child)
    if @children.empty?
      return false
    else
      if @children.include?(child)  # Is it an immediate child?
        return true
      else
        # Recursive step: call has_descendant on each child, and see if any return true. 
        return @children.collect { |c| c.has_descendant(child) }.include?(true)
      end
    end
  end

  def add_child(child)
    if self == child
      raise "I refuse to be my own parent: #{@messageid}"
    end

    unless @children.include?(child)
      @children.push(child)
    end
    child.parented = true # It's now been assigned to a parent.
  end

  def remove_child(child)
    @children.delete(child) { puts "Couldn't find the child to delete!" }
  end

  def set_children(children)
    @children = children
  end

  def parent()
    # We compute this a little painfully. Avoid using this, when possible.
    # It saves us quite a lot of trouble: no pointer chasing!
    # id_table is a hash table of everything we know about.
    # Go through the set of all ThreadContainers, and ask them
    # if it contains *this* message. 
    #@thread.id_table.values.detect {|n| n.children.include?(self)}
    # But you see, that's really not necessary when it's easy enough to keep
    # a little variable that tracks whether this message has been assigned
    # to a parent: it turns out, we never care *which* parent.
    @parented
  end

  def prune_empties()
    return if @children.empty?

    marked_for_deletion = []
    recurse_on = []

    @children.each { |curr|
      if (curr.message.nil?)
        if (curr.children.empty?) # An empty node with no message 
          marked_for_deletion.push(curr)
        else
          @children.concat(curr.children) # Add empty message's children to this node's.
          marked_for_deletion.push(curr)
        end
        unless (curr.children.empty?)
          recurse_on.push(curr)
        end
      end
    }

    @children = @children - marked_for_deletion

    # Recursive steps...
    recurse_on.each {|c| c.prune_empties}
    return
  end

  # This sorts the tree by date(). 
  def order_by_date()
    @children.each {|c| c.order_by_date} # Recursive
    @children.sort! {|x,y| x.date <=> y.date }
  end

  # When was a message created?  This seems simple, but...
  # 1) Don't ever trust the 'Date:' header. Nothing's less reliable.
  #    Instead, trust your own 'received' headers - the first one should
  #    always be the most recent.
  # 2) If the message is a placeholder, we have no idea what date to give it.
  #    A best guess is to give the earliest of it's children's dates.
  #    This is still not quite right, but it's likely to be a decent ballpark.
  #
  def date()
    if !placeholder?
      return @message['Received'].first.date
    else
      sorted = @children.sort {|x,y| x.date <=> y.date }
      return sorted.first.date()
    end
  end

end

