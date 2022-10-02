using System;
using System.Collections.Generic;
using System.Reflection;

namespace Game.Server.SceneMarryRooms.TankHandle
{
    public class MarryCommandMgr
    {
        private Dictionary<int, IMarryCommandHandler> handles = new Dictionary<int, IMarryCommandHandler>();

        public MarryCommandMgr()
        {
			handles.Clear();
			SearchCommandHandlers(Assembly.GetAssembly(typeof(GameServer)));
        }

        public IMarryCommandHandler LoadCommandHandler(int code)
        {
			return handles[code];
        }

        protected void RegisterCommandHandler(int code, IMarryCommandHandler handle)
        {
			handles.Add(code, handle);
        }

        protected int SearchCommandHandlers(Assembly assembly)
        {
			int num = 0;
			Type[] types = assembly.GetTypes();
			Type[] array = types;
			foreach (Type type in array)
			{
				if (type.IsClass && type.GetInterface("Game.Server.SceneMarryRooms.TankHandle.IMarryCommandHandler") != null)
				{
					MarryCommandAttbute[] array2 = (MarryCommandAttbute[])type.GetCustomAttributes(typeof(MarryCommandAttbute), inherit: true);
					if (array2.Length != 0)
					{
						num++;
						RegisterCommandHandler(array2[0].Code, Activator.CreateInstance(type) as IMarryCommandHandler);
					}
				}
			}
			return num;
        }
    }
}
