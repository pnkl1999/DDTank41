using Game.Base.Events;
using log4net;
using System;
using System.Collections.Generic;
using System.Reflection;

namespace Game.Logic.Cmd
{
    public class CommandMgr
    {
        private static Dictionary<int, ICommandHandler> handles = new Dictionary<int, ICommandHandler>();

        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public static ICommandHandler LoadCommandHandler(int code)
        {
			if (handles.ContainsKey(code))
			{
				return handles[code];
			}
			log.Error("LoadCommandHandler code030: " + code);
			return null;
        }

        [ScriptLoadedEvent]
		public static void OnScriptCompiled(RoadEvent ev, object sender, EventArgs args)
        {
			handles.Clear();
			SearchCommandHandlers(Assembly.GetAssembly(typeof(BaseGame)));
        }

        protected static int SearchCommandHandlers(Assembly assembly)
        {
			int count = 0;
			Type[] types = assembly.GetTypes();
			foreach (Type type in types)
			{
				if (type.IsClass && !(type.GetInterface("Game.Logic.Cmd.ICommandHandler") == null))
				{
					GameCommandAttribute[] attr = (GameCommandAttribute[])type.GetCustomAttributes(typeof(GameCommandAttribute), inherit: true);
					if (attr.Length != 0)
					{
                        count++;
						RegisterCommandHandler(attr[0].Code, Activator.CreateInstance(type) as ICommandHandler);
					}
				}
			}
			return count;
        }

        protected static void RegisterCommandHandler(int code, ICommandHandler handle)
        {
			handles.Add(code, handle);
        }
    }
}
