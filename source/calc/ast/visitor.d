module calc.ast.visitor;

public import std.algorithm: castSwitch;

template Visitor()
{
	private auto dispatch(string func, Args...)(Expression node, Args args)
	{
		return node.castSwitch!(
			(Number         node) => mixin(func)(node, args),
			(Variable       node) => mixin(func)(node, args),
			(Addition       node) => mixin(func)(node, args),
			(Subtraction    node) => mixin(func)(node, args),
			(Multiplication node) => mixin(func)(node, args),
			(Division       node) => mixin(func)(node, args),
			(Power          node) => mixin(func)(node, args),
			(Positive       node) => mixin(func)(node, args),
			(Negative       node) => mixin(func)(node, args),
			(Logarithm      node) => mixin(func)(node, args),
			(Sine           node) => mixin(func)(node, args),
			(Cosine         node) => mixin(func)(node, args),
			(Tangent        node) => mixin(func)(node, args),
		)();
	}
}
