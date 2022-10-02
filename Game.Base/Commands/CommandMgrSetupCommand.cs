namespace Game.Base.Commands
{
    [Cmd("&cmd", ePrivLevel.Admin, "Config the command system.", new string[]
	{
		"/cmd [option] <para1> <para2>      ",
		"eg: /cmd -reload           :Reload the command system.",
		"    /cmd -list             :Display all commands."
	})]
	public class CommandMgrSetupCommand : AbstractCommandHandler, ICommandHandler
    {
        public bool OnCommand(BaseClient client, string[] args)
        {
			if (args.Length > 1)
			{
				string a = args[1];
				if (!(a == "-reload"))
				{
					if (a == "-list")
					{
						CommandMgr.DisplaySyntax(client);
					}
					else
					{
						DisplaySyntax(client);
					}
				}
				else
				{
					CommandMgr.LoadCommands();
				}
			}
			else
			{
				DisplaySyntax(client);
			}
			return true;
        }
    }
}
