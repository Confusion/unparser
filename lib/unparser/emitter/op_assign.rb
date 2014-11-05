# encoding: utf-8

module Unparser
  class Emitter

    # Base class for and and or op-assign
    class BinaryAssign < self

      children :target, :expression

      MAP = IceNine.deep_freeze(
        and_asgn: '&&=',
        or_asgn:  '||='
      )

      handle(*MAP.keys)

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        visit(target)
        write(WS, MAP.fetch(node.type), WS)
        visit_terminated(expression)
      end

    end # BinaryAssign

    # Emitter for op assign
    class OpAssign < self

      handle :op_asgn

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        visit(first_child)
        emit_operator
        visit_terminated(children[2])
      end

      # Emit operator
      #
      # @return [undefined]
      #
      # @api private
      #
      def emit_operator
        write(WS, children[1].to_s, T_ASN, WS)
      end

    end # OpAssign
  end # Emitte
end # Unparser
