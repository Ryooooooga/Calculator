module calc.analysis.input_stream;

import std.stdio;
import calc.analysis.i_input_stream;

class InputStream: IInputStream
{
	private File _stream;

	this(File stream)
	{
		this._stream = stream;
	}

	@property
	override bool eof() inout pure
	{
		return this._stream.eof;
	}

	override string readLine()
	{
		return this._stream.readln();
	}
}
