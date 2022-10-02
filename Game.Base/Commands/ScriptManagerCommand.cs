using Game.Server.Managers;
using System;
using System.IO;
using System.Reflection;

namespace Game.Base.Commands
{
    [Cmd("&sm", ePrivLevel.Player, "Script Manager console commands.", new string[]
	{
		"   /sm  <option>  [para1][para2]...",
		"eg: /sm -list              : List all assemblies in scripts array.",
		"    /sm -add <assembly>    : Add assembly into the scripts array.",
		"    /sm -remove <assembly> : Remove assembly from the scripts array."
	})]
	public class ScriptManagerCommand : AbstractCommandHandler, ICommandHandler
    {
        public bool OnCommand(BaseClient client, string[] args)
        {
			if (args.Length > 1)
			{
				switch (args[1])
				{
				case "-list":
				{
					Assembly[] scripts = ScriptMgr.Scripts;
					Assembly[] array = scripts;
					foreach (Assembly ass in array)
					{
						DisplayMessage(client, ass.FullName);
					}
					return true;
				}
				case "-add":
					if (args.Length > 2 && args[2] != null && File.Exists(args[2]))
					{
						try
						{
							if (ScriptMgr.InsertAssembly(Assembly.LoadFile(args[2])))
							{
								DisplayMessage(client, "Add assembly success!");
								return true;
							}
							DisplayMessage(client, "Assembly already exists in the scripts array!");
							return false;
						}
						catch (Exception ex)
						{
							DisplayMessage(client, "Add assembly error:", ex.Message);
							return false;
						}
					}
					DisplayMessage(client, "Can't find add assembly!");
					return false;
				case "-remove":
					if (args.Length > 2 && args[2] != null && File.Exists(args[2]))
					{
						try
						{
							if (ScriptMgr.RemoveAssembly(Assembly.LoadFile(args[2])))
							{
								DisplayMessage(client, "Remove assembly success!");
								return true;
							}
							DisplayMessage(client, "Assembly didn't exist in the scripts array!");
							return false;
						}
						catch (Exception ex2)
						{
							DisplayMessage(client, "Remove assembly error:", ex2.Message);
							return false;
						}
					}
					DisplayMessage(client, "Can't find remove assembly!");
					return false;
				default:
					DisplayMessage(client, "Can't fine option:{0}", args[1]);
					return true;
				}
			}
			DisplaySyntax(client);
			return true;
        }
    }
}
