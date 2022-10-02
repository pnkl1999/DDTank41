using Game.Base.Events;
using Game.Server.Managers;
using log4net;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using System.Text;

namespace Game.Base
{
    public class CommandMgr
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private static Hashtable m_cmds = new Hashtable(StringComparer.InvariantCultureIgnoreCase);

        private static string[] m_disabledarray = new string[0];

        public static string[] DisableCommands
        {
			get
			{
				return m_disabledarray;
			}
			set
			{
				m_disabledarray = ((value == null) ? new string[0] : value);
			}
        }

        public static GameCommand GetCommand(string cmd)
        {
			return m_cmds[cmd] as GameCommand;
        }

        public static GameCommand GuessCommand(string cmd)
        {
			GameCommand myCommand = GetCommand(cmd);
			if (myCommand != null)
			{
				return myCommand;
			}
			string compareCmdStr = cmd.ToLower();
			IDictionaryEnumerator iter = m_cmds.GetEnumerator();
			while (iter.MoveNext())
			{
				GameCommand currentCommand = iter.Value as GameCommand;
				string currentCommandStr = iter.Key as string;
				if (currentCommand != null && currentCommandStr.ToLower().StartsWith(compareCmdStr))
				{
					myCommand = currentCommand;
					break;
				}
			}
			return myCommand;
        }

        public static string[] GetCommandList(ePrivLevel plvl, bool addDesc)
        {
			IDictionaryEnumerator iter = m_cmds.GetEnumerator();
			ArrayList list = new ArrayList();
			while (iter.MoveNext())
			{
				GameCommand cmd = iter.Value as GameCommand;
				string cmdString = iter.Key as string;
				if (cmd == null || cmdString == null)
				{
					continue;
				}
				if (cmdString[0] == '&')
				{
					cmdString = "/" + cmdString.Remove(0, 1);
				}
				if ((uint)plvl >= cmd.m_lvl)
				{
					if (addDesc)
					{
						list.Add(cmdString + " - " + cmd.m_desc);
					}
					else
					{
						list.Add(cmd.m_cmd);
					}
				}
			}
			return (string[])list.ToArray(typeof(string));
        }

        [ScriptLoadedEvent]
		public static void OnScriptCompiled(RoadEvent ev, object sender, EventArgs args)
        {
			LoadCommands();
        }

        public static bool LoadCommands()
        {
			m_cmds.Clear();
			foreach (Assembly script in new ArrayList(ScriptMgr.Scripts))
			{
				if (log.IsDebugEnabled)
				{
					log.Debug("ScriptMgr: Searching for commands in " + script.GetName());
				}
				Type[] types = script.GetTypes();
				Type[] array = types;
				foreach (Type type in array)
				{
					if (!type.IsClass || type.GetInterface("Game.Base.ICommandHandler") == null)
					{
						continue;
					}
					try
					{
						object[] customAttributes = type.GetCustomAttributes(typeof(CmdAttribute), inherit: false);
						for (int i = 0; i < customAttributes.Length; i++)
						{
							CmdAttribute attrib = (CmdAttribute)customAttributes[i];
							bool disabled = false;
							string[] disabledarray = m_disabledarray;
							string[] array2 = disabledarray;
							foreach (string str in array2)
							{
								if (attrib.Cmd.Replace('&', '/') == str)
								{
									disabled = true;
									log.Info("Will not load command " + attrib.Cmd + " as it is disabled in game properties");
									break;
								}
							}
							if (disabled)
							{
								continue;
							}
							if (m_cmds.ContainsKey(attrib.Cmd))
							{
								log.Info(string.Concat(attrib.Cmd, " from ", script.GetName(), " has been suppressed, a command of that type already exists!"));
								continue;
							}
							if (log.IsDebugEnabled)
							{
								log.Debug("Load: " + attrib.Cmd + "," + attrib.Description);
							}
							GameCommand cmd = new GameCommand();
							cmd.m_usage = attrib.Usage;
							cmd.m_cmd = attrib.Cmd;
							cmd.m_lvl = attrib.Level;
							cmd.m_desc = attrib.Description;
							cmd.m_cmdHandler = (ICommandHandler)Activator.CreateInstance(type);
							m_cmds.Add(attrib.Cmd, cmd);
							if (attrib.Aliases != null)
							{
								disabledarray = attrib.Aliases;
								string[] array3 = disabledarray;
								foreach (string alias in array3)
								{
									m_cmds.Add(alias, cmd);
								}
							}
						}
					}
					catch (Exception e)
					{
						if (log.IsErrorEnabled)
						{
							log.Error("LoadCommands", e);
						}
					}
				}
			}
			log.Info("Loaded " + m_cmds.Count + " commands!");
			return true;
        }

        public static void DisplaySyntax(BaseClient client)
        {
			client.DisplayMessage("Commands list:");
			string[] commandList = GetCommandList(ePrivLevel.Admin, addDesc: true);
			string[] array = commandList;
			foreach (string str in array)
			{
				client.DisplayMessage("         " + str);
			}
        }

        public static bool HandleCommandNoPlvl(BaseClient client, string cmdLine)
        {
			try
			{
				string[] pars = ParseCmdLine(cmdLine);
				GameCommand myCommand = GuessCommand(pars[0]);
				if (myCommand == null)
				{
					return false;
				}
				ExecuteCommand(client, myCommand, pars);
			}
			catch (Exception e)
			{
				if (log.IsErrorEnabled)
				{
					log.Error("HandleCommandNoPlvl", e);
				}
			}
			return true;
        }

        private static bool ExecuteCommand(BaseClient client, GameCommand myCommand, string[] pars)
        {
			pars[0] = myCommand.m_cmd;
			return myCommand.m_cmdHandler.OnCommand(client, pars);
        }

        private static string[] ParseCmdLine(string cmdLine)
        {
			if (cmdLine == null)
			{
				throw new ArgumentNullException("cmdLine");
			}
			List<string> args = new List<string>();
			int state = 0;
			StringBuilder arg = new StringBuilder(cmdLine.Length >> 1);
			for (int i = 0; i < cmdLine.Length; i++)
			{
				char c = cmdLine[i];
				switch (state)
				{
				case 0:
					if (c != ' ')
					{
						arg.Length = 0;
						if (c == '"')
						{
							state = 2;
							break;
						}
						state = 1;
						i--;
					}
					break;
				case 1:
					if (c == ' ')
					{
						args.Add(arg.ToString());
						state = 0;
					}
					arg.Append(c);
					break;
				case 2:
					if (c == '"')
					{
						args.Add(arg.ToString());
						state = 0;
					}
					arg.Append(c);
					break;
				}
			}
			if (state != 0)
			{
				args.Add(arg.ToString());
			}
			string[] pars = new string[args.Count];
			args.CopyTo(pars);
			return pars;
        }
    }
}
