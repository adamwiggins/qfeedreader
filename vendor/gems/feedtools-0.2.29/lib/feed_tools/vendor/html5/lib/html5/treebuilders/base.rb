require 'html5/constants'

#XXX - TODO; make the default interface more ElementTree-like rather than DOM-like

module HTML5

  # The scope markers are inserted when entering buttons, object elements,
  # marquees, table cells, and table captions, and are used to prevent formatting
  # from "leaking" into tables, buttons, object elements, and marquees.
  Marker = nil

  module TreeBuilders
    module Base

      class Node
        # The parent of the current node (or nil for the document node)
        attr_accessor :parent

        # a list of child nodes of the current node. This must 
        # include all elements but not necessarily other node types
        attr_accessor :childNodes

        # A list of miscellaneous flags that can be set on the node
        attr_accessor :_flags

        def initialize(name)
          @parent     = nil
          @childNodes = []
          @_flags     = []
        end

        # Insert node as a child of the current node
        def appendChild(node)
          raise NotImplementedError
        end

        # Insert data as text in the current node, positioned before the 
        # start of node insertBefore or to the end of the node's text.
        def insertText(data, insertBefore=nil)
          raise NotImplementedError
        end

        # Insert node as a child of the current node, before refNode in the 
        # list of child nodes. Raises ValueError if refNode is not a child of 
        # the current node
        def insertBefore(node, refNode)
          raise NotImplementedError
        end

        # Remove node from the children of the current node
        def removeChild(node)
          raise NotImplementedError
        end

        # Move all the children of the current node to newParent. 
        # This is needed so that trees that don't store text as nodes move the 
        # text in the correct way
        def reparentChildren(newParent)
          #XXX - should this method be made more general?
          @childNodes.each { |child| newParent.appendChild(child) }
          @childNodes = []
        end

        # Return a shallow copy of the current node i.e. a node with the same
        # name and attributes but with no parent or child nodes
        def cloneNode
          raise NotImplementedError
        end

        # Return true if the node has children or text, false otherwise
        def hasContent
          raise NotImplementedError
        end
      end

      # Base treebuilder implementation
      class TreeBuilder

        attr_accessor :open_elements

        attr_accessor :activeFormattingElements

        attr_accessor :document

        attr_accessor :head_pointer

        attr_accessor :formPointer

        # Class to use for document root
        documentClass = nil

        # Class to use for HTML elements
        elementClass = nil

        # Class to use for comments
        commentClass = nil

        # Class to use for doctypes
        doctypeClass = nil

        # Fragment class
        fragmentClass = nil

        def initialize
          reset
        end

        def reset
          @open_elements = []
          @activeFormattingElements = []

          #XXX - rename these to headElement, formElement
          @head_pointer = nil
          @formPointer = nil

          self.insert_from_table = false

          @document = @documentClass.new
        end

        def elementInScope(target, tableVariant=false)
          # Exit early when possible.
          return true if @open_elements[-1].name == target

          # AT How about while true and simply set node to [-1] and set it to
          # [-2] at the end...
          @open_elements.reverse.each do |element|
            if element.name == target
              return true
            elsif element.name == 'table'
              return false
            elsif not tableVariant and SCOPING_ELEMENTS.include?(element.name)
              return false
            elsif element.name == 'html'
              return false
            end
          end
          assert false # We should never reach this point
        end

        def reconstructActiveFormattingElements
          # Within this algorithm the order of steps described in the
          # specification is not quite the same as the order of steps in the
          # code. It should still do the same though.

          # Step 1: stop the algorithm when there's nothing to do.
          return if @activeFormattingElements.empty?

          # Step 2 and step 3: we start with the last element. So i is -1.
          i = -1
          entry = @activeFormattingElements[i]
          return if entry == Marker or @open_elements.include?(entry)

          # Step 6
          until entry == Marker or @open_elements.include?(entry)
            # Step 5: let entry be one earlier in the list.
            i -= 1
            begin
              entry = @activeFormattingElements[i]
            rescue
              # Step 4: at this point we need to jump to step 8. By not doing
              # i += 1 which is also done in step 7 we achieve that.
              break
            end
          end
          while true
            # Step 7
            i += 1

            # Step 8
            clone = @activeFormattingElements[i].cloneNode

            # Step 9
            element = insert_element(clone.name, clone.attributes)

            # Step 10
            @activeFormattingElements[i] = element

            # Step 11
            break if element == @activeFormattingElements[-1]
          end
        end

        def clearActiveFormattingElements
          {} until @activeFormattingElements.empty? || @activeFormattingElements.pop == Marker
        end

        # Check if an element exists between the end of the active
        # formatting elements and the last marker. If it does, return it, else
        # return false
        def elementInActiveFormattingElements(name)
          @activeFormattingElements.reverse.each do |element|
            # Check for Marker first because if it's a Marker it doesn't have a
            # name attribute.
            break if element == Marker
            return element if element.name == name
          end
          return false
        end

        def insertDoctype(name, public_id, system_id)
          doctype = @doctypeClass.new(name)
          doctype.public_id = public_id
          doctype.system_id = system_id
          @document.appendChild(doctype)
        end

        def insert_comment(data, parent=nil)
          parent = @open_elements[-1] if parent.nil?
          parent.appendChild(@commentClass.new(data))
        end
               
        # Create an element but don't insert it anywhere
        def createElement(name, attributes)
          element = @elementClass.new(name)
          element.attributes = attributes
          return element
        end

        # Switch the function used to insert an element from the
        # normal one to the misnested table one and back again
        def insert_from_table=(value)
          @insert_from_table = value
          @insert_element = value ? :insert_elementTable : :insert_elementNormal
        end

        def insert_element(name, attributes)
          send(@insert_element, name, attributes)
        end

        def insert_elementNormal(name, attributes)
          element = @elementClass.new(name)
          element.attributes = attributes
          @open_elements.last.appendChild(element)
          @open_elements.push(element)
          return element
        end

        # Create an element and insert it into the tree
        def insert_elementTable(name, attributes)
          element = @elementClass.new(name)
          element.attributes = attributes
          if TABLE_INSERT_MODE_ELEMENTS.include?(@open_elements.last.name)
            #We should be in the InTable mode. This means we want to do
            #special magic element rearranging
            parent, insertBefore = getTableMisnestedNodePosition
            if insertBefore.nil?
              parent.appendChild(element)
            else
              parent.insertBefore(element, insertBefore)
            end
            @open_elements.push(element)
          else
            return insert_elementNormal(name, attributes)
          end
          return element
        end

        def insertText(data, parent=nil)
          parent = @open_elements[-1] if parent.nil?

          if (not(@insert_from_table) or (@insert_from_table and not TABLE_INSERT_MODE_ELEMENTS.include?(@open_elements[-1].name)))
            parent.insertText(data)
          else
            #We should be in the InTable mode. This means we want to do
            #special magic element rearranging
            parent, insertBefore = getTableMisnestedNodePosition
            parent.insertText(data, insertBefore)
          end
        end

        # Get the foster parent element, and sibling to insert before
        # (or nil) when inserting a misnested table node
        def getTableMisnestedNodePosition
          #The foster parent element is the one which comes before the most
          #recently opened table element
          #XXX - this is really inelegant
          lastTable = nil
          fosterParent = nil
          insertBefore = nil
          @open_elements.reverse.each do |element|
            if element.name == "table"
              lastTable = element
              break
            end
          end
          if lastTable
            #XXX - we should really check that this parent is actually a
            #node here
            if lastTable.parent
              fosterParent = lastTable.parent
              insertBefore = lastTable
            else
              fosterParent = @open_elements[@open_elements.index(lastTable) - 1]
            end
          else
            fosterParent = @open_elements[0]
          end
          return fosterParent, insertBefore
        end

        def generateImpliedEndTags(exclude=nil)
          name = @open_elements[-1].name

          # XXX td, th and tr are not actually needed
          if (%w[dd dt li p td th tr].include?(name) and name != exclude)
            @open_elements.pop
            # XXX This is not entirely what the specification says. We should
            # investigate it more closely.
            generateImpliedEndTags(exclude)
          end
        end

        def get_document
          @document
        end
  
        def get_fragment
          #assert @inner_html
          fragment = @fragmentClass.new
          @open_elements[0].reparentChildren(fragment)
          return fragment
        end

        # Serialize the subtree of node in the format required by unit tests
        # node - the node from which to start serializing
        def testSerializer(node)
          raise NotImplementedError
        end

      end
    end
  end
end
