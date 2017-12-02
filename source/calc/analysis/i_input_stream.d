module calc.analysis.i_input_stream;

interface IInputStream
{
	@property
	bool eof() inout;

	string readLine();
}
