using System;
using System.Collections.Generic;
using System.Reflection;

namespace Game.Server.Consortia.Handle
{
    public class ConsortiaHandleMgr
    {
        private Dictionary<int, IConsortiaCommandHadler> dictionary_0;

        public IConsortiaCommandHadler LoadCommandHandler(int code)
        {
			return dictionary_0[code];
        }

        public ConsortiaHandleMgr()
        {
			dictionary_0 = new Dictionary<int, IConsortiaCommandHadler>();
			dictionary_0.Clear();
			SearchCommandHandlers(Assembly.GetAssembly(typeof(GameServer)));
        }

        protected int SearchCommandHandlers(Assembly assembly)
        {
			int num = 0;
			Type[] types = assembly.GetTypes();
			Type[] array = types;
			foreach (Type type in array)
			{
				if (type.IsClass && !(type.GetInterface("Game.Server.Consortia.Handle.IConsortiaCommandHadler") == null))
				{
					ConsortiaHandleAttbute[] array2 =
					(ConsortiaHandleAttbute[])type.GetCustomAttributes(typeof(ConsortiaHandleAttbute), true);
					if (array2.Length != 0)
					{
						num++;
						RegisterCommandHandler(array2[0].Code, Activator.CreateInstance(type) as IConsortiaCommandHadler);
					}
				}
			}
			return num;
        }

        protected void RegisterCommandHandler(int code, IConsortiaCommandHadler handle)
        {
			dictionary_0.Add(code, handle);
        }
    }
}
