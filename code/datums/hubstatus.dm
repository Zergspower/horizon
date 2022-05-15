/datum/hubstatus
	var/hostedby
	var/popcap
	var/server_name
	var/server_desc
	var/website_url
	var/clients
	var/players
	var/list/navlinks_list

/datum/hubstatus/proc/get_status()
	clients = GLOB.clients.len
	players = GLOB.player_list.len

	if(config)
		website_url = CONFIG_GET(string/websiteurl)
		var/forum_url = CONFIG_GET(string/forumurl)

		// TODO: make this more configurable, don't hardcode Forum == Discord. Sorry downstreams, please edit or overwrite this for the meantime.
		navlinks_list = list()
		if(website_url)
			navlinks_list.Add("<a href=\"[website_url]\">Website</a>")
		if(forum_url)
			navlinks_list.Add("<a href=\"[forum_url]\">Discord</a>")

		hostedby = CONFIG_GET(string/hostedby)
		popcap = max(CONFIG_GET(number/extreme_popcap), CONFIG_GET(number/hard_popcap), CONFIG_GET(number/soft_popcap))
		server_name = CONFIG_GET(string/servername)
		server_desc = CONFIG_GET(string/serverdesc)

	server_name = server_name ? server_name : station_name()

	// Intermediates, that get constructed partly with config values.
	// Make sure these can return valid values even if no config is loaded!
	var/navlinks = navlinks_list.len ? " &#x2014; [jointext(navlinks_list, " | ")]" : ""
	var/population_text = "[clients][popcap ? "/[popcap]" : ""] connected, [players] playing"
	var/map_text = "Current Map: [SSmapping.config.map_name]"
	var/hostedby_text = hostedby && !host ? " | Hosted by [hostedby]" : ""

	// Our custom status construct
	var/hubstatus = {"
	<b>[website_url ? "<a href=\"[website_url]\">[server_name]</a>" : server_name]</b>[navlinks]&#x005D;
	[server_desc ? "<i>[server_desc]</i>" : ""]

	[map_text]
	&#x005B;[population_text][hostedby_text]"}

	return hubstatus
