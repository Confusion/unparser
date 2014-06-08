# encoding: utf-8

module Unparser
  class Emitter

    # Arg expr (pattern args) emitter
    class ArgExpr < self

      handle :arg_expr

      children :body

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        parentheses do
          visit(body)
        end
      end
    end # ArgExpr

    # Arguments emitter
    class Arguments < self

      handle :args

      SHADOWARGS = ->(node) { node.type == :shadowarg }.freeze

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        delimited(normal_arguments)
        return if shadowargs.empty?
        write('; ')
        delimited(shadowargs)
      end

      # Return normal arguments
      #
      # @return [Enumerable<Parser::AST::Node>]
      #
      # @api private
      #
      def normal_arguments
        children.reject(&SHADOWARGS).map do |child|
          if child.type == :mlhs
            Parser::AST::Node.new(:arg_expr, [child])
          else
            child
          end
        end
      end

      # Return shadow args
      #
      # @return [Enumerable<Parser::AST::Node>]
      #
      # @api private
      #
      def shadowargs
        children.select(&SHADOWARGS)
      end
      memoize :shadowargs

    end # Arguments

    # Emitter for block arguments
    class Blockarg < self

      handle :blockarg

      children :name

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        write(T_AMP, name.to_s)
      end

    end # Blockarg

    # Optional argument emitter
    class Optarg < self

      handle :optarg

      children :name, :value

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        write(name.to_s, WS, T_ASN, WS)
        visit(value)
      end
    end

    # Keyword rest argument emitter
    class KeywordRest < self

      handle :kwrestarg

      children :name

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        write(T_DSPLAT, name.to_s)
      end
    end # KeywordRest

    # Optional keyword argument emitter
    class KeywordOptional < self
      handle :kwoptarg

      children :name, :value

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        write(name.to_s, T_COLON, WS)
        visit(value)
      end

    end # KeywordOptional

    # Keyword argument emitter
    class Kwarg < self
      handle :kwarg

      children :name

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        write(name.to_s, T_COLON)
      end

    end # Restarg

    # Rest argument emitter
    class Restarg < self

      handle :restarg

      children :name

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        write(T_SPLAT, name.to_s)
      end

    end # Restarg

    # Argument emitter
    class Argument < self

      handle :arg, :shadowarg

      children :name

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        write(name.to_s)
      end

    end # Argument

    # Block pass node emitter
    class BlockPass < self

      handle :block_pass

      children :name

    private

      # Perform dispatch
      #
      # @return [undefined]
      #
      # @api private
      #
      def dispatch
        write(T_AMP)
        visit_terminated(name)
      end

    end # BlockPass

  end # Emitter
end # Unparser
