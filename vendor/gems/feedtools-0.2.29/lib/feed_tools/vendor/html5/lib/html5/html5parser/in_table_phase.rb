require 'html5/html5parser/phase'

module HTML5
  class InTablePhase < Phase

    # http://www.whatwg.org/specs/web-apps/current-work/#in-table

    handle_start 'html', 'caption', 'colgroup', 'col', 'table'

    handle_start %w( tbody tfoot thead ) => 'RowGroup', %w( td th tr ) => 'ImplyTbody'

    handle_end 'table', %w( body caption col colgroup html tbody td tfoot th thead tr ) => 'Ignore'

    def processCharacters(data)
      parse_error("unexpected-char-implies-table-voodoo")
      # Make all the special element rearranging voodoo kick in
      @tree.insert_from_table = true
      # Process the character in the "in body" mode
      @parser.phases[:inBody].processCharacters(data)
      @tree.insert_from_table = false
    end

    def startTagCaption(name, attributes)
      clearStackToTableContext
      @tree.activeFormattingElements.push(Marker)
      @tree.insert_element(name, attributes)
      @parser.phase = @parser.phases[:inCaption]
    end

    def startTagColgroup(name, attributes)
      clearStackToTableContext
      @tree.insert_element(name, attributes)
      @parser.phase = @parser.phases[:inColumnGroup]
    end

    def startTagCol(name, attributes)
      startTagColgroup('colgroup', {})
      @parser.phase.processStartTag(name, attributes)
    end

    def startTagRowGroup(name, attributes)
      clearStackToTableContext
      @tree.insert_element(name, attributes)
      @parser.phase = @parser.phases[:inTableBody]
    end

    def startTagImplyTbody(name, attributes)
      startTagRowGroup('tbody', {})
      @parser.phase.processStartTag(name, attributes)
    end

    def startTagTable(name, attributes)
      parse_error("unexpected-start-tag-implies-end-tag",
            {"startName" => "table", "endName" => "table"})
      @parser.phase.processEndTag('table')
      @parser.phase.processStartTag(name, attributes) unless @parser.inner_html
    end

    def startTagOther(name, attributes)
      parse_error("unexpected-start-tag-implies-table-voodoo",
              {"name" => name})
      # Make all the special element rearranging voodoo kick in
      @tree.insert_from_table = true
      # Process the start tag in the "in body" mode
      @parser.phases[:inBody].processStartTag(name, attributes)
      @tree.insert_from_table = false
    end

    def endTagTable(name)
      if in_scope?('table', true)
        @tree.generateImpliedEndTags

        unless @tree.open_elements.last.name == 'table'
          parse_error("end-tag-too-early-named",
                    {"gotName" => "table",
                     "expectedName" => @tree.open_elements.last.name})
        end

        remove_open_elements_until('table')

        @parser.reset_insertion_mode
      else
        # inner_html case
        assert @parser.inner_html
        parse_error
      end
    end

    def endTagIgnore(name)
      parse_error("unexpected-end-tag", {"name" => name})
    end

    def endTagOther(name)
      parse_error("unexpected-end-tag-implies-table-voodoo", {"name" => name})
      # Make all the special element rearranging voodoo kick in
      @tree.insert_from_table = true
      # Process the end tag in the "in body" mode
      @parser.phases[:inBody].processEndTag(name)
      @tree.insert_from_table = false
    end

    protected

    def clearStackToTableContext
      # "clear the stack back to a table context"
      until %w[table html].include?(name = @tree.open_elements.last.name)
        parse_error("unexpected-implied-end-tag-in-table",
                {"name" =>  @tree.open_elements.last.name})
        @tree.open_elements.pop
      end
      # When the current node is <html> it's an inner_html case
    end

  end
end
