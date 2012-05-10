module serialize_utils.nit

redef class String
	fun to_f : Float is extern import String::to_cstring
end
