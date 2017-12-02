module calc.analysis.token;

enum TokenKind
{
	eof,
	identifier,
	number,
	plus,       // +
	minus,      // -
	star,       // *
	slash,      // /
	assign,     // =
	leftParen,  // (
	rightParen, // )
	comma,      // ,
}

class Token
{
	private TokenKind _kind;
	private string    _text;
	private double    _number;

	this(TokenKind kind, string text, double number = 0) pure nothrow
	{
		this._kind   = kind;
		this._text   = text;
		this._number = number;
	}

	@property
	TokenKind kind() inout pure nothrow
	{
		return this._kind;
	}

	@property
	inout(string) text() inout pure nothrow
	{
		return this._text;
	}

	@property
	double number() inout pure nothrow
	{
		return this._number;
	}
}
