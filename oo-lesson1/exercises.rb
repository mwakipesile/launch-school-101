# 3. Missing writer method. Can be fixed by one of the following
# i defining name instance method
def name=(name)
	@name = name
end

# ii adding attr_writer
attr_writer :name

# iii changing attr_reader to attr_accessor so it can both read and write
attr_accessor :name