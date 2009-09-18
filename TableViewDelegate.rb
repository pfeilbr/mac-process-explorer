require 'mac_ruby_ext'

class TableViewDelegate

	def awakeFromNib
		@column_sort_desc = {}
		@sort_toggle = true	
		@processes = get_process_info
	end

	def numberOfRowsInTableView(aTableView)
		processes.size
	end

	def tableView(aTableView, objectValueForTableColumn:aTableColumn, row:rowIndex)
		identifier = aTableColumn.identifier
		puts identifier
		rows = processes
		rows[rowIndex].send identifier.to_sym
	end

	def tableView(aTableView, shouldEditTableColumn:aTableColumn, row:rowIndex)
		true
	end
	
	def tableView(tableView, didClickTableColumn:tableColumn)
		columnIdentifier = tableColumn.identifier
		@processes.sort! do |a, b|
			a_val = a.send(columnIdentifier.to_sym)
			b_val = b.send(columnIdentifier.to_sym)
			a_val = numeric?(a_val) ? a_val.to_i : a_val
			b_val = numeric?(b_val) ? b_val.to_i : b_val
			if !@column_sort_desc[columnIdentifier]
				a_val <=> b_val
			else
				b_val <=> a_val
			end
		end
		@column_sort_desc[columnIdentifier] = !@column_sort_desc[columnIdentifier]
		tableView.reloadData
	end
	
	def get_process_info		
		output = MacRubyExt::System.run_command("ps", "aux")
		
		lines = output.split("\n")
		
		arr = []
		lines.each do |line|
			process = OpenStruct.new
			fields = line.split
			process.pid = fields[1]
			process.command = fields.slice(10, 100).join(" ")
			arr << process
		end	
		arr.slice(1, arr.size)
	end
	
	def processes
		@processes
	end
	
	
	def numeric?(object)
		true if Float(object) rescue false
	end
	

end