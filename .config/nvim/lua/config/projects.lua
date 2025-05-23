local HOME = os.getenv('HOME')
local CODE_DIR = HOME .. '/code'

return {
	disney_planning_data_sourcing = {
		path = CODE_DIR .. '/disney_planning/server/data_sourcing',
		run_cmd = 'go run -race .',
		build_cmd = 'go build -race .',
		formatted_name = 'Disney Planning - Data Sourcing'
	},
}
