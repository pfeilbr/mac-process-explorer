module MacRubyExt

	class System
		
		class << self

			def which(command)
				# search for which executable in the following paths
				search_dir_paths = ['/bin', '/usr/bin', '/usr/local/bin']
				which_path = nil
				search_dir_paths.each do |dir_path|
					which_path = "#{dir_path}/which"
					break if File.exists?(which_path)
				end
				
				result = run_command(which_path, command)
				return result.chomp
			end

			def run_command(command, command_args)
				# task setup
				task = NSTask.alloc.init
				task.launchPath = (command.index(File::SEPARATOR) != nil) ? command : which(command) 
				task.arguments = command_args.is_a?(Array) ? command_args : [command_args]
				
				# pipe to capture output
				pipe = NSPipe.pipe
				task.standardOutput = pipe
				file = pipe.fileHandleForReading
				
				# run
				task.launch
				
				# get output as string
				data = file.readDataToEndOfFile
				output = NSString.alloc.initWithData(data, encoding:NSUTF8StringEncoding)
				
				return output
			end
		
		end
		
	end

end