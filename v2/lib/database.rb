class DataBase ##{
	"""
	A base class that can be adopted by specific language supporter, such as SVSupport class, which can
	process SV specific syntax markdown files.
	This class will provide some of the common APIs/fields like processSource, that can start processing
	a source file
	"""

	def processSource; end
end ##}