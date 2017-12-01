module calc.ast.node;

abstract class Expression
{
}

abstract class UnaryExpression: Expression
{
	private Expression _operand;

	this(Expression operand) pure nothrow
	{
		assert(operand);

		this._operand  = operand;
	}

	@property
	inout(Expression) operand() inout pure nothrow
	{
		return this._operand;
	}

	override bool opEquals(Object rhs)
	{
		if (typeid(this) != typeid(rhs)) return false;

		return this.operand == (cast(UnaryExpression)rhs).operand;
	}
}

abstract class BinaryExpression: Expression
{
	private Expression _left;
	private Expression _right;

	this(Expression left, Expression right) pure nothrow
	{
		assert(left);
		assert(right);

		this._left  = left;
		this._right = right;
	}

	@property
	inout(Expression) left() inout pure nothrow
	{
		return this._left;
	}

	@property
	inout(Expression) right() inout pure nothrow
	{
		return this._right;
	}

	override bool opEquals(Object rhs)
	{
		if (typeid(this) != typeid(rhs)) return false;

		auto r = cast(BinaryExpression)rhs;

		return this.left == r.left && this.right == r.right;
	}
}

class Number: Expression
{
	private double _value;

	this(double value) pure nothrow
	{
		this._value = value;
	}

	@property
	double value() inout pure nothrow
	{
		return this._value;
	}

	override bool opEquals(Object rhs)
	{
		auto r = cast(typeof(this))rhs;

		return r && this.value == r.value;
	}
}

class Variable: Expression
{
	private string _name;

	this(string name) pure nothrow
	{
		assert(name);

		this._name = name;
	}

	@property
	inout(string) name() inout pure nothrow
	{
		return this._name;
	}

	override bool opEquals(Object rhs)
	{
		auto r = cast(typeof(this))rhs;

		return r && this.name == r.name;
	}
}

class Addition: BinaryExpression
{
	this(Expression left, Expression right) pure nothrow
	{
		super(left, right);
	}
}

class Subtraction: BinaryExpression
{
	this(Expression left, Expression right) pure nothrow
	{
		super(left, right);
	}
}

class Multiplication: BinaryExpression
{
	this(Expression left, Expression right) pure nothrow
	{
		super(left, right);
	}
}

class Division: BinaryExpression
{
	this(Expression left, Expression right) pure nothrow
	{
		super(left, right);
	}
}

class Power: BinaryExpression
{
	this(Expression left, Expression right) pure nothrow
	{
		super(left, right);
	}
}

class Positive: UnaryExpression
{
	this(Expression operand) pure nothrow
	{
		super(operand);
	}
}

class Negative: UnaryExpression
{
	this(Expression operand) pure nothrow
	{
		super(operand);
	}
}

class Logarithm: UnaryExpression
{
	this(Expression operand) pure nothrow
	{
		super(operand);
	}
}

class Sine: UnaryExpression
{
	this(Expression operand) pure nothrow
	{
		super(operand);
	}
}

class Cosine: UnaryExpression
{
	this(Expression operand) pure nothrow
	{
		super(operand);
	}
}

class Tangent: UnaryExpression
{
	this(Expression operand) pure nothrow
	{
		super(operand);
	}
}
