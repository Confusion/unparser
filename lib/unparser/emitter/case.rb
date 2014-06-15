# encoding: utf-8

module Unparser
  class Emitter
    # Emitter for case nodes
    class Case < self

      handle :case

      children :condition

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        write(K_CASE)
        emit_condition
        emit_whens
        emit_else
        k_end
      end

      # Emit else
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_else
        else_branch = children.last
        return unless else_branch
        write(K_ELSE)
        visit_indented(else_branch)
      end

      # Emit whens
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_whens
        nl
        children[1..-2].each(&method(:visit))
      end

      # Emit condition
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_condition
        return unless condition
        write(WS)
        visit_terminated(condition)
      end

    end # Case

    # Emitter for when nodes
    class When < self

      handle :when

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        write(K_WHEN, WS)
        emit_captures
        body = children.last
        emit_body(body)
      end

      # Emit captures
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_captures
        delimited(children[0..-2])
      end

    end
  end # Emitter
end # Unparser
