require 'ostruct'

class MainWindowController < NSWindowController

	attr_writer :textView
	
	def awakeFromNib
		self.window.title = "Process Explorer"
	end
	
end