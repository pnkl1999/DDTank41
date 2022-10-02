using System;
using System.Collections.Generic;
using System.Reflection;

namespace Game.Server.HotSpringRooms.TankHandle
{
    public class HotSpringCommandMgr
    {
        private Dictionary<int, IHotSpringCommandHandler> cmd = new Dictionary<int, IHotSpringCommandHandler>();

        public HotSpringCommandMgr()
        {
			cmd.Clear();
			SearchCommandHandlers(Assembly.GetAssembly(typeof(GameServer)));
        }

        public IHotSpringCommandHandler LoadCommandHandler(int code)
        {
			return cmd[code];
        }

        protected void RegisterCommandHandler(int code, IHotSpringCommandHandler handle)
        {
			cmd.Add(code, handle);
        }

        protected int SearchCommandHandlers(Assembly assembly)
        {
			int i = 0;
			Type[] types = assembly.GetTypes();
			Type[] array = types;
			foreach (Type type in array)
			{
				if (type.IsClass && type.GetInterface("Game.Server.HotSpringRooms.TankHandle.IHotSpringCommandHandler") != null)
				{
					HotSpringCommandAttbute[] array2 = (HotSpringCommandAttbute[])type.GetCustomAttributes(typeof(HotSpringCommandAttbute), inherit: true);
					if (array2.Length != 0)
					{
						i++;
						RegisterCommandHandler(array2[0].Code, Activator.CreateInstance(type) as IHotSpringCommandHandler);
					}
				}
			}
			return i;
        }
    }
}
