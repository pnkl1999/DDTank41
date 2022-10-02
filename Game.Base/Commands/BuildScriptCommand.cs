using Game.Server.Managers;

namespace Game.Base.Commands
{
    [Cmd("&cs", ePrivLevel.Player, "Compile the C# scripts.", new string[]
	{
		"/cs  <source file> <target> <importlib>",
		"eg: /cs ./scripts temp.dll game.base.dll,game.logic.dll"
	})]
	public class BuildScriptCommand : AbstractCommandHandler, ICommandHandler
    {
        public bool OnCommand(BaseClient client, string[] args)
        {
			if (args.Length >= 4)
			{
				string path = args[1];
				string target = args[2];
				string libs = args[3];
				ScriptMgr.CompileScripts(compileVB: false, path, target, libs.Split(','));
			}
			else
			{
				DisplaySyntax(client);
			}
			return true;
        }
    }
}
